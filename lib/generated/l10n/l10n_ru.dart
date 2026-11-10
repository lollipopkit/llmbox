// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get auto => 'Авто';

  @override
  String get autoCheckUpdate => 'Автоматически проверять обновления';

  @override
  String get backupTip =>
      'Пожалуйста, убедитесь, что ваш файл резервной копии является приватным и безопасным!';

  @override
  String get chat => 'Чат';

  @override
  String get clickToCheck => 'Нажмите для проверки';

  @override
  String get codeBlock => 'Блок кода';

  @override
  String get copied => 'Скопировано';

  @override
  String get current => 'Текущий';

  @override
  String delFmt(Object id, Object type) {
    return 'Удалить $type ($id)?';
  }

  @override
  String get deleteConfirm => 'Подтвердить перед удалением';

  @override
  String emptyFields(Object fields) {
    return '$fields пусты';
  }

  @override
  String get emptyTrashTip =>
      '==0, удалить при следующем запуске. <0 не удалять автоматически.';

  @override
  String get genChatTitle => 'Сгенерировать заголовок чата';

  @override
  String get image => 'Изображение';

  @override
  String invalidLinkFmt(Object uri) {
    return 'Неизвестная ссылка: $uri';
  }

  @override
  String get languageName => 'Русский';

  @override
  String get license => 'Лицензия';

  @override
  String get licenseMenuItem => 'Лицензии с открытым исходным кодом';

  @override
  String get manual => 'Ручной';

  @override
  String get more => 'Больше';

  @override
  String get myOtherApps => 'Мои другие приложения';

  @override
  String get newChat => 'Новый чат';

  @override
  String get passwd => 'Пароль';

  @override
  String get privacy => 'Конфиденциальность';

  @override
  String get privacyTip => 'Это приложение не собирает никакой информации.';

  @override
  String get rename => 'Переименовать';

  @override
  String get share => 'Поделиться';

  @override
  String get shareFrom => 'Поделился';

  @override
  String get softWrap => 'Мягкий перенос';

  @override
  String sureRestoreFmt(Object time) {
    return 'Вы уверены, что хотите восстановить резервную копию ($time)?';
  }

  @override
  String syncConflict(Object a, Object b) {
    return 'Конфликт: невозможно активировать $a и $b одновременно';
  }

  @override
  String get text => 'Текст';

  @override
  String get themeColorSeed => 'Семя цвета темы';

  @override
  String get themeMode => 'Режим темы';

  @override
  String get untitled => 'Без названия';

  @override
  String get usage => 'Использование';

  @override
  String get user => 'Пользователь';

  @override
  String get trash => 'Корзина';

  @override
  String get startChatTip => 'Выберите модель ниже и напишите что-нибудь.';

  @override
  String get noProviderKey =>
      'Ни у одного провайдера пока нет ключа. Добавьте ключ, чтобы начать чат.';

  @override
  String get providers => 'Провайдеры';

  @override
  String providersCountFmt(int n) {
    return 'Провайдеров: $n';
  }

  @override
  String get today => 'Сегодня';

  @override
  String get earlier => 'Ранее';

  @override
  String get now => 'сейчас';

  @override
  String minutesFmt(int n) {
    return '$n мин';
  }

  @override
  String hoursFmt(int n) {
    return '$n ч';
  }

  @override
  String messagesCountFmt(int n) {
    return 'Сообщений: $n';
  }

  @override
  String get version => 'Версия';

  @override
  String get toolsAndMcp => 'Инструменты и MCP';

  @override
  String get backToChats => 'Назад к чатам';

  @override
  String get genChatTitleTip => 'Называет чат после первого ответа';

  @override
  String get scrollOnNewMsg => 'Прокручивать вниз при новом сообщении';

  @override
  String get scrollAfterSwitch => 'Прокручивать вниз после смены чата';

  @override
  String chatsCountFmt(int n) {
    return 'Чатов: $n';
  }

  @override
  String get emptyTrashAfter => 'Очищать корзину через';

  @override
  String get trashTip => 'Удалённые чаты сначала попадают сюда';

  @override
  String daysFmt(int n) {
    return 'Дней: $n';
  }

  @override
  String get sync => 'Синхронизация';

  @override
  String get syncNow => 'Синхронизировать сейчас';

  @override
  String get syncing => 'Синхронизация…';

  @override
  String get neverSynced => 'Ещё не синхронизировано';

  @override
  String lastSyncFmt(String time) {
    return 'Последняя синхронизация: $time';
  }

  @override
  String get syncOffTip =>
      'Включите LK Cloud, iCloud или WebDAV ниже для автоматической синхронизации.';

  @override
  String get backupPassword => 'Пароль резервной копии';

  @override
  String get backupEncrypted => 'Резервные копии шифруются им';

  @override
  String get backupNotEncrypted =>
      'Не задан: резервные копии в файл не шифруются, а для синхронизации он нужен';

  @override
  String get backupEncryptedTip => 'Эта резервная копия зашифрована';

  @override
  String get backupPasswordRequired =>
      'Сначала задайте пароль: синхронизируемые копии всегда шифруются';

  @override
  String get passwordWrong => 'Неверный пароль или копия повреждена';

  @override
  String get backupTooNew =>
      'Эта копия из более новой версии приложения. Обновите приложение, чтобы восстановить её.';

  @override
  String get syncAppSettings => 'Синхронизировать настройки';

  @override
  String get syncAppSettingsTip =>
      'Размер окна и заголовок остаются свои на каждом устройстве';

  @override
  String get webdavManualTip => 'Датированная копия рядом с синхронизируемой';

  @override
  String get exportFile => 'Экспорт в файл';

  @override
  String get importFile => 'Восстановить из файла';

  @override
  String get copyBackup => 'Скопировать в буфер обмена';

  @override
  String get pasteBackup => 'Восстановить из буфера обмена';

  @override
  String get pullNewChat => 'Потяните вниз для нового чата';

  @override
  String get releaseNewChat => 'Отпустите для нового чата';

  @override
  String get pullOlderChat =>
      'Потяните вверх и удерживайте для предыдущего чата';

  @override
  String holdOlderChatFmt(String title) {
    return 'Удерживайте: $title';
  }

  @override
  String get shellTool => 'Оболочка';

  @override
  String get shellToolTip =>
      'Выполняет команды на этом устройстве, каждую после вашего одобрения';

  @override
  String get linuxEnv => 'Среда Linux';

  @override
  String get linuxEnvTip =>
      'Здесь работает оболочка на этом телефоне. Она не видит собственные файлы телефона.';

  @override
  String linuxInstallTip(String distro, String version, int size) {
    return 'Загрузить $distro $version, $size МБ?';
  }

  @override
  String linuxRemoveTip(String name) {
    return 'Удалить $name и всё, что в нём установлено?';
  }

  @override
  String get linuxInUse => 'В ней выполняется команда';

  @override
  String get linuxNone => 'Не установлено';

  @override
  String get syncChats => 'Синхронизировать чаты';

  @override
  String get syncAi => 'Синхронизировать модели, инструменты и память';

  @override
  String get syncSecrets => 'Синхронизировать API-ключи и секреты MCP';

  @override
  String get syncPasswordMismatch =>
      'Пароль резервной копии не открывает ключ этой синхронизации: другое устройство изменило его';

  @override
  String get syncTooNew =>
      'Синхронизировано из более новой версии: обновите, чтобы продолжить';

  @override
  String syncRefused(String reason) {
    return 'LK Cloud отклонил синхронизацию ($reason)';
  }

  @override
  String get rotateSyncKey => 'Заменить ключ синхронизации';
}
