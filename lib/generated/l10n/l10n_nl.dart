// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get auto => 'Auto';

  @override
  String get autoCheckUpdate => 'Automatisch controleren op updates';

  @override
  String get backupTip =>
      'Zorg ervoor dat uw back-upbestand privé en veilig is!';

  @override
  String get chat => 'Chat';

  @override
  String get clickToCheck => 'Klik om te controleren';

  @override
  String get codeBlock => 'Codeblok';

  @override
  String get copied => 'Gekopieerd';

  @override
  String get current => 'Huidig';

  @override
  String delFmt(Object id, Object type) {
    return '$type ($id) verwijderen?';
  }

  @override
  String get deleteConfirm => 'Bevestigen voor verwijderen';

  @override
  String emptyFields(Object fields) {
    return '$fields zijn leeg';
  }

  @override
  String get emptyTrashTip =>
      '==0, bij de volgende start verwijderen. <0 niet automatisch verwijderen.';

  @override
  String get genChatTitle => 'Chattitel genereren';

  @override
  String get image => 'Afbeelding';

  @override
  String invalidLinkFmt(Object uri) {
    return 'Onbekende link: $uri';
  }

  @override
  String get languageName => 'Nederlands';

  @override
  String get license => 'Licentie';

  @override
  String get licenseMenuItem => 'Open-source licenties';

  @override
  String get manual => 'Handmatig';

  @override
  String get more => 'Meer';

  @override
  String get myOtherApps => 'Mijn andere apps';

  @override
  String get newChat => 'Nieuwe chat';

  @override
  String get passwd => 'Wachtwoord';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyTip => 'Deze app verzamelt geen informatie.';

  @override
  String get rename => 'Hernoemen';

  @override
  String get share => 'Delen';

  @override
  String get shareFrom => 'Gedeeld van';

  @override
  String get softWrap => 'Zachte terugloop';

  @override
  String sureRestoreFmt(Object time) {
    return 'Weet u zeker dat u de back-up ($time) wilt herstellen?';
  }

  @override
  String syncConflict(Object a, Object b) {
    return 'Conflict: kan $a en $b niet tegelijkertijd activeren';
  }

  @override
  String get text => 'Tekst';

  @override
  String get themeColorSeed => 'Themakleurzaad';

  @override
  String get themeMode => 'Thema-modus';

  @override
  String get untitled => 'Naamloos';

  @override
  String get usage => 'Gebruik';

  @override
  String get user => 'Gebruiker';

  @override
  String get trash => 'Prullenbak';

  @override
  String get startChatTip => 'Kies hieronder een model en zeg iets.';

  @override
  String get noProviderKey =>
      'Nog geen enkele provider heeft een sleutel. Voeg er een toe om te chatten.';

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
  String get today => 'Vandaag';

  @override
  String get earlier => 'Eerder';

  @override
  String get now => 'nu';

  @override
  String minutesFmt(int n) {
    return '$n min';
  }

  @override
  String hoursFmt(int n) {
    return '$n u';
  }

  @override
  String messagesCountFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n berichten',
      one: '1 bericht',
    );
    return '$_temp0';
  }

  @override
  String get version => 'Versie';

  @override
  String get toolsAndMcp => 'Tools & MCP';

  @override
  String get backToChats => 'Terug naar chats';

  @override
  String get genChatTitleTip =>
      'Geeft een chat een naam na het eerste antwoord';

  @override
  String get scrollOnNewMsg => 'Naar beneden scrollen bij nieuw bericht';

  @override
  String get scrollAfterSwitch => 'Naar beneden scrollen na wisselen van chat';

  @override
  String chatsCountFmt(int n) {
    return '$n chats';
  }

  @override
  String get emptyTrashAfter => 'Prullenbak legen na';

  @override
  String get trashTip => 'Verwijderde chats wachten eerst hier';

  @override
  String daysFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n dagen',
      one: '1 dag',
    );
    return '$_temp0';
  }

  @override
  String get sync => 'Synchronisatie';

  @override
  String get syncNow => 'Nu synchroniseren';

  @override
  String get syncing => 'Synchroniseren…';

  @override
  String get neverSynced => 'Nog niet gesynchroniseerd';

  @override
  String lastSyncFmt(String time) {
    return 'Laatst gesynchroniseerd: $time';
  }

  @override
  String get syncOffTip =>
      'Zet hieronder iCloud of WebDAV aan om automatisch te synchroniseren.';

  @override
  String get backupPassword => 'Back-upwachtwoord';

  @override
  String get backupEncrypted => 'Back-ups worden hiermee versleuteld';

  @override
  String get backupNotEncrypted =>
      'Niet ingesteld: bestandsback-ups zijn onversleuteld en synchronisatie vereist er een';

  @override
  String get backupEncryptedTip => 'Deze back-up is versleuteld';

  @override
  String get backupPasswordRequired =>
      'Stel eerst een back-upwachtwoord in: gesynchroniseerde back-ups zijn altijd versleuteld';

  @override
  String get passwordWrong => 'Verkeerd wachtwoord of beschadigde back-up';

  @override
  String get backupTooNew =>
      'Deze back-up komt uit een nieuwere versie van de app. Werk bij om hem te herstellen.';

  @override
  String get syncAppSettings => 'App-instellingen synchroniseren';

  @override
  String get syncAppSettingsTip =>
      'Venstergrootte en titelbalk blijven per apparaat';

  @override
  String get webdavManualTip =>
      'Een gedateerde kopie naast de gesynchroniseerde';

  @override
  String get exportFile => 'Naar een bestand exporteren';

  @override
  String get importFile => 'Herstellen uit een bestand';

  @override
  String get copyBackup => 'Naar klembord kopiëren';

  @override
  String get pasteBackup => 'Herstellen vanaf klembord';

  @override
  String get pullNewChat => 'Omlaag trekken voor een nieuwe chat';

  @override
  String get releaseNewChat => 'Loslaten voor een nieuwe chat';

  @override
  String get pullOlderChat =>
      'Omhoog trekken en vasthouden voor de vorige chat';

  @override
  String holdOlderChatFmt(String title) {
    return 'Blijf vasthouden: $title';
  }

  @override
  String get shellTool => 'Shell';

  @override
  String get shellToolTip =>
      'Voert opdrachten uit op dit apparaat, elk na jouw goedkeuring';

  @override
  String get linuxEnv => 'Linux-omgeving';

  @override
  String get linuxEnvTip =>
      'Waar de shell op deze telefoon draait. Hij ziet de eigen bestanden van de telefoon niet.';

  @override
  String linuxInstallTip(String distro, String version, int size) {
    return '$distro $version downloaden, $size MB?';
  }

  @override
  String linuxRemoveTip(String name) {
    return '$name en alles wat erin is geïnstalleerd verwijderen?';
  }

  @override
  String get linuxInUse => 'Er draait een opdracht in';

  @override
  String get linuxNone => 'Niet geïnstalleerd';

  @override
  String get syncChats => 'Chats synchroniseren';

  @override
  String get syncAi => 'Modellen, tools en geheugen synchroniseren';

  @override
  String get syncSecrets => 'API-sleutels en MCP-geheimen synchroniseren';

  @override
  String get syncPasswordMismatch =>
      'Het back-upwachtwoord opent de sleutel van deze synchronisatie niet: een ander apparaat heeft het gewijzigd';

  @override
  String get syncTooNew =>
      'Gesynchroniseerd vanaf een nieuwere versie: werk bij om te blijven synchroniseren';

  @override
  String syncRefused(String reason) {
    return 'LK Cloud weigerde de synchronisatie ($reason)';
  }

  @override
  String get rotateSyncKey => 'Synchronisatiesleutel vervangen';
}
