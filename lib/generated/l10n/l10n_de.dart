// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get auto => 'Automatisch';

  @override
  String get autoCheckUpdate => 'Automatisch nach Updates suchen';

  @override
  String get backupTip =>
      'Bitte stellen Sie sicher, dass Ihre Sicherungsdatei privat und sicher ist!';

  @override
  String get chat => 'Chat';

  @override
  String get clickToCheck => 'Zum Überprüfen klicken';

  @override
  String get codeBlock => 'Codeblock';

  @override
  String get copied => 'Kopiert';

  @override
  String get current => 'Aktuell';

  @override
  String delFmt(Object id, Object type) {
    return '$type ($id) löschen?';
  }

  @override
  String get deleteConfirm => 'Vor dem Löschen bestätigen';

  @override
  String emptyFields(Object fields) {
    return '$fields sind leer';
  }

  @override
  String get emptyTrashTip =>
      '==0, beim nächsten Start löschen. <0 nicht automatisch löschen.';

  @override
  String get genChatTitle => 'Chat-Titel generieren';

  @override
  String get image => 'Bild';

  @override
  String invalidLinkFmt(Object uri) {
    return 'Unbekannter Link: $uri';
  }

  @override
  String get languageName => 'Deutsch';

  @override
  String get license => 'Lizenz';

  @override
  String get licenseMenuItem => 'Open-Source-Lizenzen';

  @override
  String get manual => 'Manuell';

  @override
  String get more => 'Mehr';

  @override
  String get myOtherApps => 'Meine anderen Apps';

  @override
  String get newChat => 'Neuer Chat';

  @override
  String get passwd => 'Passwort';

  @override
  String get privacy => 'Datenschutz';

  @override
  String get privacyTip => 'Diese App sammelt keine Informationen.';

  @override
  String get rename => 'Umbenennen';

  @override
  String get share => 'Teilen';

  @override
  String get shareFrom => 'Geteilt von';

  @override
  String get softWrap => 'Zeilenumbruch';

  @override
  String sureRestoreFmt(Object time) {
    return 'Sind Sie sicher, dass Sie die Sicherung ($time) wiederherstellen möchten?';
  }

  @override
  String syncConflict(Object a, Object b) {
    return 'Konflikt: $a und $b können nicht gleichzeitig aktiviert werden';
  }

  @override
  String get text => 'Text';

  @override
  String get themeColorSeed => 'Farbsamen für das Theme';

  @override
  String get themeMode => 'Theme-Modus';

  @override
  String get untitled => 'Unbenannt';

  @override
  String get usage => 'Verwendung';

  @override
  String get user => 'Benutzer';

  @override
  String get trash => 'Papierkorb';

  @override
  String get startChatTip => 'Wähle unten ein Modell und schreib etwas.';

  @override
  String get noProviderKey =>
      'Noch kein Anbieter hat einen Schlüssel. Füge einen hinzu, um zu chatten.';

  @override
  String get providers => 'Anbieter';

  @override
  String providersCountFmt(int n) {
    return '$n Anbieter';
  }

  @override
  String get today => 'Heute';

  @override
  String get earlier => 'Früher';

  @override
  String get now => 'jetzt';

  @override
  String minutesFmt(int n) {
    return '$n Min.';
  }

  @override
  String hoursFmt(int n) {
    return '$n Std.';
  }

  @override
  String messagesCountFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Nachrichten',
      one: '1 Nachricht',
    );
    return '$_temp0';
  }

  @override
  String get version => 'Version';

  @override
  String get toolsAndMcp => 'Werkzeuge & MCP';

  @override
  String get backToChats => 'Zurück zu den Chats';

  @override
  String get genChatTitleTip => 'Benennt einen Chat nach der ersten Antwort';

  @override
  String get scrollOnNewMsg => 'Bei neuer Nachricht nach unten scrollen';

  @override
  String get scrollAfterSwitch => 'Nach Chatwechsel nach unten scrollen';

  @override
  String chatsCountFmt(int n) {
    return '$n Chats';
  }

  @override
  String get emptyTrashAfter => 'Papierkorb leeren nach';

  @override
  String get trashTip => 'Gelöschte Chats landen zuerst hier';

  @override
  String daysFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Tage',
      one: '1 Tag',
    );
    return '$_temp0';
  }

  @override
  String get sync => 'Synchronisierung';

  @override
  String get syncNow => 'Jetzt synchronisieren';

  @override
  String get syncing => 'Wird synchronisiert…';

  @override
  String get neverSynced => 'Noch nicht synchronisiert';

  @override
  String lastSyncFmt(String time) {
    return 'Zuletzt synchronisiert: $time';
  }

  @override
  String get syncOffTip =>
      'Schalte unten LK Cloud, iCloud oder WebDAV ein, um automatisch zu synchronisieren.';

  @override
  String get backupPassword => 'Backup-Passwort';

  @override
  String get backupEncrypted => 'Backups werden damit verschlüsselt';

  @override
  String get backupNotEncrypted =>
      'Nicht gesetzt: Datei-Backups sind unverschlüsselt, und die Synchronisierung braucht eines';

  @override
  String get backupEncryptedTip => 'Dieses Backup ist verschlüsselt';

  @override
  String get backupPasswordRequired =>
      'Lege zuerst ein Backup-Passwort fest: synchronisierte Backups sind immer verschlüsselt';

  @override
  String get passwordWrong => 'Falsches Passwort oder beschädigtes Backup';

  @override
  String get backupTooNew =>
      'Dieses Backup stammt aus einer neueren App-Version. Aktualisiere, um es wiederherzustellen.';

  @override
  String get syncAppSettings => 'App-Einstellungen synchronisieren';

  @override
  String get syncAppSettingsTip =>
      'Fenstergröße und Titelleiste bleiben pro Gerät';

  @override
  String get webdavManualTip =>
      'Eine datierte Kopie neben der synchronisierten';

  @override
  String get exportFile => 'In eine Datei exportieren';

  @override
  String get importFile => 'Aus einer Datei wiederherstellen';

  @override
  String get copyBackup => 'In die Zwischenablage kopieren';

  @override
  String get pasteBackup => 'Aus der Zwischenablage wiederherstellen';

  @override
  String get pullNewChat => 'Nach unten ziehen für einen neuen Chat';

  @override
  String get releaseNewChat => 'Loslassen für einen neuen Chat';

  @override
  String get pullOlderChat =>
      'Nach oben ziehen und halten für den vorherigen Chat';

  @override
  String holdOlderChatFmt(String title) {
    return 'Weiter halten: $title';
  }

  @override
  String get shellTool => 'Shell';

  @override
  String get shellToolTip =>
      'Führt Befehle auf diesem Gerät aus, jeden nach deiner Zustimmung';

  @override
  String get linuxEnv => 'Linux-Umgebung';

  @override
  String get linuxEnvTip =>
      'Hier läuft die Shell auf diesem Telefon. Sie sieht die eigenen Dateien des Telefons nicht.';

  @override
  String linuxInstallTip(String distro, String version, int size) {
    return '$distro $version herunterladen, $size MB?';
  }

  @override
  String linuxRemoveTip(String name) {
    return '$name und alles darin Installierte löschen?';
  }

  @override
  String get linuxInUse => 'Darin läuft ein Befehl';

  @override
  String get linuxNone => 'Nicht installiert';

  @override
  String get syncChats => 'Chats synchronisieren';

  @override
  String get syncAi => 'Modelle, Werkzeuge und Gedächtnis synchronisieren';

  @override
  String get syncSecrets => 'API-Schlüssel und MCP-Geheimnisse synchronisieren';

  @override
  String get syncPasswordMismatch =>
      'Das Backup-Passwort öffnet den Schlüssel dieser Synchronisierung nicht: ein anderes Gerät hat es geändert';

  @override
  String get syncTooNew =>
      'Von einer neueren Version synchronisiert: aktualisieren, um weiter zu synchronisieren';

  @override
  String syncRefused(String reason) {
    return 'LK Cloud hat die Synchronisierung abgelehnt ($reason)';
  }

  @override
  String get rotateSyncKey => 'Sync-Schlüssel ersetzen';
}
