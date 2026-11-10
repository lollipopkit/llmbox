// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get auto => 'Auto';

  @override
  String get autoCheckUpdate => 'Auto check for updates';

  @override
  String get backupTip => 'Please keep backup files private and safe!';

  @override
  String get chat => 'Chat';

  @override
  String get clickToCheck => 'Click to check';

  @override
  String get codeBlock => 'Code block';

  @override
  String get copied => 'Copied';

  @override
  String get current => 'Current';

  @override
  String delFmt(Object id, Object type) {
    return 'Delete $type($id)?';
  }

  @override
  String get deleteConfirm => 'Confirm before deleting';

  @override
  String emptyFields(Object fields) {
    return '$fields is empty';
  }

  @override
  String get emptyTrashTip =>
      '==0, delete on next startup. <0 do not delete automatically.';

  @override
  String get genChatTitle => 'Chat title generator';

  @override
  String get image => 'Image';

  @override
  String invalidLinkFmt(Object uri) {
    return 'Invalid link: $uri';
  }

  @override
  String get languageName => 'English';

  @override
  String get license => 'License';

  @override
  String get licenseMenuItem => 'Open-source licenses';

  @override
  String get manual => 'Manual';

  @override
  String get more => 'More';

  @override
  String get myOtherApps => 'My other apps';

  @override
  String get newChat => 'New chat';

  @override
  String get passwd => 'Password';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyTip => 'This app does not collect any data.';

  @override
  String get rename => 'Rename';

  @override
  String get share => 'Share';

  @override
  String get shareFrom => 'Share from';

  @override
  String get softWrap => 'Soft wrap';

  @override
  String sureRestoreFmt(Object time) {
    return 'Are you sure to restore Backup($time)?';
  }

  @override
  String syncConflict(Object a, Object b) {
    return 'Sync conflict: can\'t turn on $a and $b at the same time.';
  }

  @override
  String get text => 'Text';

  @override
  String get themeColorSeed => 'Theme color seed';

  @override
  String get themeMode => 'Theme mode';

  @override
  String get untitled => 'Untitled';

  @override
  String get usage => 'Usage';

  @override
  String get user => 'User';

  @override
  String get trash => 'Trash';

  @override
  String get startChatTip => 'Pick a model below and say something.';

  @override
  String get noProviderKey =>
      'No provider has a key yet. Add one to start chatting.';

  @override
  String get providers => 'Providers';

  @override
  String providersCountFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n providers',
      one: '1 provider',
    );
    return '$_temp0';
  }

  @override
  String get today => 'Today';

  @override
  String get earlier => 'Earlier';

  @override
  String get now => 'now';

  @override
  String minutesFmt(int n) {
    return '$n min';
  }

  @override
  String hoursFmt(int n) {
    return '$n h';
  }

  @override
  String messagesCountFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n messages',
      one: '1 message',
    );
    return '$_temp0';
  }

  @override
  String get version => 'Version';

  @override
  String get toolsAndMcp => 'Tools & MCP';

  @override
  String get backToChats => 'Back to chats';

  @override
  String get genChatTitleTip => 'Names a chat after its first reply';

  @override
  String get scrollOnNewMsg => 'Scroll to bottom on new message';

  @override
  String get scrollAfterSwitch => 'Scroll to bottom after switching chat';

  @override
  String chatsCountFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n chats',
      one: '1 chat',
    );
    return '$_temp0';
  }

  @override
  String get emptyTrashAfter => 'Empty trash after';

  @override
  String get trashTip => 'Deleted chats wait here first';

  @override
  String daysFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get sync => 'Sync';

  @override
  String get syncNow => 'Sync now';

  @override
  String get syncing => 'Syncing…';

  @override
  String get neverSynced => 'Not synced yet';

  @override
  String lastSyncFmt(String time) {
    return 'Last synced $time';
  }

  @override
  String get syncOffTip =>
      'Turn on LK Cloud, iCloud or WebDAV below to sync automatically.';

  @override
  String get backupPassword => 'Backup password';

  @override
  String get backupEncrypted => 'Backups are encrypted with it';

  @override
  String get backupNotEncrypted =>
      'Not set: file backups are plain text, and sync needs one';

  @override
  String get backupEncryptedTip => 'This backup is encrypted';

  @override
  String get backupPasswordRequired =>
      'Set a backup password first: synced backups are always encrypted';

  @override
  String get passwordWrong => 'Wrong password, or the backup is damaged';

  @override
  String get backupTooNew =>
      'This backup is from a newer version of the app. Update to restore it.';

  @override
  String get syncAppSettings => 'Sync app settings';

  @override
  String get syncAppSettingsTip => 'Window size and title bar stay per device';

  @override
  String get webdavManualTip => 'A dated copy beside the synced one';

  @override
  String get exportFile => 'Export to a file';

  @override
  String get importFile => 'Restore from a file';

  @override
  String get copyBackup => 'Copy to clipboard';

  @override
  String get pasteBackup => 'Restore from clipboard';

  @override
  String get pullNewChat => 'Pull down for a new chat';

  @override
  String get releaseNewChat => 'Release for a new chat';

  @override
  String get pullOlderChat => 'Pull up and hold for the previous chat';

  @override
  String holdOlderChatFmt(String title) {
    return 'Keep holding: $title';
  }

  @override
  String get shellTool => 'Shell';

  @override
  String get shellToolTip =>
      'Runs commands on this device, each after you approve it';

  @override
  String get linuxEnv => 'Linux environment';

  @override
  String get linuxEnvTip =>
      'Where the shell runs on this phone. It cannot see the phone\'s own files.';

  @override
  String linuxInstallTip(String distro, String version, int size) {
    return 'Download $distro $version, $size MB?';
  }

  @override
  String linuxRemoveTip(String name) {
    return 'Delete $name and everything installed in it?';
  }

  @override
  String get linuxInUse => 'A command is running in it';

  @override
  String get linuxNone => 'Not installed';

  @override
  String get syncChats => 'Sync chats';

  @override
  String get syncAi => 'Sync models, tools and memory';

  @override
  String get syncSecrets => 'Sync API keys and MCP secrets';

  @override
  String get syncPasswordMismatch =>
      'The backup password does not open this sync\'s key: another device changed it';

  @override
  String get syncTooNew =>
      'Synced from a newer version: update to keep syncing';

  @override
  String syncRefused(String reason) {
    return 'LK Cloud refused the sync ($reason)';
  }

  @override
  String get rotateSyncKey => 'Replace sync key';
}
