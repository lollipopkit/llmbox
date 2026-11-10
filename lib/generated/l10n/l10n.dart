import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_de.dart';
import 'l10n_en.dart';
import 'l10n_es.dart';
import 'l10n_fr.dart';
import 'l10n_id.dart';
import 'l10n_ja.dart';
import 'l10n_nl.dart';
import 'l10n_pt.dart';
import 'l10n_ru.dart';
import 'l10n_tr.dart';
import 'l10n_uk.dart';
import 'l10n_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('id'),
    Locale('ja'),
    Locale('nl'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
    Locale('uk'),
    Locale('zh'),
    Locale('zh', 'TW'),
  ];

  /// No description provided for @auto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get auto;

  /// No description provided for @autoCheckUpdate.
  ///
  /// In en, this message translates to:
  /// **'Auto check for updates'**
  String get autoCheckUpdate;

  /// No description provided for @backupTip.
  ///
  /// In en, this message translates to:
  /// **'Please keep backup files private and safe!'**
  String get backupTip;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @clickToCheck.
  ///
  /// In en, this message translates to:
  /// **'Click to check'**
  String get clickToCheck;

  /// No description provided for @codeBlock.
  ///
  /// In en, this message translates to:
  /// **'Code block'**
  String get codeBlock;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @delFmt.
  ///
  /// In en, this message translates to:
  /// **'Delete {type}({id})?'**
  String delFmt(Object id, Object type);

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm before deleting'**
  String get deleteConfirm;

  /// No description provided for @emptyFields.
  ///
  /// In en, this message translates to:
  /// **'{fields} is empty'**
  String emptyFields(Object fields);

  /// No description provided for @emptyTrashTip.
  ///
  /// In en, this message translates to:
  /// **'==0, delete on next startup. <0 do not delete automatically.'**
  String get emptyTrashTip;

  /// No description provided for @genChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat title generator'**
  String get genChatTitle;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// No description provided for @invalidLinkFmt.
  ///
  /// In en, this message translates to:
  /// **'Invalid link: {uri}'**
  String invalidLinkFmt(Object uri);

  /// No description provided for @languageName.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageName;

  /// No description provided for @license.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get license;

  /// No description provided for @licenseMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Open-source licenses'**
  String get licenseMenuItem;

  /// No description provided for @manual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manual;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @myOtherApps.
  ///
  /// In en, this message translates to:
  /// **'My other apps'**
  String get myOtherApps;

  /// No description provided for @newChat.
  ///
  /// In en, this message translates to:
  /// **'New chat'**
  String get newChat;

  /// No description provided for @passwd.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwd;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @privacyTip.
  ///
  /// In en, this message translates to:
  /// **'This app does not collect any data.'**
  String get privacyTip;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @shareFrom.
  ///
  /// In en, this message translates to:
  /// **'Share from'**
  String get shareFrom;

  /// No description provided for @softWrap.
  ///
  /// In en, this message translates to:
  /// **'Soft wrap'**
  String get softWrap;

  /// No description provided for @sureRestoreFmt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to restore Backup({time})?'**
  String sureRestoreFmt(Object time);

  /// No description provided for @syncConflict.
  ///
  /// In en, this message translates to:
  /// **'Sync conflict: can\'t turn on {a} and {b} at the same time.'**
  String syncConflict(Object a, Object b);

  /// No description provided for @text.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get text;

  /// No description provided for @themeColorSeed.
  ///
  /// In en, this message translates to:
  /// **'Theme color seed'**
  String get themeColorSeed;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme mode'**
  String get themeMode;

  /// No description provided for @untitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get untitled;

  /// No description provided for @usage.
  ///
  /// In en, this message translates to:
  /// **'Usage'**
  String get usage;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @trash.
  ///
  /// In en, this message translates to:
  /// **'Trash'**
  String get trash;

  /// No description provided for @startChatTip.
  ///
  /// In en, this message translates to:
  /// **'Pick a model below and say something.'**
  String get startChatTip;

  /// No description provided for @noProviderKey.
  ///
  /// In en, this message translates to:
  /// **'No provider has a key yet. Add one to start chatting.'**
  String get noProviderKey;

  /// No description provided for @providers.
  ///
  /// In en, this message translates to:
  /// **'Providers'**
  String get providers;

  /// No description provided for @providersCountFmt.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 provider} other{{n} providers}}'**
  String providersCountFmt(int n);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @earlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get earlier;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get now;

  /// No description provided for @minutesFmt.
  ///
  /// In en, this message translates to:
  /// **'{n} min'**
  String minutesFmt(int n);

  /// No description provided for @hoursFmt.
  ///
  /// In en, this message translates to:
  /// **'{n} h'**
  String hoursFmt(int n);

  /// No description provided for @messagesCountFmt.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 message} other{{n} messages}}'**
  String messagesCountFmt(int n);

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @toolsAndMcp.
  ///
  /// In en, this message translates to:
  /// **'Tools & MCP'**
  String get toolsAndMcp;

  /// No description provided for @backToChats.
  ///
  /// In en, this message translates to:
  /// **'Back to chats'**
  String get backToChats;

  /// No description provided for @genChatTitleTip.
  ///
  /// In en, this message translates to:
  /// **'Names a chat after its first reply'**
  String get genChatTitleTip;

  /// No description provided for @scrollOnNewMsg.
  ///
  /// In en, this message translates to:
  /// **'Scroll to bottom on new message'**
  String get scrollOnNewMsg;

  /// No description provided for @scrollAfterSwitch.
  ///
  /// In en, this message translates to:
  /// **'Scroll to bottom after switching chat'**
  String get scrollAfterSwitch;

  /// No description provided for @chatsCountFmt.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 chat} other{{n} chats}}'**
  String chatsCountFmt(int n);

  /// No description provided for @emptyTrashAfter.
  ///
  /// In en, this message translates to:
  /// **'Empty trash after'**
  String get emptyTrashAfter;

  /// No description provided for @trashTip.
  ///
  /// In en, this message translates to:
  /// **'Deleted chats wait here first'**
  String get trashTip;

  /// No description provided for @daysFmt.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 day} other{{n} days}}'**
  String daysFmt(int n);

  /// No description provided for @sync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sync;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNow;

  /// No description provided for @syncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing…'**
  String get syncing;

  /// No description provided for @neverSynced.
  ///
  /// In en, this message translates to:
  /// **'Not synced yet'**
  String get neverSynced;

  /// No description provided for @lastSyncFmt.
  ///
  /// In en, this message translates to:
  /// **'Last synced {time}'**
  String lastSyncFmt(String time);

  /// No description provided for @syncOffTip.
  ///
  /// In en, this message translates to:
  /// **'Turn on iCloud or WebDAV below to sync automatically.'**
  String get syncOffTip;

  /// No description provided for @backupPassword.
  ///
  /// In en, this message translates to:
  /// **'Backup password'**
  String get backupPassword;

  /// No description provided for @backupEncrypted.
  ///
  /// In en, this message translates to:
  /// **'Backups are encrypted with it'**
  String get backupEncrypted;

  /// No description provided for @backupNotEncrypted.
  ///
  /// In en, this message translates to:
  /// **'Not set: file backups are plain text, and sync needs one'**
  String get backupNotEncrypted;

  /// No description provided for @backupEncryptedTip.
  ///
  /// In en, this message translates to:
  /// **'This backup is encrypted'**
  String get backupEncryptedTip;

  /// No description provided for @backupPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Set a backup password first: synced backups are always encrypted'**
  String get backupPasswordRequired;

  /// No description provided for @passwordWrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong password, or the backup is damaged'**
  String get passwordWrong;

  /// No description provided for @backupTooNew.
  ///
  /// In en, this message translates to:
  /// **'This backup is from a newer version of the app. Update to restore it.'**
  String get backupTooNew;

  /// No description provided for @syncAppSettings.
  ///
  /// In en, this message translates to:
  /// **'Sync app settings'**
  String get syncAppSettings;

  /// No description provided for @syncAppSettingsTip.
  ///
  /// In en, this message translates to:
  /// **'Window size and title bar stay per device'**
  String get syncAppSettingsTip;

  /// No description provided for @webdavManualTip.
  ///
  /// In en, this message translates to:
  /// **'A dated copy beside the synced one'**
  String get webdavManualTip;

  /// No description provided for @exportFile.
  ///
  /// In en, this message translates to:
  /// **'Export to a file'**
  String get exportFile;

  /// No description provided for @importFile.
  ///
  /// In en, this message translates to:
  /// **'Restore from a file'**
  String get importFile;

  /// No description provided for @copyBackup.
  ///
  /// In en, this message translates to:
  /// **'Copy to clipboard'**
  String get copyBackup;

  /// No description provided for @pasteBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore from clipboard'**
  String get pasteBackup;

  /// No description provided for @pullNewChat.
  ///
  /// In en, this message translates to:
  /// **'Pull down for a new chat'**
  String get pullNewChat;

  /// No description provided for @releaseNewChat.
  ///
  /// In en, this message translates to:
  /// **'Release for a new chat'**
  String get releaseNewChat;

  /// No description provided for @pullOlderChat.
  ///
  /// In en, this message translates to:
  /// **'Pull up and hold for the previous chat'**
  String get pullOlderChat;

  /// No description provided for @holdOlderChatFmt.
  ///
  /// In en, this message translates to:
  /// **'Keep holding: {title}'**
  String holdOlderChatFmt(String title);

  /// No description provided for @shellTool.
  ///
  /// In en, this message translates to:
  /// **'Shell'**
  String get shellTool;

  /// No description provided for @shellToolTip.
  ///
  /// In en, this message translates to:
  /// **'Runs commands on this device, each after you approve it'**
  String get shellToolTip;

  /// No description provided for @linuxEnv.
  ///
  /// In en, this message translates to:
  /// **'Linux environment'**
  String get linuxEnv;

  /// No description provided for @linuxEnvTip.
  ///
  /// In en, this message translates to:
  /// **'Where the shell runs on this phone. It cannot see the phone\'s own files.'**
  String get linuxEnvTip;

  /// No description provided for @linuxInstallTip.
  ///
  /// In en, this message translates to:
  /// **'Download {distro} {version}, {size} MB?'**
  String linuxInstallTip(String distro, String version, int size);

  /// No description provided for @linuxRemoveTip.
  ///
  /// In en, this message translates to:
  /// **'Delete {name} and everything installed in it?'**
  String linuxRemoveTip(String name);

  /// No description provided for @linuxInUse.
  ///
  /// In en, this message translates to:
  /// **'A command is running in it'**
  String get linuxInUse;

  /// No description provided for @linuxNone.
  ///
  /// In en, this message translates to:
  /// **'Not installed'**
  String get linuxNone;

  /// No description provided for @syncChats.
  ///
  /// In en, this message translates to:
  /// **'Sync chats'**
  String get syncChats;

  /// No description provided for @syncAi.
  ///
  /// In en, this message translates to:
  /// **'Sync models, tools and memory'**
  String get syncAi;

  /// No description provided for @syncSecrets.
  ///
  /// In en, this message translates to:
  /// **'Sync API keys and MCP secrets'**
  String get syncSecrets;

  /// No description provided for @syncPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'The backup password does not open this sync\'s key: another device changed it'**
  String get syncPasswordMismatch;

  /// No description provided for @syncTooNew.
  ///
  /// In en, this message translates to:
  /// **'Synced from a newer version: update to keep syncing'**
  String get syncTooNew;

  /// No description provided for @syncRefused.
  ///
  /// In en, this message translates to:
  /// **'LK Cloud refused the sync ({reason})'**
  String syncRefused(String reason);

  /// No description provided for @rotateSyncKey.
  ///
  /// In en, this message translates to:
  /// **'Replace sync key'**
  String get rotateSyncKey;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'id',
    'ja',
    'nl',
    'pt',
    'ru',
    'tr',
    'uk',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'id':
      return AppLocalizationsId();
    case 'ja':
      return AppLocalizationsJa();
    case 'nl':
      return AppLocalizationsNl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
