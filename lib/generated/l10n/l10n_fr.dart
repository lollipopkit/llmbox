// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get auto => 'Auto';

  @override
  String get autoCheckUpdate => 'Vérifier automatiquement les mises à jour';

  @override
  String get backupTip =>
      'Assurez-vous que votre fichier de sauvegarde est privé et sécurisé !';

  @override
  String get chat => 'Chat';

  @override
  String get clickToCheck => 'Cliquer pour vérifier';

  @override
  String get codeBlock => 'Bloc de code';

  @override
  String get copied => 'Copié';

  @override
  String get current => 'Actuel';

  @override
  String delFmt(Object id, Object type) {
    return 'Supprimer $type ($id) ?';
  }

  @override
  String get deleteConfirm => 'Confirmer avant de supprimer';

  @override
  String emptyFields(Object fields) {
    return '$fields sont vides';
  }

  @override
  String get emptyTrashTip =>
      '==0, supprimer au prochain démarrage. <0 ne pas supprimer automatiquement.';

  @override
  String get genChatTitle => 'Générer un titre de chat';

  @override
  String get image => 'Image';

  @override
  String invalidLinkFmt(Object uri) {
    return 'Lien inconnu : $uri';
  }

  @override
  String get languageName => 'Français';

  @override
  String get license => 'Licence';

  @override
  String get licenseMenuItem => 'Licences open source';

  @override
  String get manual => 'Manuel';

  @override
  String get more => 'Plus';

  @override
  String get myOtherApps => 'Mes autres applications';

  @override
  String get newChat => 'Nouveau chat';

  @override
  String get passwd => 'Mot de passe';

  @override
  String get privacy => 'Confidentialité';

  @override
  String get privacyTip => 'Cette application ne collecte aucune information.';

  @override
  String get rename => 'Renommer';

  @override
  String get share => 'Partager';

  @override
  String get shareFrom => 'Partagé depuis';

  @override
  String get softWrap => 'Retour à la ligne automatique';

  @override
  String sureRestoreFmt(Object time) {
    return 'Êtes-vous sûr de vouloir restaurer la sauvegarde ($time) ?';
  }

  @override
  String syncConflict(Object a, Object b) {
    return 'Conflit : impossible d\'activer $a et $b en même temps';
  }

  @override
  String get text => 'Texte';

  @override
  String get themeColorSeed => 'Graine de couleur du thème';

  @override
  String get themeMode => 'Mode de thème';

  @override
  String get untitled => 'Sans titre';

  @override
  String get usage => 'Utilisation';

  @override
  String get user => 'Utilisateur';

  @override
  String get trash => 'Corbeille';

  @override
  String get startChatTip =>
      'Choisissez un modèle ci-dessous et écrivez quelque chose.';

  @override
  String get noProviderKey =>
      'Aucun fournisseur n\'a encore de clé. Ajoutez-en une pour commencer à discuter.';

  @override
  String get providers => 'Fournisseurs';

  @override
  String providersCountFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n fournisseurs',
      one: '1 fournisseur',
    );
    return '$_temp0';
  }

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get earlier => 'Plus tôt';

  @override
  String get now => 'maintenant';

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
  String get toolsAndMcp => 'Outils et MCP';

  @override
  String get backToChats => 'Retour aux discussions';

  @override
  String get genChatTitleTip => 'Nomme la discussion après la première réponse';

  @override
  String get scrollOnNewMsg => 'Défiler en bas à chaque nouveau message';

  @override
  String get scrollAfterSwitch =>
      'Défiler en bas après un changement de discussion';

  @override
  String chatsCountFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n discussions',
      one: '1 discussion',
    );
    return '$_temp0';
  }

  @override
  String get emptyTrashAfter => 'Vider la corbeille après';

  @override
  String get trashTip => 'Les discussions supprimées attendent d\'abord ici';

  @override
  String daysFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n jours',
      one: '1 jour',
    );
    return '$_temp0';
  }

  @override
  String get sync => 'Synchronisation';

  @override
  String get syncNow => 'Synchroniser maintenant';

  @override
  String get syncing => 'Synchronisation…';

  @override
  String get neverSynced => 'Pas encore synchronisé';

  @override
  String lastSyncFmt(String time) {
    return 'Dernière synchronisation : $time';
  }

  @override
  String get syncOffTip =>
      'Activez iCloud ou WebDAV ci-dessous pour synchroniser automatiquement.';

  @override
  String get backupPassword => 'Mot de passe de sauvegarde';

  @override
  String get backupEncrypted => 'Les sauvegardes sont chiffrées avec';

  @override
  String get backupNotEncrypted =>
      'Non défini : les sauvegardes en fichier sont en clair, et la synchronisation en exige un';

  @override
  String get backupEncryptedTip => 'Cette sauvegarde est chiffrée';

  @override
  String get backupPasswordRequired =>
      'Définissez d\'abord un mot de passe : les sauvegardes synchronisées sont toujours chiffrées';

  @override
  String get passwordWrong => 'Mot de passe incorrect ou sauvegarde endommagée';

  @override
  String get backupTooNew =>
      'Cette sauvegarde vient d\'une version plus récente de l\'app. Mettez à jour pour la restaurer.';

  @override
  String get syncAppSettings => 'Synchroniser les réglages de l\'app';

  @override
  String get syncAppSettingsTip =>
      'La taille de fenêtre et la barre de titre restent propres à l\'appareil';

  @override
  String get webdavManualTip => 'Une copie datée à côté de celle synchronisée';

  @override
  String get exportFile => 'Exporter dans un fichier';

  @override
  String get importFile => 'Restaurer depuis un fichier';

  @override
  String get copyBackup => 'Copier dans le presse-papiers';

  @override
  String get pasteBackup => 'Restaurer depuis le presse-papiers';

  @override
  String get pullNewChat => 'Tirez vers le bas pour un nouveau chat';

  @override
  String get releaseNewChat => 'Relâchez pour un nouveau chat';

  @override
  String get pullOlderChat =>
      'Tirez vers le haut et maintenez pour le chat précédent';

  @override
  String holdOlderChatFmt(String title) {
    return 'Maintenez : $title';
  }

  @override
  String get shellTool => 'Shell';

  @override
  String get shellToolTip =>
      'Exécute des commandes sur cet appareil, chacune après ton accord';

  @override
  String get linuxEnv => 'Environnement Linux';

  @override
  String get linuxEnvTip =>
      'Là où le shell s\'exécute sur ce téléphone. Il ne voit pas les fichiers du téléphone.';

  @override
  String linuxInstallTip(String distro, String version, int size) {
    return 'Télécharger $distro $version, $size Mo ?';
  }

  @override
  String linuxRemoveTip(String name) {
    return 'Supprimer $name et tout ce qui y est installé ?';
  }

  @override
  String get linuxInUse => 'Une commande y est en cours';

  @override
  String get linuxNone => 'Non installé';

  @override
  String get syncChats => 'Synchroniser les discussions';

  @override
  String get syncAi => 'Synchroniser modèles, outils et mémoire';

  @override
  String get syncSecrets => 'Synchroniser les clés d\'API et les secrets MCP';

  @override
  String get syncPasswordMismatch =>
      'Le mot de passe de sauvegarde n\'ouvre pas la clé de cette synchronisation : un autre appareil l\'a changé';

  @override
  String get syncTooNew =>
      'Synchronisé depuis une version plus récente : mettez à jour pour continuer';

  @override
  String syncRefused(String reason) {
    return 'LK Cloud a refusé la synchronisation ($reason)';
  }

  @override
  String get rotateSyncKey => 'Remplacer la clé de synchronisation';
}
