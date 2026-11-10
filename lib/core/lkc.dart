import 'package:fl_lib/fl_lib.dart';

/// This app's LK Cloud client: the `llmbox` public client at the IdP.
abstract final class Lkc {
  /// Registered with the IdP; AppAuth's Android receiver takes it too
  /// (`appAuthRedirectScheme` in `android/app/build.gradle`).
  static const redirectUrl = 'llmbox://auth/callback';

  static final client = LkcClient(
    oidc: LkcOidc(clientId: 'llmbox', redirectUrl: redirectUrl),
  );

  static Future<void> init() async {
    try {
      await client.init();
    } catch (e, s) {
      Loggers.app.warning('LK Cloud init', e, s);
    }
  }
}
