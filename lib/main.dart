import 'dart:async';

import 'package:fl_lib/fl_lib.dart';
import 'package:material_ui/material_ui.dart';
import 'package:llmbox/app.dart';
import 'package:llmbox/core/lkc.dart';
import 'package:llmbox/core/tool/shell.dart';
import 'package:llmbox/core/tty.dart';
import 'package:llmbox/core/util/log_sync.dart';
import 'package:llmbox/core/util/sync.dart';
import 'package:llmbox/data/res/build_data.dart';
import 'package:llmbox/data/store/all.dart';
import 'package:llmbox/view/page/settings/setting.dart';
import 'package:logging/logging.dart';
import 'package:fl_pi_llm_ui/fl_pi_llm_ui.dart';

Future<void> main() async {
  await _runInZone(() async {
    await _initApp();
    runApp(const MyApp());
  });
}

Future<void> _runInZone(Future<void> Function() body) async {
  final zoneSpec = ZoneSpecification(
    print: (_, parent, zone, line) => parent.print(zone, line),
  );

  await runZonedGuarded(body, (e, s) {
    // The zone takes uncaught async errors before `PlatformDispatcher.onError`,
    // so this is the only place they are seen.
    if (Diag.enabled) {
      Diag.error(e, s, 'Zone error');
    } else {
      Loggers.app.severe('Zone error', e, s);
    }
    CrashLog.markUnhandled(e, s);
  }, zoneSpecification: zoneSpec);
}

Future<void> _initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Before anything that can fail, so a failure during startup is recorded.
  _setupDebug();

  await Paths.init(
    BuildData.name,
    bakName: bakFileName,
    dirs: const {},
    fileInUserDocuments: false,
  );
  await CrashLog.attach(Paths.doc.joinPath('logs'));

  await _initData();
  await _initWindow();
  await _initAppComponents();
}

Future<void> _initData() async {
  await PrefStore.shared.init(); // Call this before accessing any store
  await SecureStoreProps.migrateLegacyPrefs();
  await Webdav.initShared();
  await Stores.init();
  // Before anything writes a synced store, so each edit is recorded. Without
  // fl_lib's Rust the log sync is off, and the rest runs as before.
  try {
    await FlRust.ensureInitialized();
  } catch (e, s) {
    Loggers.app.warning('fl_lib Rust', e, s);
  }
  LogSyncs.install();
}

void _setupDebug() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(DebugProvider.addLog);
  CrashLog.handleErrors();
  // Local only: nothing is sent anywhere.
  Diag.install(LocalDiagnosticsSink());
  AppLifecycleListener(
    onPause: () => unawaited(Diag.flush()),
    onDetach: () => unawaited(Diag.flush()),
  );
}

Future<void> _initWindow() async {
  if (!isDesktop) return;
  final sets = Stores.setting;
  final windowStateProp = sets.windowState;
  final windowState = windowStateProp.get();
  // The app draws its own title bar: the design has no system one.
  WindowFrameConfig.setShowCaption(true);
  await SystemUIs.initDesktopWindow(
    hideTitleBar: true,
    size: windowState?.size ?? const Size(1100, 760),
    position: windowState?.position,
    listener: WindowStateListener(windowStateProp),
  );
}

Future<void> _initAppComponents() async {
  _configLlmUi();
  await initTty();
  await Llm.init();
  // Open chats follow the tool settings and the MCP servers.
  LlmStores.tool.watch().listen((_) => Chats.reconfigureSoon());
  McpTools.changes.addListener(Chats.reconfigureSoon);
  if (LlmStores.tool.enabled.get()) unawaited(McpTools.connectStored());

  BakSync.instance.init();
  // Signed in to LK Cloud, Conduit's models are offered.
  ConduitProvider.attach(Lkc.client);
  // Off the launch path: it reads the keychain and asks homebase who is signed in.
  unawaited(Lkc.init());
  unawaited(LogSyncs.start());
  // Only when sync is on, and never without a password: see BakSync.
  BakSync.instance.syncSoon();
}

/// What fl_pi_llm_ui takes from this app: its name, its settings, and where
/// the provider settings are.
void _configLlmUi() {
  final set = Stores.setting;
  LlmUi.appName = BuildData.name;
  LlmUi.appVersion = '1.0.${BuildData.build}';
  LlmUi.genTitle = set.genTitle.get;
  LlmUi.trashDays = set.trashDays.get;
  LlmUi.softWrap = set.softWrap.listenable();
  LlmUi.scrollBottom = set.scrollBottom.get;
  LlmUi.scrollAfterSwitch = set.scrollAfterSwitch.get;
  LlmUi.showProvider = (_, id) {
    // Beside the provider list, in the settings of a wide window.
    if (!SettingsNav.inShell) return false;
    SettingsNav.provider.value = id;
    return true;
  };
  LlmUi.openProviders = (context) => SettingsNav.open(context, SettingsTab.providers);
  LlmUi.appTools = () => [if (TfShell.isSupported) const TfShell()];
}
