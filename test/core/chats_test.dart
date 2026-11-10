// The chat core against the real runtime: fl_pi_llm on QuickJS, its
// encrypted session files, a mock OpenAI-compatible server.
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fl_lib/fl_lib.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:llmbox/data/store/all.dart';
import 'package:fl_pi_llm_ui/fl_pi_llm_ui.dart';

/// Streams `Echo: <last user text>` one word at a time.
Future<(HttpServer, List<Map<String, Object?>>)> mockServer() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  final seen = <Map<String, Object?>>[];
  server.listen((req) async {
    if (req.method == 'GET') {
      req.response
        ..headers.contentType = ContentType.json
        ..write(jsonEncode({
          'data': [
            {'id': 'echo'},
          ],
        }));
      await req.response.close();
      return;
    }
    final body = jsonDecode(await utf8.decodeStream(req)) as Map<String, Object?>;
    seen.add(body);
    final msgs = (body['messages'] as List).cast<Map>();
    final last = msgs.lastWhere((m) => m['role'] == 'user');
    final content = last['content'];
    final text = content is String
        ? content
        : (content as List).whereType<Map>().where((p) => p['type'] == 'text').map((p) => p['text']).join();
    final res = req.response
      ..headers.contentType = ContentType('text', 'event-stream')
      ..bufferOutput = false;
    void send(Map<String, Object?> delta, [String? finish]) => res.write('data: ${jsonEncode({
      'id': 'c',
      'object': 'chat.completion.chunk',
      'created': 1,
      'model': body['model'],
      'choices': [{'index': 0, 'delta': delta, 'finish_reason': finish}],
    })}\n\n');
    if (msgs.last['role'] == 'tool') {
      send({'content': 'Done.'}, 'stop');
      res.write('data: [DONE]\n\n');
      await res.close();
      return;
    }
    // `remember X`: saves X with the memory tool.
    if (text.startsWith('remember ')) {
      send({
        'tool_calls': [
          {
            'index': 0,
            'id': 'call_1',
            'type': 'function',
            'function': {
              'name': 'memory_write',
              'arguments': jsonEncode({'path': '/memories/user.md', 'content': text.substring(9)}),
            },
          },
        ],
      }, 'tool_calls');
      res.write('data: [DONE]\n\n');
      await res.close();
      return;
    }
    for (final w in ['Echo: ', ...text.split(' ').map((w) => '$w ')]) {
      send({'content': w});
      await res.flush();
    }
    send({}, 'stop');
    res.write('data: [DONE]\n\n');
    await res.close();
  });
  return (server, seen);
}

ExternalLibrary nativeLib() => ExternalLibrary.open(switch (Platform.operatingSystem) {
  'macos' => 'build/native_assets/macos/libfl_pi_llm.dylib',
  'windows' => 'build/native_assets/windows/fl_pi_llm.dll',
  _ => 'build/native_assets/linux/libfl_pi_llm.so',
});

/// [Llm.init] as a test has it: no keychain, no app directory.
Future<void> initLlm({LlmCredentials? credentials}) => Llm.init(
  directory: Directory.systemTemp.createTempSync('llmbox_llm').path,
  key: Uint8List.fromList(List.filled(32, 1)),
  credentials: credentials ?? MemoryCredentials({'mock': LlmCredential.apiKey('k')}),
  externalLibrary: nativeLib(),
);

void main() {
  late HttpServer server;
  late List<Map<String, Object?>> seen;

  setUpAll(() async {
    (server, seen) = await mockServer();
    SqliteDb.openInMemory();
    await Stores.init();
    LlmStores.llm.putCustomProvider(
      LlmCustomProvider(
        id: 'mock',
        name: 'Mock',
        api: LlmApi.openaiCompletions,
        baseUrl: 'http://127.0.0.1:${server.port}/v1',
        models: const ['echo'],
      ),
    );
    Stores.setting.genTitle.set(false);
    await initLlm();
  });

  tearDownAll(() async {
    await Chats.closeAll();
    await Llm.rt.dispose();
    await server.close(force: true);
  });

  test('the configured custom provider is the default model', () {
    expect(Llm.configured.value, {'mock'});
    expect(Llm.defaultModel, const LlmModelRef('mock', 'echo'));
  });

  test('a chat sends, streams and keeps its conversation', () async {
    final id = Chats.create();
    final chat = await Chats.open(id);
    final seenText = <String>[];
    void onStream() {
      final t = chat.streaming.value?.text;
      if (t != null) seenText.add(t);
    }

    chat.streaming.addListener(onStream);
    await Chats.send(id, 'hello there');
    chat.streaming.removeListener(onStream);

    final roles = chat.entries.value.map((e) => e.message?.role).toList();
    expect(roles, ['user', 'assistant']);
    expect(chat.entries.value.last.message!.text.trim(), 'Echo: hello there');
    expect(seenText.length, greaterThan(1), reason: 'the reply should arrive in pieces');
    expect(chat.running.value, isFalse);
    expect(LlmStores.chat.fetch(id)!.updatedAt.isAfter(DateTime.now().subtract(const Duration(minutes: 1))), isTrue);

    // Closed and reopened, the conversation is still there.
    await Chats.close(id);
    final again = await Chats.open(id);
    expect(again.entries.value.length, 2);
  });

  test('editing a message makes a version, and switching back restores the old branch', () async {
    final id = Chats.create();
    await Chats.send(id, 'first');
    final chat = await Chats.open(id);
    final original = chat.entries.value.first;

    await Chats.edit(id, original, 'second');
    expect(chat.entries.value.last.message!.text.trim(), 'Echo: second');
    final edited = chat.entries.value.first;
    expect(chat.editsOf(edited).map((e) => e.message!.text), ['first', 'second']);

    await Chats.switchTo(id, original);
    expect(chat.entries.value.first.id, original.id);
    expect(chat.entries.value.last.message!.text.trim(), 'Echo: first');
  });

  test('images reach the model; text files are inlined', () async {
    final dir = await Directory.systemTemp.createTemp('llmbox');
    addTearDown(() => dir.delete(recursive: true));
    final img = File('${dir.path}/a.png')
      ..writeAsBytesSync(base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=',
      ));
    final txt = File('${dir.path}/notes.txt')..writeAsStringSync('secret notes');
    final id = Chats.create();
    await Chats.send(id, 'look', files: [img.path, txt.path]);
    final sent = jsonEncode(seen.last);
    expect(sent, contains('image_url'));
    expect(sent, contains('secret notes'));
  });

  test('search finds a chat by what was said in it', () async {
    final id = Chats.create();
    await Chats.send(id, 'a very particular zebra');
    expect((await Chats.search('ZEBRA')).map((m) => m.id), contains(id));
    expect(await Chats.search('no such thing'), isEmpty);
    // What was said, not the stored JSON around it.
    expect(await Chats.search('assistant'), isEmpty);
  });

  test('trash, restore, delete for good', () async {
    final id = Chats.create();
    await Chats.send(id, 'bye');
    await Chats.trash(id);
    expect(LlmStores.chat.all().map((m) => m.id), isNot(contains(id)));
    expect(LlmStores.chat.all(trashed: true).map((m) => m.id), contains(id));
    Chats.restore(id);
    expect(LlmStores.chat.all().map((m) => m.id), contains(id));
    await Chats.deleteForever(id);
    expect(LlmStores.chat.fetch(id), isNull);
    expect((await Llm.rt.sessions()).map((s) => s.id), isNot(contains(id)));
  });

  test('the system prompt carries the memory index, and reaches open chats', () async {
    final id = Chats.create();
    await Chats.open(id);
    LlmStores.llm.systemPrompt.set('Be brief.');
    LlmStores.memory.write(MemoryStore.index, '- likes tea');
    await Chats.reconfigure();
    await Chats.send(id, 'hi');
    final sys = jsonEncode(seen.last['messages']);
    expect(sys, contains('Be brief.'));
    expect(sys, contains('likes tea'));
  });

  test('the model saves to memory without asking', () async {
    LlmStores.tool.enabled.set(true);
    addTearDown(() => LlmStores.tool.enabled.set(false));
    final id = Chats.create();
    await Chats.open(id);
    await Chats.reconfigure();
    await Chats.send(id, 'remember likes green tea');
    expect(LlmStores.memory.read('user.md'), 'likes green tea');
    expect(Chats.openOf(id)!.approvals.value, isEmpty);
  });

  test('other chats are found and read, the calling one left out', () async {
    final a = Chats.create();
    await Chats.open(a);
    await Chats.send(a, 'the quokka code is 42');
    final b = Chats.create();
    String text(LlmToolResult r) => r.content.map((e) => e['text'] ?? '').join();
    final found = text(await TfChatSearch.instance.run({'query': 'quokka'}, ToolCtx(b, LlmCancelToken())));
    expect(found, contains('id: $a'));
    expect(found, contains('the quokka code is 42'));
    expect(text(await TfChatSearch.instance.run({'query': 'quokka'}, ToolCtx(a, LlmCancelToken()))), 'No chats found.');
    final read = text(await TfChatRead.instance.run({'id': a}, ToolCtx(b, LlmCancelToken())));
    expect(read, contains('Echo: the quokka code is 42'));
    await expectLater(TfChatRead.instance.run({'id': 'nope'}, ToolCtx(b, LlmCancelToken())), throwsArgumentError);
  });

  test('a chat continued on another device keeps both, the open one showing them', () async {
    final id = Chats.create();
    final chat = await Chats.open(id);
    await Chats.send(id, 'shared');
    final base = await Chats.exportChat(id);
    await Chats.send(id, 'here');

    // The other device: the chat as it was, continued there.
    final other = Chats.create();
    expect(await Chats.importChat(other, base.entries, tip: base.tip), 2);
    await Chats.open(other);
    await Chats.send(other, 'there');
    await Chats.close(other);

    expect(await Chats.importChat(id, (await Chats.exportChat(other)).entries), 2);
    expect(Chats.openOf(id), same(chat));
    final said = [for (final e in await chat.session.tree()) e.message?.text];
    expect(said, containsAll(['shared', 'here', 'there']));
    expect(chat.entries.value.map((e) => e.message?.text), containsAllInOrder(['shared', 'here']), reason: 'it stays where it stood');
    expect(await Chats.importChat(id, (await Chats.exportChat(other)).entries), 0, reason: 'settled');
    // And it still takes a message.
    await Chats.send(id, 'next');
    expect(chat.entries.value.last.message?.text, 'Echo: next ');
  });

  test('retry asks the last message again; a send while replying is refused', () async {
    final id = Chats.create();
    final chat = await Chats.open(id);
    await Chats.send(id, 'again');
    await Chats.retry(id);
    final user = chat.entries.value.lastWhere((e) => e.message?.role == 'user');
    // Asked again: another reply to one message, not another message.
    expect(chat.repliesOf(user), hasLength(2));
    expect(chat.editsOf(user), hasLength(1));
    expect(chat.entries.value.last.message?.text, 'Echo: again ');
    final first = Chats.send(id, 'one');
    await expectLater(Chats.send(id, 'two'), throwsA(isA<LlmException>()));
    await first;
  });

  test('edits and regenerations are versions of the message and of the reply', () async {
    final id = Chats.create();
    final chat = await Chats.open(id);
    await Chats.send(id, 'a');
    LlmEntry user() => chat.entries.value.lastWhere((e) => e.message?.role == 'user');
    await Chats.regenerate(id, user());
    await Chats.edit(id, user(), 'b');
    await Chats.regenerate(id, user());
    await Chats.regenerate(id, user());
    expect(chat.editsOf(user()).map((e) => e.message?.text), ['a', 'b']);
    expect(chat.repliesOf(user()), hasLength(3));
    // Back to the first reply to 'b', then to the edit 'a' and its replies.
    await Chats.switchTo(id, chat.repliesOf(user()).first);
    expect(chat.repliesOf(user()).indexWhere((e) => e.id == user().id), 0);
    await Chats.switchTo(id, chat.editsOf(user()).first);
    expect(user().message?.text, 'a');
    expect(chat.repliesOf(user()), hasLength(2));
    expect(chat.entries.value.last.message?.text, 'Echo: a ');
  });

  test('switched off, the memory tools and prompt are gone', () {
    LlmStores.tool.enabled.set(true);
    LlmStores.tool.disabledTools.set([TfMemory.groupName]);
    addTearDown(() {
      LlmStores.tool.enabled.set(false);
      LlmStores.tool.disabledTools.set([]);
    });
    expect(Tools.enabled.map((t) => t.name), isNot(contains('memory_view')));
    expect(Chats.systemPromptFor(null), isNot(contains('# Memory')));
  });
}
