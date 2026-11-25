import 'package:fl_lib/fl_lib.dart';
import 'package:fl_lib/generated/l10n/lib_l10n.dart';
import 'package:fl_pi_llm_ui/fl_pi_llm_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:llmbox/data/res/build_data.dart';
import 'package:llmbox/data/res/l10n.dart';
import 'package:llmbox/data/store/all.dart';
import 'package:llmbox/generated/l10n/l10n.dart';
import 'package:llmbox/view/page/home/home.dart';

part 'intro.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemUIs.setTransparentNavigationBar(context);

    return RNodes.app.listen(() => _buildApp(context));
  }

  Widget _buildApp(BuildContext context) {
    UIs.colorSeed = Color(Stores.setting.themeColorSeed.get());
    final themeMode = switch (Stores.setting.themeMode.get()) {
      1 => ThemeMode.light,
      2 => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    final locale = Stores.setting.locale.get();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: BuildData.name,
      locale: locale.toLocale,
      // material_ui's: gen-l10n's list still names flutter_localizations'.
      localizationsDelegates: const [
        AppLocalizations.delegate,
        LibLocalizations.delegate,
        LlmLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      localeListResolutionCallback: LocaleUtil.resolve,
      themeMode: themeMode,
      theme: appTheme(ThemeData(colorSchemeSeed: UIs.colorSeed)).fixWindowsFont,
      darkTheme: appTheme(ThemeData(brightness: Brightness.dark, colorSchemeSeed: UIs.colorSeed)).toAmoled.fixWindowsFont,
      // Outside the breakpoints builder: a toast is sized against the window.
      builder: (context, child) =>
          // TODO: remove once the dependencies still on package:flutter/material.dart
          // (flutter_markdown_plus, flutter_highlight, animations) move to
          // material_ui: it hands them the theme and localizations by the
          // legacy types.
          // ignore: deprecated_member_use
          MaterialUiCompatibilityBridge(
            child: ToastHost(child: HomePage.shortcuts(child: ResponsivePoints.builder(context, child))),
          ),
      navigatorObservers: [AppRouteObserver.instance],
      home: Builder(
        builder: (context) {
          final l10n_ = AppLocalizations.of(context);
          if (l10n_ != null) l10n = l10n_;
          context.setLibL10n();
          context.setLlmL10n();
          UIs.primaryColor = Theme.of(context).colorScheme.primary;

          // The frame goes on each page that fills the window, as fl_lib's
          // routes put it on every page they push: around the navigator it
          // would be drawn twice over each of those. No caption text: the
          // sidebar names the app.
          final intros = _IntroPage.builders;
          return VirtualWindowFrame(child: intros.isNotEmpty ? _IntroPage(intros) : const HomePage());
        },
      ),
    );
  }
}

/// The design's type and rows over Material's defaults.
ThemeData appTheme(ThemeData base) {
  final scheme = base.colorScheme;
  // The platform's UI font as it is: Material's tracking (0.25 on body text)
  // spaces every line out past what the design draws.
  TextStyle? flat(TextStyle? s) => s?.copyWith(letterSpacing: 0);
  final t = base.textTheme;
  return base.copyWith(
    textTheme: TextTheme(
      displayLarge: flat(t.displayLarge),
      displayMedium: flat(t.displayMedium),
      displaySmall: flat(t.displaySmall),
      headlineLarge: flat(t.headlineLarge),
      headlineMedium: flat(t.headlineMedium),
      headlineSmall: flat(t.headlineSmall),
      titleLarge: flat(t.titleLarge),
      titleMedium: flat(t.titleMedium),
      titleSmall: flat(t.titleSmall),
      bodyLarge: flat(t.bodyLarge),
      bodyMedium: flat(t.bodyMedium),
      bodySmall: flat(t.bodySmall),
      labelLarge: flat(t.labelLarge),
      labelMedium: flat(t.labelMedium),
      labelSmall: flat(t.labelSmall),
    ),
    // Material's push, in from the right. On a phone the back gesture is
    // Android's predictive back: the system's there, a swipe from the left
    // edge on iOS.
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
        TargetPlatform.iOS: SwipeBackPageTransitionsBuilder(),
        TargetPlatform.macOS: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
      },
    ),
    extensions: [
      ComponentStyles(
        sidebar: SidebarStyle(
          selectedColor: scheme.secondaryContainer,
          selectedTextColor: scheme.onSecondaryContainer,
          selectedIconColor: scheme.onSecondaryContainer,
          padding: const EdgeInsets.fromLTRB(0, 8, 11, 8),
          fontWeight: FontWeight.w400,
          selectedFontWeight: FontWeight.w500,
          iconSize: 22,
          iconGap: 13,
        ),
      ),
    ],
  );
}
