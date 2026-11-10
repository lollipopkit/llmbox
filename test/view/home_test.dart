// The home page on the real runtime: it lays out, and a message typed and sent
// comes back streamed into the chat view.
import 'dart:io';

import 'package:fl_lib/fl_lib.dart';
import 'package:fl_lib/generated/l10n/lib_l10n.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:llmbox/data/res/l10n.dart';
import 'package:llmbox/data/store/all.dart';
import 'package:llmbox/generated/l10n/l10n.dart';
import 'package:llmbox/view/page/home/chat_list.dart';
import 'package:llmbox/view/page/home/home.dart';
import 'package:llmbox/view/page/settings/setting.dart';

import '../core/chats_test.dart' show initLlm, mockServer;
import 'package:fl_pi_llm_ui/fl_pi_llm_ui.dart';

Widget _app() => MaterialApp(
  localizationsDelegates: const [
    AppLocalizations.delegate,
    LibLocalizations.delegate,
    LlmLocalizations.delegate,
    ...GlobalMaterialLocalizations.delegates,
  ],
  // As the app: see MyApp.
  // ignore: deprecated_member_use
  builder: (context, child) => MaterialUiCompatibilityBridge(child: child!),
  supportedLocales: AppLocalizations.supportedLocales,
  home: Builder(
    builder: (context) {
      context.setLibL10n();
      context.setLlmL10n();
      l10n = AppLocalizations.of(context)!;
      return ToastHost(child: ResponsivePoints.builder(context, const HomePage()));
    },
  ),
);

late HttpServer _server;
final _credentials = MemoryCredentials({'mock': LlmCredential.apiKey('k')});

void main() {
  setUpAll(() async {
    // No platform side in a test: app_links' stream would throw on listen.
    TestWidgetsFlutterBinding.ensureInitialized().defaultBinaryMessenger.setMockStreamHandler(
      const EventChannel('com.llfbandit.app_links/events'),
      MockStreamHandler.inline(onListen: (_, _) {}),
    );
    // The binding answers every HTTP request with a 400; the runtime needs
    // to reach the mock server for real.
    HttpOverrides.global = null;
    final (server, _) = await mockServer();
    _server = server;
    SqliteDb.openInMemory();
    await Stores.init();
    Stores.setting.autoCheckUpdate.set(false);
    Stores.setting.genTitle.set(false);
    LlmStores.llm.putCustomProvider(
      LlmCustomProvider(
        id: 'mock',
        name: 'Mock',
        api: LlmApi.openaiCompletions,
        baseUrl: 'http://127.0.0.1:${server.port}/v1',
        models: const ['echo'],
      ),
    );
    await initLlm(credentials: _credentials);
  });

  testWidgets('every settings tab lays out', (tester) async {
    tester.view.physicalSize = const Size(1000, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(_app());
    await tester.pump();
    addTearDown(SettingsNav.close);
    // The sidebar's foot opens the settings in place of the chat, and the
    // sidebar turns into their categories.
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsSidebar), findsOneWidget);
    for (final tab in SettingsTab.values) {
      await tester.tap(find.widgetWithText(SideBarTile, tab.i18n));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: tab.name);
    }
    // The providers tab lists pi-ai's catalog, the configured one first.
    await tester.tap(find.widgetWithText(SideBarTile, SettingsTab.providers.i18n));
    await tester.pumpAndSettle();
    expect(find.text('Mock'), findsWidgets);
    // Back to the chats.
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.byType(ChatSidebar), findsOneWidget);
  });

  testWidgets('a custom provider lists its models while being set up, and comes first once saved', (tester) async {
    tester.view.physicalSize = const Size(1000, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(_app());
    await tester.pump();
    addTearDown(SettingsNav.close);
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(SideBarTile, SettingsTab.providers.i18n));
    await tester.pumpAndSettle();
    await tester.tap(find.text(llmL10n.customProvider));
    await tester.pumpAndSettle();
    expect(find.byType(CustomProviderPage), findsOneWidget);

    Finder field(String label) => find.byWidgetPredicate((w) => w is TextField && w.decoration?.labelText == label);
    await tester.enterText(field(libL10n.name), 'Local');
    await tester.enterText(field(libL10n.apiEndpoint), 'http://127.0.0.1:${_server.port}/v1');
    await tester.enterText(field(libL10n.apiKey), 'sk-local');

    final count = find.widgetWithText(SettingsRow, 'echo');
    for (var i = 0; i < 50 && count.evaluate().isEmpty; i++) {
      // The page waits for typing to settle (fake time), then asks the
      // endpoint (real time).
      await tester.pump(const Duration(milliseconds: 100));
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    }
    expect(count, findsOneWidget, reason: 'the endpoint lists `echo`');

    await tester.tap(find.byIcon(Icons.save_outlined));
    for (var i = 0; i < 30 && find.byType(CustomProviderPage).evaluate().isNotEmpty; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    }
    await tester.pumpAndSettle();
    expect(find.byType(CustomProviderPage), findsNothing);
    final saved = LlmStores.llm.customProviders.singleWhere((p) => p.id != 'mock');
    expect(saved.name, 'Local');
    expect((await tester.runAsync(() => _credentials.read(saved.id)))?.key, 'sk-local');

    // Custom and keyed providers lead the list, ahead of pi-ai's catalog.
    final names = [for (final r in tester.widgetList<SettingsRow>(find.byType(SettingsRow))) r.title];
    final unpinned = {
      for (final p in Llm.providers.value)
        if (!p.custom && !Llm.configured.value.contains(p.id)) p.name,
    };
    final firstBuiltin = names.indexWhere(unpinned.contains);
    expect(firstBuiltin, isNonNegative);
    expect(names.indexOf('Mock'), allOf(isNonNegative, lessThan(firstBuiltin)));
    expect(names.indexOf('Local'), allOf(isNonNegative, lessThan(firstBuiltin)));
  });

  for (final size in const [Size(400, 800), Size(1200, 800)]) {
    testWidgets('sends and shows the reply at ${size.width.toInt()} wide', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      Chats.current.value = null;

      await tester.pumpWidget(_app());
      await tester.pump();
      expect(find.byType(TextField), findsWidgets);
      // `Mock · echo`: the provider saved above has an `echo` too.
      final chip = Llm.modelLabel(Llm.defaultModel!);
      expect(chip, endsWith('echo'));
      expect(find.widgetWithText(Btn, chip), findsOneWidget, reason: 'the default model is on the chip');

      final input = find.byWidgetPredicate((w) => w is TextField && w.decoration?.hintText != null && w.minLines == 1);
      await tester.enterText(input, 'hello widget');
      await tester.tap(find.byIcon(Icons.arrow_upward));

      // The runtime runs on real time.
      final reply = find.textContaining('Echo:', findRichText: true);
      for (var i = 0; i < 50 && reply.evaluate().isEmpty; i++) {
        await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
        await tester.pump();
      }
      expect(reply, findsWidgets);
      expect(find.byWidgetPredicate((w) => w is SelectableText && w.data == 'hello widget'), findsOneWidget);
      await tester.runAsync(Chats.closeAll);
    });
  }
}
