import 'dart:io';
import 'dart:typed_data';

import 'package:fl_lib/fl_lib.dart';
import 'package:fl_pi_llm_ui/fl_pi_llm_ui.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:llmbox/core/util/log_sync.dart';
import 'package:llmbox/data/store/all.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chats_test.dart' show initLlm, mockServer;

/// A WebDAV folder in memory.
final class _Folder implements SyncFiles {
  final files = <String, (Uint8List, DateTime)>{};

  @override
  Future<void> write(String name, Uint8List body) async {
    files[name] = (body, DateTime.now());
  }

  @override
  Future<Uint8List?> read(String name) async => files[name]?.$1;

  @override
  Future<List<({String name, DateTime? at})>> list(String prefix) async => [
    for (final MapEntry(key: name, value: (_, at)) in files.entries)
      if (name.startsWith(prefix)) (name: name, at: at),
  ];

  @override
  Future<void> delete(String name) async {
    files.remove(name);
  }
}

void main() {
  late HttpServer server;

  /// This install as a new device: its database empty, another device id.
  Future<void> device() async {
    await SqliteDb.close();
    SqliteDb.openInMemory();
    SyncRecorder.resetForTest();
    await Stores.init();
    LogSyncs.install();
    LlmStores.llm.putCustomProvider(
      LlmCustomProvider(id: 'mock', name: 'Mock', api: LlmApi.openaiCompletions, baseUrl: 'http://127.0.0.1:${server.port}/v1', models: const ['echo']),
    );
    Stores.setting.genTitle.set(false);
  }

  Future<void> sync(_Folder folder) async {
    final key = await SyncKeyring.ofFiles(FilesKeyFile(folder, 'folder'));
    final host = SyncHost(files: folder);
    await syncCall(() => SyncSegmentEngine.bind(store: 'folder', host: host.call));
    await syncCall(SyncSegmentEngine(key: key, host: host.call).run);
  }

  setUpAll(() async {
    (server, _) = await mockServer();
    SharedPreferences.setMockInitialValues({});
    await PrefStore.shared.init();
    FlutterSecureStorage.setMockInitialValues({'bakPwd': 'pw'});
    await FlRust.ensureInitialized(
      library: ExternalLibrary.open(switch (Platform.operatingSystem) {
        'macos' => 'packages/fl_lib/rust/target/debug/libfl_lib_ffi.dylib',
        'windows' => 'packages/fl_lib/rust/target/debug/fl_lib_ffi.dll',
        _ => 'packages/fl_lib/rust/target/debug/libfl_lib_ffi.so',
      }),
    );
    await device();
    await initLlm();
  });

  tearDownAll(() async {
    await Chats.closeAll();
    await Llm.rt.dispose();
    await server.close(force: true);
  });

  test('a chat and its entries reach another device, which goes on from them', () async {
    final folder = _Folder();
    final chat = Chats.create();
    await Chats.send(chat, 'hello');
    await LogSyncs.recordEntries(chat);
    Stores.setting.softWrap.set(false);
    await sync(folder);
    final title = LlmStores.chat.fetch(chat)!.title;

    // Another device: no chat, no settings.
    await Chats.close(chat);
    await Llm.rt.deleteSession(chat);
    await device();
    expect(LlmStores.chat.fetch(chat), isNull);
    await sync(folder);
    expect(LlmStores.chat.fetch(chat)?.title, title);
    expect(Stores.setting.softWrap.get(), isFalse);
    final open = await Chats.open(chat);
    expect([for (final e in open.entries.value) e.message?.text], ['hello', isNotNull]);
    // What came is not sent back as this device's own.
    expect(SyncRecorder.pending('').where((r) => r.c == LogSyncs.chatEntries), isEmpty);

    // Going on here: the new entries are this device's to send.
    await Chats.send(chat, 'again');
    await LogSyncs.recordEntries(chat);
    expect(SyncRecorder.pending('').where((r) => r.c == LogSyncs.chatEntries), hasLength(2));
  });

  test('an entry that comes before its parent waits for it', () async {
    final chat = Chats.create();
    await Chats.send(chat, 'first');
    final uids = await Chats.entryUids(chat);
    final entries = await Chats.entries(chat, [for (final e in uids) e.uid]);
    final meta = LlmStores.chat.fetch(chat)!;
    await Chats.close(chat);
    await Llm.rt.deleteSession(chat);
    await device();
    LlmStores.chat.put(meta);
    SyncOp op(int i) => (c: LogSyncs.chatEntries, id: '$chat/${entries[i]['uid']}', h: syncStampOf(ms: BigInt.from(1000 + i), device: BigInt.from(7)), d: entries[i]);
    // The reply alone: its parent is not here.
    await SyncRecords.apply([op(1)]);
    expect(await Chats.entryUids(chat), isEmpty);
    expect(SyncRecorder.stampsOf([(LogSyncs.chatEntries, op(1).id)]), isEmpty, reason: 'not taken yet');
    await SyncRecords.apply([op(0)]);
    expect(await Chats.entryUids(chat), hasLength(2));
    expect(SyncRecorder.stampsOf([(LogSyncs.chatEntries, op(0).id), (LogSyncs.chatEntries, op(1).id)]), hasLength(2));
  });

  test('a device that does not sync chats neither takes nor sends them', () async {
    final folder = _Folder();
    final chat = Chats.create();
    await Chats.send(chat, 'private');
    await LogSyncs.recordEntries(chat);
    await sync(folder);
    await Chats.close(chat);
    await Llm.rt.deleteSession(chat);
    await device();
    await LogSyncs.chats.pref.set(false);
    addTearDown(() => LogSyncs.chats.pref.set(true));
    await sync(folder);
    expect(LlmStores.chat.fetch(chat), isNull);
  });
}
