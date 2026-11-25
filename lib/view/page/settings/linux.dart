import 'package:dio/dio.dart' show CancelToken, DioException;
import 'package:fl_lib/fl_lib.dart';
import 'package:fl_pi_llm_ui/fl_pi_llm_ui.dart';
import 'package:fl_tty/fl_tty.dart';
import 'package:llmbox/data/res/l10n.dart';
import 'package:material_ui/material_ui.dart';

/// The Linux systems the `shell` tool runs in on Android and iOS: which one it
/// uses, installing another, removing one.
class LinuxPage extends StatelessWidget {
  const LinuxPage({super.key});

  static const route = AppRouteNoArg(page: LinuxPage.new, path: '/linux');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(l10n.linuxEnv),
        actions: [
          if (Rootfs.isAvailable)
            Btn.icon(icon: const Icon(Icons.add), text: libL10n.install, onTap: () => _install(context)),
        ],
      ),
      body: ListenableBuilder(
        listenable: Rootfs.changed,
        builder: (context, _) {
          if (!Rootfs.isAvailable) return EmptyPane(icon: Icons.terminal, label: libL10n.notAvailable);
          final profiles = Rootfs.profiles;
          final selected = Rootfs.selected;
          return SectionList(
            children: [
              SettingsGroup(
                title: l10n.linuxEnvTip,
                rows: [
                  if (profiles.isEmpty)
                    SettingsRow(icon: Icons.terminal, title: l10n.linuxNone, onTap: () => _install(context)),
                  for (final p in profiles)
                    SettingsRow(
                      icon: p.id == selected?.id ? Icons.check_circle : Icons.circle_outlined,
                      title: p.label,
                      subtitle: [p.distro.label, if (p.version.isNotEmpty) p.version].join(' '),
                      onTap: () {
                        FlTty.settings.profile = p.id;
                        Rootfs.changed.value++;
                      },
                      trailing: Btn.icon(
                        icon: const Icon(Icons.delete_outline),
                        text: libL10n.delete,
                        onTap: () => _remove(context, p),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  static Future<void> _install(BuildContext context) async {
    final distros = LinuxDistros.installable;
    if (distros.isEmpty) return Toast.error(libL10n.notAvailable);
    final distro = distros.length == 1
        ? distros.first
        : await context.showPickSingleSheet<LinuxDistro>(
            title: libL10n.install,
            items: distros,
            display: (d) => d.label,
          );
    if (distro == null || !context.mounted) return;
    final target = Rootfs.target(picked: (distro: distro, release: distro.preferred));
    if (target == null) return Toast.error(libL10n.notAvailable);
    final ok = await context.showSheet<bool>(
      title: libL10n.install,
      child: Text(l10n.linuxInstallTip(distro.label, target.release.version, target.release.source.sizeMb)),
      actions: Btnx.cancelOk,
    );
    if (ok != true || !context.mounted) return;

    final progress = ValueNotifier<double?>(null);
    final cancel = CancelToken();
    var cancelled = false;
    var owned = false;
    VoidCallback? closeProgress;
    final progressSheet = context.showSheet<void>(
      title: libL10n.download,
      onShown: (c) => closeProgress = c,
      childBuilder: (_) {
        owned = true;
        return DisposeWith(
          notifiers: [progress],
          child: ValueListenableBuilder(
            valueListenable: progress,
            builder: (_, value, _) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(value: value),
                UIs.height13,
                Text(value == null ? '...' : '${(value * 100).toStringAsFixed(0)}%', style: UIs.text13Grey),
              ],
            ),
          ),
        );
      },
      dismissible: false,
      actions: [
        Btn.text(
          text: libL10n.cancel,
          onTap: () {
            cancelled = true;
            cancel.cancel();
          },
        ),
      ],
    );
    try {
      await Rootfs.install(
        distro: target.distro,
        release: target.release,
        onProgress: (v) => progress.value = v,
        cancel: cancel,
      );
      closeProgress?.call();
      await progressSheet;
      if (!owned) progress.dispose();
    } catch (e, s) {
      closeProgress?.call();
      await progressSheet;
      if (!owned) progress.dispose();
      if (!context.mounted) return;
      if (!(cancelled && e is DioException && CancelToken.isCancel(e))) {
        context.showErrSheet(e, s);
      }
    }
  }

  static Future<void> _remove(BuildContext context, LinuxProfile p) async {
    if (Rootfs.openSessions(p) > 0) return Toast.error(l10n.linuxInUse);
    final ok = await context.showSheet<bool>(
      title: libL10n.delete,
      child: Text(l10n.linuxRemoveTip(p.label)),
      actions: Btnx.cancelRedOk,
    );
    if (ok != true) return;
    try {
      await Rootfs.removeProfile(p.id, expected: p);
    } catch (e, s) {
      if (context.mounted) context.showErrSheet(e, s);
    }
  }
}
