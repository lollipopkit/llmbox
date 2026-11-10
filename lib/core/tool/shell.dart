import 'dart:async';
import 'dart:io';

import 'package:fl_lib/fl_lib.dart';
import 'package:fl_pi_llm_ui/fl_pi_llm_ui.dart';
import 'package:fl_tty/fl_tty.dart';
import 'package:llmbox/data/res/l10n.dart';
import 'package:llmbox/view/page/settings/linux.dart';
import 'package:material_ui/material_ui.dart';

/// Runs a command on this device: the user's own computer on desktop, the
/// Linux userland fl_tty installs on Android and iOS.
///
/// Every call is asked about, and no answer covers the next: the same tool
/// lists a directory and deletes one, and on a computer it runs beside this
/// app's data and the user's files. [LlmPermissionRules.classify] tells the user
/// which kind of call it is; it never decides for them.
final class TfShell extends ToolFunc {
  const TfShell()
    : super(
        name: 'shell',
        parametersSchema: const {
          'type': 'object',
          'additionalProperties': false,
          'required': ['command', 'description'],
          'properties': {
            'command': {'type': 'string', 'description': 'A complete, non-interactive command.'},
            'description': {
              'type': 'string',
              'description': 'What the command does and why, in a sentence, for the user who approves it.',
            },
            'timeout': {
              'type': 'integer',
              'description': 'Seconds before it is stopped. Default $_defaultTimeout, at most $_maxTimeout.',
            },
          },
        },
      );

  static const _defaultTimeout = 120;
  static const _maxTimeout = 900;

  /// Characters of output handed back: the start and the end of a longer one.
  static const _maxOutput = 20000;
  static const _head = 4000;

  /// Whether this build can run one at all.
  static bool get isSupported => LocalExec.isSupported;

  @override
  String get description {
    final exec = LocalExec.forThisDevice();
    final where = switch (exec) {
      LocalExec(inRootfs: true) =>
        'in a ${Rootfs.selected?.distro.label ?? 'Linux'} container on the user\'s phone, as root. Install packages '
            'with its package manager. It cannot see the phone\'s own files or this app\'s data. Starts in /root.',
      _ when Platform.isWindows =>
        'on the user\'s own computer, through cmd. It holds the user\'s files and this app\'s data: never use it as a '
            'scratch machine, and touch only what the user asked about.',
      _ =>
        'on the user\'s own computer, through POSIX sh. It holds the user\'s files and this app\'s data: never use it '
            'as a scratch machine, and touch only what the user asked about. Starts in the home directory.',
    };
    return '''
Run one non-interactive command $where
The user approves each command before it runs. No prompts or terminal UIs: pass flags such as -y, and redirect or page nothing. Output comes back as the exit code, stdout and stderr, cut to its start and end past $_maxOutput characters.''';
  }

  @override
  String get l10nName => l10n.shellTool;

  @override
  String? get l10nTip => l10n.shellToolTip;

  @override
  bool get defaultEnabled => false;

  @override
  IconData get icon => Icons.terminal;

  @override
  bool get allowAlways => false;

  @override
  void Function(BuildContext context)? get openSettings =>
      Rootfs.isAvailable ? (context) => LinuxPage.route.go(context) : null;

  @override
  String summary(Map<String, dynamic> args) => '${args['command'] ?? ''}';

  @override
  Widget? preview(BuildContext context, Map<String, dynamic> args, String chatId) {
    final command = '${args['command'] ?? ''}';
    final description = '${args['description'] ?? ''}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        CommandRiskBadge(LlmPermissionRules.classify(command)),
        if (description.isNotEmpty) Text(description, style: UIs.text13Grey),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(9),
          ),
          child: CommandPreview(text: command),
        ),
      ].joinWith(const SizedBox(height: 7)),
    );
  }

  @override
  Future<LlmToolResult> run(Map<String, dynamic> args, ToolCtx ctx) async {
    final command = '${args['command'] ?? ''}'.trim();
    if (command.isEmpty) throw ArgumentError('command is required');
    final exec = LocalExec.forThisDevice() ?? (throw StateError('This build cannot run commands on this device.'));
    if (exec.inRootfs && !Rootfs.isReady) {
      throw StateError(
        'There is no Linux system installed on this device. Ask the user to install one: Settings, Tools, '
        '${l10n.shellTool}. Do not try again until they have.',
      );
    }
    final seconds = (args['timeout'] as num? ?? _defaultTimeout).toInt().clamp(1, _maxTimeout);

    // Stopped by the user, or by the clock; whichever comes first.
    final stop = Completer<void>();
    var timedOut = false;
    final timer = Timer(Duration(seconds: seconds), () {
      timedOut = true;
      if (!stop.isCompleted) stop.complete();
    });
    unawaited(ctx.cancel.whenCancelled.then((_) {
      if (!stop.isCompleted) stop.complete();
    }));

    final ExecResult r;
    try {
      r = switch (exec) {
        // The guest's own sh, which is all the guest runs scripts with.
        LocalExec(inRootfs: true) => await exec.run(command, cancel: stop.future),
        // cmd takes the command as it is.
        _ when Platform.isWindows => await exec.run(command, cancel: stop.future),
        // sh reads the script, whatever the user's login shell is: fish is
        // not POSIX, and the model writes POSIX.
        _ => await exec.run('cd "\$HOME" || exit\n$command', entry: 'sh', cancel: stop.future),
      };
    } finally {
      timer.cancel();
    }

    final notes = [
      if (timedOut) 'Stopped after $seconds s.',
      if (r.mayStillRun) 'It was stopped, but something it started may still be running.',
      if (r.outputIncomplete) 'It exited before its output ended; what arrived is below.',
    ];
    return LlmToolResult.text(
      [
        'exit code: ${r.exitCode ?? 'none (stopped)'}',
        ...notes,
        if (r.stdout.isNotEmpty) 'stdout:\n${_cut(r.stdout)}',
        if (r.stderr.isNotEmpty) 'stderr:\n${_cut(r.stderr)}',
        if (r.stdout.isEmpty && r.stderr.isEmpty) '(no output)',
      ].join('\n\n'),
      details: {'exit': r.exitCode},
    );
  }

  /// [text], or its start and end when it is longer than [_maxOutput]: where a
  /// command says what it is doing, and where it says how that ended.
  static String _cut(String text) {
    if (text.length <= _maxOutput) return text;
    final tail = _maxOutput - _head;
    return '${text.substring(0, _head)}\n… ${text.length - _maxOutput} characters cut …\n'
        '${text.substring(text.length - tail)}';
  }
}
