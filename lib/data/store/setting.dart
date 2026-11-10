import 'package:fl_lib/fl_lib.dart';

class SettingStore extends SqliteStore {
  SettingStore._() : super('setting');

  static final instance = SettingStore._();

  /// This device's own: never in a backup, never set by one. A window's size
  /// and where the sidebar was dragged to are about this screen, and the
  /// intro about this install.
  ///
  /// TODO: drop `hideTitleBar` once no install has it: the setting is gone
  /// (the title bar is always hidden), and its stored value must not sync.
  /// The Linux userland's settings are too: what is installed, where it is
  /// fetched from and which network it resolves on are this device's.
  static const deviceLocalKeys = {
    'windowState',
    'paneListWidth',
    'hideTitleBar',
    'introVer',
    'linuxProfile',
    'linuxDistro',
    'linuxMirrors',
    'linuxDns',
    'rootfsManifestSerial',
    'rootfsManifestCache',
    'rootfsManifestCacheSig',
  };

  /// No sync stamps or carries them.
  @override
  bool isDeviceLocalKey(String key) => deviceLocalKeys.contains(key);

  late final themeMode = propertyDefault('themeMode', 0);

  late final themeColorSeed = propertyDefault('themeColorSeed', 4287106639);

  late final autoCheckUpdate = propertyDefault('autoCheckUpdate', true);

  /// Follow new tokens down while a reply streams.
  late final scrollBottom = propertyDefault('scrollBottom', true);

  late final locale = propertyDefault('locale', '');

  late final softWrap = propertyDefault('softWrap', true);

  /// Name a chat from its first exchange.
  late final genTitle = propertyDefault('genTitle', true);

  /// Whether deleting a chat asks first.
  late final confrimDel = propertyDefault('confrimDel', true);

  /// For desktop only.
  /// Record the position and size of the window.
  late final windowState = property<WindowState>(
    'windowState',
    fromObj: (obj) => switch (obj) {
      final Map map => WindowState.fromJson(map.cast<String, dynamic>()),
      _ => null,
    },
    toObj: (state) => state?.toJson(),
  );

  late final introVer = propertyDefault('introVer', 0);

  /// Scroll to the bottom after switching chat.
  late final scrollAfterSwitch = propertyDefault('scrollAfterSwitch', false);

  /// Days to keep chats in the trash.
  late final trashDays = propertyDefault('trashDays', 7);

  /// Width of the chat list beside the chat, in the two-column layout.
  late final paneListWidth = propertyDefault('paneListWidth', 264.0);

  // fl_tty's, through `lib/core/tty.dart`: the Linux userland the `shell`
  // tool runs in on Android and iOS. None of them stamps the sync clock.

  late final linuxProfile = propertyDefault('linuxProfile', '', updateLastModified: false);

  late final linuxDistro = propertyDefault('linuxDistro', 'alpine', updateLastModified: false);

  late final linuxMirrors = propertyDefault<Map<String, String>>(
    'linuxMirrors',
    const {},
    updateLastModified: false,
    fromObj: (raw) => raw is Map ? raw.map((k, v) => MapEntry('$k', '$v')) : const {},
  );

  late final linuxDns = propertyDefault('linuxDns', '', updateLastModified: false);

  late final rootfsManifestSerial = propertyDefault('rootfsManifestSerial', 0, updateLastModified: false);

  late final rootfsManifestCache = propertyDefault('rootfsManifestCache', '', updateLastModified: false);

  late final rootfsManifestCacheSig = propertyDefault('rootfsManifestCacheSig', '', updateLastModified: false);
}
