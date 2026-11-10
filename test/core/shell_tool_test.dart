
import 'package:fl_pi_llm_ui/fl_pi_llm_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:llmbox/core/tool/shell.dart';

import 'chats_test.dart' show nativeLib;

/// On the host, as on a desktop: the commands run here. They are POSIX
/// `sh`; Windows runs cmd.
const _posix = '!windows';

void main() {
  const tool = TfShell();
  // The risk badge classifies in the native library.
  setUpAll(() => FlPiLlm.loadLibrary(externalLibrary: nativeLib()));
  Future<String> run(Map<String, dynamic> args, [LlmCancelToken? cancel]) async =>
      (await tool.run(args, ToolCtx('chat', cancel ?? LlmCancelToken()))).content.map((e) => '${(e as Map)['text'] ?? ''}').join();

  test('hands back the exit code and both streams', () async {
    final out = await run({'command': 'echo hi; echo oops >&2; exit 3', 'description': ''});
    expect(out, contains('exit code: 3'));
    expect(out, contains('stdout:\nhi'));
    expect(out, contains('stderr:\noops'));
  }, testOn: _posix);

  test('runs POSIX sh in the home directory, whatever the login shell', () async {
    final out = await run({'command': r'[ "$(pwd)" = "$HOME" ] && echo home', 'description': ''});
    expect(out, contains('home'));
  }, testOn: _posix);

  test('is stopped at its timeout', () async {
    final sw = Stopwatch()..start();
    final out = await run({'command': 'sleep 30', 'description': '', 'timeout': 1});
    expect(out, contains('Stopped after 1 s'));
    expect(sw.elapsed, lessThan(const Duration(seconds: 10)));
  }, testOn: _posix);

  test('is stopped when the user stops the reply', () async {
    final cancel = LlmCancelToken();
    Future.delayed(const Duration(milliseconds: 300), cancel.cancel);
    final out = await run({'command': 'sleep 30', 'description': ''}, cancel);
    expect(out, contains('exit code: none'));
  }, testOn: _posix);

  test('a long output keeps its start and its end', () async {
    final out = await run({'command': 'seq 1 20000', 'description': ''});
    expect(out, contains('\n1\n'));
    expect(out, contains('20000'));
    expect(out, contains('characters cut'));
  }, testOn: _posix);

  test('says what kind of command it is before it runs', () {
    expect(LlmPermissionRules.classify('rm -rf ~/x'), LlmCommandRisk.destructive);
    expect(tool.allowAlways, isFalse);
  });
}
