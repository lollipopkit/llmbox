import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/foundation.dart';
import 'package:llmbox/core/util/log_sync.dart';
import 'package:llmbox/data/store/all.dart';
import 'package:llmbox/data/store/setting.dart';
import 'package:fl_pi_llm_ui/fl_pi_llm_ui.dart';

/// A backup is encrypted and there is no password to open it with.
final class BackupPasswordNeeded implements Exception {
  const BackupPasswordNeeded();

  @override
  String toString() => 'The backup is encrypted';
}

/// A backup written by a newer build, in a format this one cannot read.
/// Merging it would lose what this build does not know about.
final class BackupTooNew implements Exception {
  const BackupTooNew(this.version);

  final int version;

  @override
  String toString() => 'The backup is from a newer version of the app (format $version)';
}

/// Everything a user would miss on a new device, except keys: those stay in
/// the keychain of the device they were entered on.
///
/// Chats are fl_pi_llm sessions, carried as their entries, each known by the
/// same uid on every device: merging one writes what this device lacks
/// ([Chats.importChat]). See [merge].
final class Backup implements Mergeable {
  const Backup({
    required this.date,
    required this.chats,
    required this.llm,
    required this.tools,
    required this.memory,
    required this.settings,
    required this.sessions,
  });

  static const formatVersion = 4;

  final int date;
  final Map<String, Object?> chats;
  final Map<String, Object?> llm;
  final Map<String, Object?> tools;

  /// The memory's files, as [MemoryStore] keeps them.
  final Map<String, Object?> memory;

  /// Empty when the backup leaves the settings out (sync without "sync app
  /// settings"): then they are not touched on merge either.
  final Map<String, Object?> settings;

  /// Each chat's session by chat id: its entries ([Chats.exportChat]), and
  /// the uid of the one it stands on.
  final Map<String, ChatExport> sessions;

  static Future<Backup> fromStores({bool includeSettings = true}) async {
    final chats = LlmStores.chat.keys().toSet();
    final sessions = <String, ChatExport>{};
    for (final s in await Llm.rt.sessions()) {
      if (chats.contains(s.id)) sessions[s.id] = await Chats.exportChat(s.id);
    }
    return Backup(
      date: DateTime.now().millisecondsSinceEpoch,
      chats: LlmStores.chat.getAllMap(includeInternalKeys: true),
      llm: LlmStores.llm.getAllMap(includeInternalKeys: true),
      tools: LlmStores.tool.getAllMap(includeInternalKeys: true),
      memory: LlmStores.memory.getAllMap(includeInternalKeys: true),
      settings: includeSettings ? _withoutDeviceLocal(Stores.setting.getAllMap(includeInternalKeys: true)) : const {},
      sessions: sessions,
    );
  }

  /// [data] without this device's own settings, values and timestamps both.
  static Map<String, Object?> _withoutDeviceLocal(Map<String, Object?> data) {
    final ts = data[Stores.setting.lastUpdateTsKey];
    return {
      for (final MapEntry(:key, :value) in data.entries)
        if (!Stores.setting.isDeviceLocalKey(key)) key: value,
      if (ts is Map)
        Stores.setting.lastUpdateTsKey: {
          for (final MapEntry(:key, :value) in ts.entries)
            if (!Stores.setting.isDeviceLocalKey(key)) key: value,
        },
    };
  }

  /// A stamp of everything [fromStores] reads: it changes whenever a backup
  /// would. Cheap, for deciding whether a sync has anything to do.
  static Future<String> localStamp({required bool includeSettings}) async {
    int newest(Map<String, int>? ts) => ts == null || ts.isEmpty ? 0 : ts.values.reduce((a, b) => a > b ? a : b);
    return [
      newest(LlmStores.chat.lastUpdateTs),
      newest(LlmStores.llm.lastUpdateTs),
      newest(LlmStores.tool.lastUpdateTs),
      newest(LlmStores.memory.lastUpdateTs),
      if (includeSettings)
        newest({
          for (final MapEntry(:key, :value) in (Stores.setting.lastUpdateTs ?? const <String, int>{}).entries)
            if (!Stores.setting.isDeviceLocalKey(key)) key: value,
        }),
      newest({for (final s in await Llm.rt.sessions()) s.id: s.modifiedAt.millisecondsSinceEpoch}),
    ].join('.');
  }

  Backup withoutSettings() =>
      Backup(date: date, chats: chats, llm: llm, tools: tools, memory: memory, settings: const {}, sessions: sessions);

  Map<String, Object?> toJson() => {
    'version': formatVersion,
    'date': date,
    'chats': chats,
    'llm': llm,
    'tools': tools,
    'memory': memory,
    'settings': settings,
    'sessions': {
      for (final MapEntry(:key, :value) in sessions.entries) key: {'entries': value.entries, 'tip': value.tip},
    },
  };

  factory Backup.fromJson(Map<String, Object?> j) {
    final v = j['version'];
    if (v is int && v > formatVersion) throw BackupTooNew(v);
    if (v != formatVersion) throw FormatException('Unsupported backup version: $v');
    Map<String, Object?> map(String k) => ((j[k] as Map?) ?? const {}).cast<String, Object?>();
    return Backup(
      date: j['date'] as int? ?? 0,
      chats: map('chats'),
      llm: map('llm'),
      tools: map('tools'),
      memory: map('memory'),
      settings: map('settings'),
      sessions: {
        for (final MapEntry(:key, :value) in map('sessions').entries)
          key: (
            entries: [for (final e in (value as Map)['entries'] as List) (e as Map).cast<String, Object?>()],
            tip: value['tip'] as String?,
          ),
      },
    );
  }

  /// Reads a backup file's text: plain JSON, or encrypted with [password].
  /// Decryption and decoding run off this isolate.
  static Future<Backup> parse(String text, {String? password}) async {
    final trimmed = text.trim();
    if (Cryptor.isEncrypted(trimmed) && (password == null || password.isEmpty)) {
      throw const BackupPasswordNeeded();
    }
    final map = await compute(_decode, (trimmed, password));
    return Backup.fromJson(map);
  }

  static bool isEncrypted(String text) => Cryptor.isEncrypted(text.trim());

  static Map<String, Object?> _decode((String, String?) args) {
    final (text, password) = args;
    String raw;
    if (Cryptor.isEncrypted(text)) {
      final bytes = Cryptor.decryptBytes(text, password!);
      // Compressed inside the envelope: gzip's magic first.
      raw = bytes.length > 1 && bytes[0] == 0x1f && bytes[1] == 0x8b
          ? utf8.decode(gzip.decode(bytes))
          : utf8.decode(bytes);
    } else {
      raw = text;
    }
    return (json.decode(raw) as Map).cast<String, Object?>();
  }

  /// The backup as file text: with a [password], gzipped JSON in fl_lib's
  /// AES-GCM envelope; without, plain JSON. Off this isolate: it is every
  /// chat, images included.
  Future<String> encode({String? password}) => compute(_encode, (toJson(), password));

  static String _encode((Map<String, Object?>, String?) args) {
    final (data, password) = args;
    final raw = json.encode(data);
    if (password == null || password.isEmpty) return raw;
    return Cryptor.encryptBytes(gzip.encode(utf8.encode(raw)), password);
  }

  String get dateStr => DateTime.fromMillisecondsSinceEpoch(date).simple();

  /// Writes a backup of the stores to [name] in [Paths.doc] (the sync file,
  /// [Paths.bakName], by default) and returns its path.
  static Future<String> toFile({String? password, bool includeSettings = true, String? name}) async {
    final bak = await fromStores(includeSettings: includeSettings);
    final path = name == null ? Paths.bak : Paths.doc.joinPath(name);
    await File(path).writeAsString(await bak.encode(password: password));
    return path;
  }

  /// Merges this backup into the local data.
  ///
  /// Each store merges per key, newest write wins; a key the backup has a
  /// timestamp for but no value is one deleted there, and is deleted here if
  /// that happened after the local write. [force] (a restore the user asked
  /// for) takes the backup's side wherever both have the key, but never
  /// deletes what only this device has.
  ///
  /// A session gets what the backup's has and it lacks: a chat continued on
  /// two devices keeps what each said, the other device's as versions, with
  /// or without [force]. A chat new here stands where it stood there.
  /// Sessions of chats the merge deleted go with them.
  @override
  Future<void> merge({bool force = false}) async {
    final before = LlmStores.chat.keys().toSet();
    _mergeStore(LlmStores.chat, chats, force: force);
    _mergeStore(LlmStores.llm, llm, force: force);
    _mergeStore(LlmStores.tool, tools, force: force);
    _mergeStore(LlmStores.memory, memory, force: force);
    if (settings.isNotEmpty) {
      _mergeStore(Stores.setting, _withoutDeviceLocal(settings), force: force, keep: SettingStore.deviceLocalKeys);
    }
    final alive = LlmStores.chat.keys().toSet();
    final gone = before.difference(alive);

    final here = {for (final s in await Llm.rt.sessions()) s.id};
    for (final MapEntry(key: id, value: remote) in sessions.entries) {
      // A chat deleted here, or never synced: its session is not wanted.
      if (!alive.contains(id)) continue;
      await Chats.importChat(id, remote.entries, tip: here.contains(id) ? null : remote.tip);
    }
    if (gone.isNotEmpty) {
      for (final id in gone) {
        await Chats.close(id);
        if (here.contains(id)) await Llm.rt.deleteSession(id);
      }
      if (gone.contains(Chats.current.value)) Chats.current.value = null;
    }

    LlmStores.chat.changes.notify();
    await Llm.applyCustomProviders();
    await Chats.reconfigure();
    RNodes.app.notify();
    // What the chats gained, for the log sync.
    await LogSyncs.catchUp();
  }

  /// [key] of [store], written by a merge, for the operation-log sync: at
  /// [ts] as no device's, so an edit made since on any device wins over it;
  /// a restore the user asked for ([force]) as an edit made here now.
  static void _record(SqliteStore store, String key, int ts, {required bool force}) {
    if (!SyncRecorder.syncedStores.containsKey(store.name) || store.isDeviceLocalKey(key)) return;
    final c = SyncRecorder.kvOf(store);
    force ? SyncRecorder.record(c, key) : SyncRecorder.applying(() => SyncRecorder.record(c, key, at: ts));
  }

  /// One store, per key: see [merge]. Keys in [keep] are this device's alone
  /// and never touched.
  static void _mergeStore(
    SqliteStore store,
    Map<String, Object?> data, {
    required bool force,
    Set<String> keep = const {},
  }) {
    final tsKey = store.lastUpdateTsKey;
    final bakTs = <String, int>{
      for (final MapEntry(:key, :value) in ((data[tsKey] as Map?) ?? const {}).entries)
        if (value is int) '$key': value,
    };
    final curTs = store.lastUpdateTs ?? const <String, int>{};
    final curKeys = store.keys(includeInternalKeys: true)..remove(tsKey);
    final bakKeys = data.keys.toSet()..remove(tsKey);

    SqliteStore.transact(() {
      for (final key in {...bakKeys, ...curKeys, ...bakTs.keys}) {
        // This build's bookkeeping (migration markers) and this device's own
        // settings are never another device's to set.
        if (keep.contains(key) || key == tsKey || store.isInternalKey(key)) continue;
        final b = bakTs[key] ?? 0;
        final c = curTs[key] ?? 0;
        final inBak = bakKeys.contains(key);
        final inCur = curKeys.contains(key);
        if (inBak) {
          // Missing here and not deleted here since: take it. Present on
          // both: the newer, or with force the backup's.
          final take = inCur ? force || b > c : b >= c || force;
          final value = data[key];
          if (!take || value == null) continue;
          store.set(key, value, updateLastUpdateTsOnSet: false);
          if (b > 0) unawaited(store.updateLastUpdateTs(ts: b, key: key));
          _record(store, key, b, force: force);
        } else if (inCur && bakTs.containsKey(key) && b > c) {
          // Deleted there after it was last written here.
          store.remove(key, updateLastUpdateTsOnRemove: false);
          unawaited(store.updateLastUpdateTs(ts: b, key: key));
          _record(store, key, b, force: force);
        }
      }
    });
  }
}
