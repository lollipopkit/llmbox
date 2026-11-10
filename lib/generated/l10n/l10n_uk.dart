// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get auto => 'Авто';

  @override
  String get autoCheckUpdate => 'Автоматично перевіряти оновлення';

  @override
  String get backupTip =>
      'Будь ласка, зберігайте резервну копію файлу в безпеці та приватності!';

  @override
  String get chat => 'Чат';

  @override
  String get clickToCheck => 'Натисніть для перевірки';

  @override
  String get codeBlock => 'Блок коду';

  @override
  String get copied => 'Скопійовано';

  @override
  String get current => 'Поточний';

  @override
  String delFmt(Object id, Object type) {
    return 'Видалити $type ($id)?';
  }

  @override
  String get deleteConfirm => 'Підтвердити перед видаленням';

  @override
  String emptyFields(Object fields) {
    return '$fields порожні';
  }

  @override
  String get emptyTrashTip =>
      '==0, видалити під час наступного запуску. <0 не видаляти автоматично.';

  @override
  String get genChatTitle => 'Генерувати заголовок чату';

  @override
  String get image => 'Зображення';

  @override
  String invalidLinkFmt(Object uri) {
    return 'Невідоме посилання: $uri';
  }

  @override
  String get languageName => 'Українська';

  @override
  String get license => 'Ліцензія';

  @override
  String get licenseMenuItem => 'Ліцензії відкритого коду';

  @override
  String get manual => 'Вручну';

  @override
  String get more => 'Більше';

  @override
  String get myOtherApps => 'Мої інші додатки';

  @override
  String get newChat => 'Новий чат';

  @override
  String get passwd => 'Пароль';

  @override
  String get privacy => 'Конфіденційність';

  @override
  String get privacyTip => 'Цей додаток не збирає жодної інформації.';

  @override
  String get rename => 'Перейменувати';

  @override
  String get share => 'Поділитися';

  @override
  String get shareFrom => 'Поділитися з';

  @override
  String get softWrap => 'М\'який перенос';

  @override
  String sureRestoreFmt(Object time) {
    return 'Ви впевнені, що хочете відновити резервну копію ($time)?';
  }

  @override
  String syncConflict(Object a, Object b) {
    return 'Конфлікт: неможливо одночасно увімкнути $a та $b';
  }

  @override
  String get text => 'Текст';

  @override
  String get themeColorSeed => 'Насіння кольору теми';

  @override
  String get themeMode => 'Режим теми';

  @override
  String get untitled => 'Без назви';

  @override
  String get usage => 'Використання';

  @override
  String get user => 'Користувач';

  @override
  String get trash => 'Кошик';

  @override
  String get startChatTip => 'Виберіть модель нижче й напишіть щось.';

  @override
  String get noProviderKey =>
      'Жоден провайдер ще не має ключа. Додайте ключ, щоб почати чат.';

  @override
  String get providers => 'Провайдери';

  @override
  String providersCountFmt(int n) {
    return 'Провайдерів: $n';
  }

  @override
  String get today => 'Сьогодні';

  @override
  String get earlier => 'Раніше';

  @override
  String get now => 'щойно';

  @override
  String minutesFmt(int n) {
    return '$n хв';
  }

  @override
  String hoursFmt(int n) {
    return '$n год';
  }

  @override
  String messagesCountFmt(int n) {
    return 'Повідомлень: $n';
  }

  @override
  String get version => 'Версія';

  @override
  String get toolsAndMcp => 'Інструменти та MCP';

  @override
  String get backToChats => 'Назад до чатів';

  @override
  String get genChatTitleTip => 'Називає чат після першої відповіді';

  @override
  String get scrollOnNewMsg => 'Прокручувати вниз при новому повідомленні';

  @override
  String get scrollAfterSwitch => 'Прокручувати вниз після зміни чату';

  @override
  String chatsCountFmt(int n) {
    return 'Чатів: $n';
  }

  @override
  String get emptyTrashAfter => 'Очищати кошик через';

  @override
  String get trashTip => 'Видалені чати спершу потрапляють сюди';

  @override
  String daysFmt(int n) {
    return 'Днів: $n';
  }

  @override
  String get sync => 'Синхронізація';

  @override
  String get syncNow => 'Синхронізувати зараз';

  @override
  String get syncing => 'Синхронізація…';

  @override
  String get neverSynced => 'Ще не синхронізовано';

  @override
  String lastSyncFmt(String time) {
    return 'Остання синхронізація: $time';
  }

  @override
  String get syncOffTip =>
      'Увімкніть iCloud або WebDAV нижче для автоматичної синхронізації.';

  @override
  String get backupPassword => 'Пароль резервної копії';

  @override
  String get backupEncrypted => 'Резервні копії шифруються ним';

  @override
  String get backupNotEncrypted =>
      'Не задано: резервні копії у файл не шифруються, а для синхронізації він потрібен';

  @override
  String get backupEncryptedTip => 'Ця резервна копія зашифрована';

  @override
  String get backupPasswordRequired =>
      'Спершу задайте пароль: синхронізовані копії завжди шифруються';

  @override
  String get passwordWrong => 'Неправильний пароль або копія пошкоджена';

  @override
  String get backupTooNew =>
      'Ця копія з новішої версії застосунку. Оновіть застосунок, щоб відновити її.';

  @override
  String get syncAppSettings => 'Синхронізувати налаштування';

  @override
  String get syncAppSettingsTip =>
      'Розмір вікна й заголовок лишаються окремими для кожного пристрою';

  @override
  String get webdavManualTip => 'Датована копія поруч із синхронізованою';

  @override
  String get exportFile => 'Експорт у файл';

  @override
  String get importFile => 'Відновити з файлу';

  @override
  String get copyBackup => 'Скопіювати в буфер обміну';

  @override
  String get pasteBackup => 'Відновити з буфера обміну';

  @override
  String get pullNewChat => 'Потягніть униз для нового чату';

  @override
  String get releaseNewChat => 'Відпустіть для нового чату';

  @override
  String get pullOlderChat =>
      'Потягніть угору й утримуйте для попереднього чату';

  @override
  String holdOlderChatFmt(String title) {
    return 'Утримуйте: $title';
  }

  @override
  String get shellTool => 'Оболонка';

  @override
  String get shellToolTip =>
      'Виконує команди на цьому пристрої, кожну після вашого схвалення';

  @override
  String get linuxEnv => 'Середовище Linux';

  @override
  String get linuxEnvTip =>
      'Тут працює оболонка на цьому телефоні. Вона не бачить власних файлів телефону.';

  @override
  String linuxInstallTip(String distro, String version, int size) {
    return 'Завантажити $distro $version, $size МБ?';
  }

  @override
  String linuxRemoveTip(String name) {
    return 'Видалити $name і все, що в ньому встановлено?';
  }

  @override
  String get linuxInUse => 'У ній виконується команда';

  @override
  String get linuxNone => 'Не встановлено';

  @override
  String get syncChats => 'Синхронізувати чати';

  @override
  String get syncAi => 'Синхронізувати моделі, інструменти й пам\'ять';

  @override
  String get syncSecrets => 'Синхронізувати API-ключі та секрети MCP';

  @override
  String get syncPasswordMismatch =>
      'Пароль резервної копії не відкриває ключ цієї синхронізації: інший пристрій змінив його';

  @override
  String get syncTooNew =>
      'Синхронізовано з новішої версії: оновіть, щоб продовжити';

  @override
  String syncRefused(String reason) {
    return 'LK Cloud відхилив синхронізацію ($reason)';
  }

  @override
  String get rotateSyncKey => 'Замінити ключ синхронізації';
}
