import 'dart:async';
import 'dart:convert';

import 'package:fl_lib/fl_lib.dart';
import 'package:fl_pi_llm_ui/fl_pi_llm_ui.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:llmbox/core/lkc.dart';
import 'package:llmbox/core/util/sync.dart';
import 'package:llmbox/data/store/all.dart';

/// The operation-log sync (fl_lib's engine): each edit sent as it is made, to
/// LK Cloud's log, or as segment files beside the backup on iCloud or WebDAV.
///
/// Records: the synced stores' keys (`kv:<store>`), and each chat entry
/// ([chatEntries], `chat`/`<chat id>/<uid>`). An entry is never changed once
/// written, so the newest-stamp-wins rule loses nothing; its parent was
/// stamped before it, so it arrives first. The whole backup ([BakSync]) syncs
/// beside it as before.
abstract final class LogSyncs {
  /// Homebase's name for the app: what its data there is kept under, for good.
  static const app = 'llmbox';

  /// Whether this device syncs to LK Cloud. Device local. Key is permanent.
  static const lkcEnabled = PrefPropDefault('lkc_sync', false, updateLastUpdateTsOnSetProp: false);

  /// The groups a person can leave out on a device. Keys are permanent.
  static final chats = SyncGroup(
    name: 'chats',
    pref: const PrefPropDefault('sync_chats', true, updateLastUpdateTsOnSetProp: false),
    collections: {SyncRecorder.kvOf(LlmStores.chat), chatEntries},
  );
  static final ai = SyncGroup(
    name: 'ai',
    pref: const PrefPropDefault('sync_ai', true, updateLastUpdateTsOnSetProp: false),
    collections: {for (final s in [LlmStores.llm, LlmStores.tool, LlmStores.memory]) SyncRecorder.kvOf(s)},
  );
  static final secrets = SyncGroup(
    name: 'secrets',
    pref: const PrefPropDefault('sync_secrets', true, updateLastUpdateTsOnSetProp: false),
    collections: {for (final s in [LlmStores.credential, LlmStores.mcpSecret]) SyncRecorder.kvOf(s)},
  );
  static final settings = SyncGroup(
    name: 'settings',
    pref: PrefProps.syncAppSettings,
    collections: {SyncRecorder.kvOf(Stores.setting)},
  );

  /// The chat entries' collection.
  static const chatEntries = 'chat';

  static final lkc = LkcLogSync(client: Lkc.client, app: app, enabled: lkcEnabled.listenable());

  static final files = FileLogSync(
    remote: () => BakSync.instance.remoteStorage,
    folder: 'llmbox_sync',
    on: () => BakSync.enabled,
    webdavAccount: PrefProps.webdavUser.get,
    changes: [PrefProps.icloudSync.listenable(), PrefProps.webdavSync.listenable()],
  );

  /// Whether the syncs run: fl_lib's Rust is loaded ([install]).
  static bool get ready => _installed;
  static var _installed = false;

  /// What records, before anything is written: at launch, after the stores
  /// open. Without fl_lib's Rust nothing is recorded or synced this way, and
  /// the app runs as before.
  static void install() {
    if (!FlRust.ready) return;
    SyncTables.ensure();
    SyncKeyring.init(label: 'LLMBox sync key');
    SyncRecorder.install([Stores.setting, ...LlmStores.all, LlmStores.credential, LlmStores.mcpSecret]);
    StoreCredentials.adopt = SyncRecorder.adopt;
    SyncGroups.define([settings, chats, ai, secrets]);
    SyncRecords.kinds[chatEntries] = const SyncKind.many(readMany: _readEntries, install: _installEntries);
    SyncRecords.announce = _announce;
    SyncRecords.afterRead = (_) => _retryWaiting();
    Chats.onChanged = (id) => unawaited(_recordEntries(id));
    // A chat deleted here: what was kept of its entries goes too.
    LlmStores.chat.watch().listen((id) {
      if (LlmStores.chat.fetch(id) == null) _forgetChat(id);
    });
    _installed = true;
  }

  /// Starts the syncs, after [install]. LK Cloud's waits for its session
  /// itself; the files' need none.
  static Future<void> start() async {
    if (!_installed) return;
    try {
      await _seed();
      await catchUp();
    } catch (e, s) {
      Loggers.app.warning('Log sync: recording what is here', e, s);
    }
    lkc.init();
    LkcSyncWatch.of(lkc, onRemoteChange: () {}, inBackground: isDesktop).start();
    files.init();
  }

  /// Whether what was here before the log is recorded. Device local.
  /// TODO: remove with [_seed].
  static const _seeded = PrefPropDefault('log_sync_seeded', false, updateLastUpdateTsOnSetProp: false);

  /// Records what was here before the log, as no device's at its last change:
  /// the first device to join sends it, and a later edit anywhere wins over
  /// it. Once.
  /// TODO: remove once no install predates the log sync.
  static Future<void> _seed() async {
    if (_seeded.get()) return;
    SyncRecorder.seedStores();
    for (final meta in LlmStores.chat.all(anyScope: true)) {
      await _recordEntries(meta.id, at: meta.updatedAt.millisecondsSinceEpoch);
    }
    await _seeded.set(true);
  }

  /// Records what chats gained without [Chats.onChanged] telling: a run cut
  /// short by the app's end, a whole backup's merge. Only chats whose files
  /// changed since they were last looked at.
  static Future<void> catchUp() async {
    if (!_installed || !SqliteDb.isOpen) return;
    for (final s in await Llm.rt.sessions()) {
      final at = '${s.modifiedAt.millisecondsSinceEpoch}';
      if (_state(_seenKey(s.id)) == at) continue;
      if (LlmStores.chat.fetch(s.id) == null) continue;
      await _recordEntries(s.id);
      _setState(_seenKey(s.id), at);
    }
  }

  static String _cursorKey(String chat) => 'chatcur:$chat';
  static String _seenKey(String chat) => 'chatseen:$chat';
  static const _waitPrefix = 'chatwait:';

  static String? _state(String k) =>
      SqliteDb.instance.select('SELECT v FROM sync_state WHERE k = ?;', [k]).firstOrNull?['v'] as String?;

  static void _setState(String k, String? v) => v == null
      ? SqliteDb.instance.execute('DELETE FROM sync_state WHERE k = ?;', [k])
      : SqliteDb.instance.execute(
          'INSERT INTO sync_state (k, v) VALUES (?, ?) ON CONFLICT (k) DO UPDATE SET v = excluded.v;',
          [k, v],
        );

  /// [_recordEntries], awaited by a test.
  @visibleForTesting
  static Future<void> recordEntries(String chat) => _recordEntries(chat);

  /// Records the entries of [chat] made since the last call: each a record of
  /// its own, unless it came from another device (recorded with its stamp
  /// when it was written). [at] for what was here before the log: one
  /// millisecond apart, the oldest first, so they keep their order.
  static Future<void> _recordEntries(String chat, {int? at}) async {
    if (!_installed || !SqliteDb.isOpen) return;
    final cursor = _state(_cursorKey(chat));
    final List<({int id, String uid})> uids;
    try {
      uids = await Chats.entryUids(chat, after: cursor == null ? null : int.tryParse(cursor));
    } catch (e, s) {
      Loggers.app.warning('Log sync: entries of $chat', e, s);
      return;
    }
    if (uids.isEmpty) return;
    SqliteStore.transact(() {
      final ids = [for (final e in uids) '$chat/${e.uid}'];
      final known = SyncRecorder.stampsOf([for (final id in ids) (chatEntries, id)]);
      for (final (i, id) in ids.indexed) {
        if (known.containsKey((chatEntries, id))) continue;
        if (at == null) {
          SyncRecorder.record(chatEntries, id);
        } else {
          final ms = at - ids.length + i;
          SyncRecorder.applying(() => SyncRecorder.record(chatEntries, id, at: ms));
        }
      }
      _setState(_cursorKey(chat), '${uids.last.id}');
    });
  }

  static (String, String)? _split(String id) {
    final at = id.indexOf('/');
    return at <= 0 ? null : (id.substring(0, at), id.substring(at + 1));
  }

  /// Entries `<chat>/<uid>` as an export holds them, each chat's read at
  /// once; null for one gone (its chat deleted).
  static Future<List<Object?>> _readEntries(List<String> ids) async {
    final byChat = <String, List<String>>{};
    for (final id in ids) {
      final (chat, uid) = _split(id) ?? (throw FormatException('Not a chat entry: $id'));
      (byChat[chat] ??= []).add(uid);
    }
    final read = <String, Map<String, Object?>>{};
    for (final MapEntry(key: chat, value: uids) in byChat.entries) {
      if (LlmStores.chat.fetch(chat) == null) continue;
      for (final e in await Chats.entries(chat, uids)) {
        read['$chat/${e['uid']}'] = e;
      }
    }
    return [for (final id in ids) read[id]];
  }

  /// Other devices' entries, each chat's in the order they were made, into
  /// chats that exist here (whose meta came first, or was here). One whose
  /// parent is not here yet waits, and is tried again after each read.
  static Future<void> _installEntries(List<SyncOp> ops) => _install([..._waiting(), ...ops]);

  static Future<void> _retryWaiting() async {
    final waiting = _waiting();
    if (waiting.isNotEmpty) await _install(waiting);
  }

  static List<SyncOp> _waiting() => [
    for (final row in SqliteDb.instance.select('SELECT k, v FROM sync_state WHERE substr(k, 1, ?) = ?;', [_waitPrefix.length, _waitPrefix]))
      if (jsonDecode(row['v'] as String) case {'h': final String h, 'd': final Object d})
        (c: chatEntries, id: (row['k'] as String).substring(_waitPrefix.length), h: h, d: d),
  ];

  static Future<void> _install(List<SyncOp> ops) async {
    final byChat = <String, List<SyncOp>>{};
    // By stamp, and as they came where two are alike: a parent first.
    final ordered = ops.indexed.toList()
      ..sort((a, b) {
        final byH = a.$2.h.compareTo(b.$2.h);
        return byH != 0 ? byH : a.$1.compareTo(b.$1);
      });
    final seen = <String>{};
    for (final (_, op) in ordered) {
      if (op.d is! Map || !seen.add(op.id)) continue;
      final (chat, _) = _split(op.id) ?? (null, null);
      if (chat == null || LlmStores.chat.fetch(chat) == null) continue;
      (byChat[chat] ??= []).add(op);
    }
    for (final MapEntry(key: chat, value: ops) in byChat.entries) {
      Set<String>? orphans;
      try {
        orphans = (await Chats.importChat(chat, [for (final op in ops) (op.d! as Map).cast<String, Object?>()])).orphans;
      } catch (e, s) {
        Loggers.app.warning('Log sync: entries into $chat', e, s);
      }
      SqliteStore.transact(() {
        for (final op in ops) {
          final (_, uid) = _split(op.id)!;
          if (orphans == null || orphans.contains(uid)) {
            _setState('$_waitPrefix${op.id}', jsonEncode({'h': op.h, 'd': op.d}));
            continue;
          }
          _setState('$_waitPrefix${op.id}', null);
          SyncRecorder.receiving(op.h, () => SyncRecorder.record(chatEntries, op.id));
        }
      });
    }
  }

  /// What was kept of chat [id]'s entries: its records, cursor and waiting
  /// entries. A deleted chat's entries are not sent as removed.
  static void _forgetChat(String id) {
    if (!SqliteDb.isOpen) return;
    SqliteStore.transact(() {
      final db = SqliteDb.instance;
      final prefix = '$id/';
      db.execute('DELETE FROM sync_record WHERE c = ? AND substr(id, 1, ?) = ?;', [chatEntries, prefix.length, prefix]);
      db.execute('DELETE FROM sync_state WHERE k IN (?, ?);', [_cursorKey(id), _seenKey(id)]);
      final wait = '$_waitPrefix$prefix';
      db.execute('DELETE FROM sync_state WHERE substr(k, 1, ?) = ?;', [wait.length, wait]);
    });
  }

  /// Tells the app what other devices changed, as a whole backup's merge does.
  static Future<void> _announce(List<SyncOp> won, Set<String> written) async {
    final chatsKv = SyncRecorder.kvOf(LlmStores.chat);
    if (written.contains(chatsKv)) {
      // Chats deleted there go here with their conversations.
      final here = {for (final s in await Llm.rt.sessions()) s.id};
      for (final op in won) {
        if (op.c != chatsKv || op.d != null) continue;
        await Chats.close(op.id);
        if (here.contains(op.id)) await Llm.rt.deleteSession(op.id);
        if (Chats.current.value == op.id) Chats.current.value = null;
      }
      LlmStores.chat.changes.notify();
    }
    if (written.contains(SyncRecorder.kvOf(LlmStores.llm)) || written.contains(SyncRecorder.kvOf(LlmStores.credential))) {
      await Llm.applyCustomProviders();
    }
    if (written.any((c) => c != chatsKv)) await Chats.reconfigure();
    RNodes.app.notify();
  }
}
