
import 'package:fl_lib/fl_lib.dart';
import 'package:material_ui/material_ui.dart';
import 'package:llmbox/core/lkc.dart';
import 'package:llmbox/core/util/update.dart';
import 'package:llmbox/data/res/build_data.dart';
import 'package:llmbox/data/res/github_id.dart';
import 'package:llmbox/data/res/l10n.dart';
import 'package:llmbox/data/res/url.dart';
import 'package:llmbox/data/store/all.dart';
import 'package:llmbox/generated/l10n/l10n.dart';
import 'package:llmbox/view/page/backup/view.dart';
import 'package:llmbox/view/widget/transitions.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:fl_pi_llm_ui/fl_pi_llm_ui.dart';

part 'about.dart';
part 'def.dart';

/// Where the settings are shown.
///
/// On a wide window they are pushed as one page of their own — their
/// categories in the sidebar, the page beside them; a phone pushes each page.
/// [inline] says which the home page is laying out now.
abstract final class SettingsNav {
  /// The page shown beside the categories, while [SettingsShell] is open.
  static final tab = nvn<SettingsTab>();

  /// A provider opened from the providers page, shown in its place: its id,
  /// or '' for a new custom one.
  static final provider = nvn<String>();

  /// Whether the home page is wide, and so opens [SettingsShell].
  static var inline = false;

  /// The open [SettingsShell]'s context, to close it from outside.
  static BuildContext? _shell;

  /// Whether [SettingsShell] is open: a provider opens inside it.
  static bool get inShell => _shell?.mounted ?? false;

  static void open(BuildContext context, [SettingsTab tab = SettingsTab.app]) {
    if (!inline) {
      SettingsTabPage.route.go(context, args: tab);
      return;
    }
    provider.value = null;
    SettingsNav.tab.value = tab;
    if (_shell == null) SettingsShell.route.go(context);
  }

  /// Back to the chat.
  static void close() {
    final shell = _shell;
    if (shell != null && shell.mounted) Navigator.of(shell).pop();
  }
}

/// The settings on a wide window: their categories where the chats were, and
/// the page beside them. Pushed, so it comes in the way any page does.
class SettingsShell extends StatefulWidget {
  const SettingsShell({super.key});

  static const route = AppRouteNoArg(page: SettingsShell.new, path: '/settings/shell');

  @override
  State<SettingsShell> createState() => _SettingsShellState();
}

class _SettingsShellState extends State<SettingsShell> {
  @override
  void initState() {
    super.initState();
    SettingsNav._shell = context;
  }

  @override
  void dispose() {
    if (SettingsNav._shell == context) SettingsNav._shell = null;
    SettingsNav.provider.value = null;
    SettingsNav.tab.value = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sets = Stores.setting;
    return Scaffold(
      body: sets.paneListWidth.listenable().listenVal(
        (width) => AdaptivePanes.surface(
          listWidth: width,
          onListWidthChanged: sets.paneListWidth.set,
          listBuilder: (_, _) => const SettingsSidebar(),
          surfaceBuilder: (_, _) => SettingsNav.tab.listenVal((tab) {
            final t = tab ?? SettingsTab.app;
            // Peers: fade through from one page to another.
            return FadeThroughSwitcher(
              child: Padding(
                key: ValueKey(t),
                padding: const EdgeInsets.only(top: 4),
                child: t == SettingsTab.providers ? const _Providers() : t.page,
              ),
            );
          }),
        ),
      ),
    );
  }
}

/// The providers, and a provider pushed within the pane.
class _Providers extends StatelessWidget {
  const _Providers();

  @override
  Widget build(BuildContext context) {
    return SettingsNav.provider.listenVal((id) {
      return PushSwitcher(
        reverse: id == null,
        child: id == null
            ? const ProvidersPage(key: ValueKey('providers'))
            : KeyedSubtree(
                key: ValueKey('provider:$id'),
                child: ProvidersPage.detail(id, onBack: () => SettingsNav.provider.value = null),
              ),
      );
    });
  }
}

/// The categories, for a phone: the sidebar's list as a page.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const route = AppRouteNoArg(page: SettingsPage.new, path: '/settings');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text(libL10n.setting)),
      body: SectionList(
        children: [
          SettingsGroup(
            rows: [
              ListenableBuilder(
                listenable: Listenable.merge([Lkc.client.user, Lkc.client.entitlements]),
                builder: (_, _) => SettingsRow(
                  leading: LkcAvatar(client: Lkc.client),
                  title: SettingsTab.account.i18n,
                  subtitle: lkcAccountSummary(Lkc.client),
                  trailing: const RowChevron(),
                  onTap: () => SettingsTabPage.route.go(context, args: SettingsTab.account),
                ),
              ),
              for (final t in SettingsTab.values)
                if (t != SettingsTab.account)
                  SettingsRow(
                    icon: t.icon,
                    title: t.i18n,
                    trailing: const RowChevron(),
                    onTap: () => SettingsTabPage.route.go(context, args: t),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}

/// One settings page, pushed.
class SettingsTabPage extends StatelessWidget {
  const SettingsTabPage({super.key, this.args});

  final SettingsTab? args;

  static const route = AppRoute<void, SettingsTab>(page: SettingsTabPage.new, path: '/settings/page');

  @override
  Widget build(BuildContext context) {
    final tab = args ?? SettingsTab.app;
    return Scaffold(
      appBar: CustomAppBar(title: Text(tab.i18n)),
      body: tab.page,
    );
  }
}

/// The sidebar while in the settings: back to the chats, then the categories.
class SettingsSidebar extends StatelessWidget {
  const SettingsSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsNav.tab.listenVal((tab) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(9, 0, 7, 9),
            child: Row(
              children: [
                Btn.icon(
                  icon: const Icon(Icons.arrow_back, size: 22),
                  text: l10n.backToChats,
                  onTap: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 5),
                Text(libL10n.setting, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          for (final t in SettingsTab.values)
            SideBarTile(
              icon: t == tab ? t.selectedIcon : t.icon,
              title: t.i18n,
              selected: t == tab,
              onTap: () => SettingsNav.open(context, t),
            ),
        ],
      );
    });
  }
}

final class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});

  static final _set = Stores.setting;

  @override
  Widget build(BuildContext context) {
    return SectionList(
      children: [
        SettingsGroup(
          title: libL10n.app,
          rows: [
            _locale(context),
            _colorSeed(context),
            _themeMode(context),
            _checkUpdate(context),
          ],
        ),
        SettingsGroup(
          title: l10n.chat,
          rows: [
            SettingsRow(
              icon: Icons.auto_awesome,
              title: l10n.genChatTitle,
              subtitle: l10n.genChatTitleTip,
              trailing: StoreSwitch(prop: _set.genTitle),
            ),
            SettingsRow(
              icon: Icons.vertical_align_bottom,
              title: l10n.scrollOnNewMsg,
              trailing: StoreSwitch(prop: _set.scrollBottom),
            ),
            SettingsRow(
              icon: Icons.swap_vert,
              title: l10n.scrollAfterSwitch,
              trailing: StoreSwitch(prop: _set.scrollAfterSwitch),
            ),
            SettingsRow(
              icon: Icons.wrap_text,
              title: l10n.softWrap,
              subtitle: l10n.codeBlock,
              trailing: StoreSwitch(prop: _set.softWrap),
            ),
            SettingsRow(
              icon: Icons.check_circle_outline,
              title: l10n.deleteConfirm,
              trailing: StoreSwitch(prop: _set.confrimDel),
            ),
            _trashDays(context),
            LlmStores.chat.changes.listen(() {
              final n = LlmStores.chat.all(trashed: true).length;
              return SettingsRow(
                icon: Icons.restore_from_trash_outlined,
                title: l10n.trash,
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [RowValue(l10n.chatsCountFmt(n)), const RowChevron()]),
                onTap: () => TrashPage.route.go(context),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _locale(BuildContext context) {
    return _set.locale.listenable().listenVal((val) {
      return SettingsRow(
        icon: Icons.translate,
        title: libL10n.language,
        trailing: RowValue(val.isEmpty ? context.localeNativeName : (val.toLocale?.nativeName ?? val)),
        onTap: () async {
          final result = await context.showPickSingleDialog<Locale>(
            title: libL10n.language,
            items: AppLocalizations.supportedLocales,
            display: (e) => e.nativeName,
            initial: val.toLocale ?? l10n.localeName.toLocale,
          );
          if (result != null) {
            _set.locale.set(result.code);
            await RNodes.app.notify(delay: true);
          }
        },
      );
    });
  }

  Widget _colorSeed(BuildContext context) {
    return _set.themeColorSeed.listenable().listenVal((val) {
      final color = Color(val);
      return SettingsRow(
        icon: Icons.colorize,
        title: l10n.themeColorSeed,
        trailing: Container(width: 24, height: 24, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        onTap: () async {
          var picked = color;
          await context.showRoundDialog(
            title: libL10n.select,
            child: ColorPicker(color: color, onColorChanged: (c) => picked = c),
            actions: Btn.ok(
              onTap: () {
                _set.themeColorSeed.put(picked.value255);
                RNodes.app.notify(delay: true);
                context.pop();
              },
            ).toList,
          );
        },
      );
    });
  }

  Widget _themeMode(BuildContext context) {
    return _set.themeMode.listenable().listenVal((val) {
      return SettingsRow(
        icon: Icons.contrast,
        title: l10n.themeMode,
        trailing: RowValue(ThemeMode.values[val].i18n),
        onTap: () async {
          final result = await context.showPickSingleDialog(
            title: l10n.themeMode,
            items: ThemeMode.values,
            display: (e) => e.i18n,
            initial: ThemeMode.values[val],
          );
          if (result == null) return;
          _set.themeMode.set(result.index);
          RNodes.app.notify(delay: true);
        },
      );
    });
  }

  Widget _checkUpdate(BuildContext context) {
    return AppUpdateIface.newestBuild.listenVal((val) {
      final text = switch (val) {
        null => '${l10n.current} v${BuildData.build}, ${l10n.clickToCheck}',
        > BuildData.build => libL10n.versionHasUpdate(val),
        _ => libL10n.versionUpdated(BuildData.build),
      };
      return SettingsRow(
        icon: Icons.update,
        title: l10n.autoCheckUpdate,
        subtitle: text,
        trailing: StoreSwitch(prop: _set.autoCheckUpdate),
        onTap: () => Fns.throttle(() => checkAppUpdate(context)),
      );
    });
  }

  Widget _trashDays(BuildContext context) {
    return _set.trashDays.listenable().listenVal((days) {
      return SettingsRow(
        icon: Icons.delete_outline,
        title: l10n.emptyTrashAfter,
        subtitle: l10n.trashTip,
        trailing: RowValue(l10n.daysFmt(days)),
        onTap: () async {
          final ctrl = TextEditingController(text: '$days');
          void save(String s) {
            // At least a day: 0 would empty the trash at the next launch.
            final v = int.tryParse(s);
            if (v == null || v < 1) {
              Toast.show(libL10n.fail);
              return;
            }
            _set.trashDays.put(v);
            context.pop();
          }

          await context.showRoundDialog(
            title: l10n.emptyTrashAfter,
            child: Input(controller: ctrl, type: TextInputType.number, autoFocus: true, onSubmitted: save, hint: l10n.emptyTrashTip),
            actions: Btn.ok(onTap: () => save(ctrl.text)).toList,
          );
          ctrl.dispose();
        },
      );
    });
  }
}

/// Deleted chats, until the trash is emptied.
class TrashPage extends StatelessWidget {
  const TrashPage({super.key});

  static const route = AppRouteNoArg(page: TrashPage.new, path: '/trash');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text(l10n.trash)),
      body: LlmStores.chat.changes.listen(() {
        final chats = LlmStores.chat.all(trashed: true);
        if (chats.isEmpty) return EmptyPane(icon: Icons.delete_outline, label: libL10n.empty);
        return SectionList(
          children: [
            SettingsGroup(
              rows: [
                for (final m in chats)
                  SettingsRow(
                    title: m.title ?? l10n.untitled,
                    subtitle: m.trashedAt?.toAgoStr(),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Btn.icon(
                          icon: const Icon(Icons.restore, size: 19),
                          text: libL10n.restore,
                          onTap: () => Chats.restore(m.id),
                        ),
                        Btn.icon(
                          icon: const Icon(Icons.delete_forever_outlined, size: 19),
                          text: libL10n.delete,
                          onTap: () async {
                            final ok = await context.showRoundDialog<bool>(
                              title: libL10n.attention,
                              child: Text(l10n.delFmt(m.title ?? l10n.untitled, l10n.chat)),
                              actions: Btnx.okReds,
                            );
                            if (ok == true) await Chats.deleteForever(m.id);
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
