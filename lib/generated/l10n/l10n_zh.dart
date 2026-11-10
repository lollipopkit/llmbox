// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get auto => '自动';

  @override
  String get autoCheckUpdate => '自动检查更新';

  @override
  String get backupTip => '请保证备份文件私密且安全！';

  @override
  String get chat => '聊天';

  @override
  String get clickToCheck => '点击检查';

  @override
  String get codeBlock => '代码区块';

  @override
  String get copied => '已复制';

  @override
  String get current => '当前';

  @override
  String delFmt(Object id, Object type) {
    return '删除 $type（$id）？';
  }

  @override
  String get deleteConfirm => '删除前确认';

  @override
  String emptyFields(Object fields) {
    return '$fields 为空';
  }

  @override
  String get emptyTrashTip => '==0，下次启动时删除。<0 不自动删除。';

  @override
  String get genChatTitle => '生成聊天标题';

  @override
  String get image => '图片';

  @override
  String invalidLinkFmt(Object uri) {
    return '未知链接：$uri';
  }

  @override
  String get languageName => '简体中文';

  @override
  String get license => '许可证';

  @override
  String get licenseMenuItem => '开放源代码许可';

  @override
  String get manual => '手动';

  @override
  String get more => '更多';

  @override
  String get myOtherApps => '我的其它 App';

  @override
  String get newChat => '新建聊天';

  @override
  String get passwd => '密码';

  @override
  String get privacy => '隐私';

  @override
  String get privacyTip => '此 app 不搜集任何信息。';

  @override
  String get rename => '重命名';

  @override
  String get share => '分享';

  @override
  String get shareFrom => '分享自';

  @override
  String get softWrap => '自动换行';

  @override
  String sureRestoreFmt(Object time) {
    return '确定恢复备份（$time）？';
  }

  @override
  String syncConflict(Object a, Object b) {
    return '冲突：不能同时开启 $a 和 $b';
  }

  @override
  String get text => '文字';

  @override
  String get themeColorSeed => '主题颜色种子';

  @override
  String get themeMode => '主题模式';

  @override
  String get untitled => '未命名';

  @override
  String get usage => '用法';

  @override
  String get user => '用户';

  @override
  String get trash => '回收站';

  @override
  String get startChatTip => '在下方选择模型，然后开始对话。';

  @override
  String get noProviderKey => '还没有任何服务商配置了 key，添加一个即可开始对话。';

  @override
  String get providers => '服务商';

  @override
  String providersCountFmt(int n) {
    return '$n 个服务商';
  }

  @override
  String get today => '今天';

  @override
  String get earlier => '更早';

  @override
  String get now => '刚刚';

  @override
  String minutesFmt(int n) {
    return '$n 分钟';
  }

  @override
  String hoursFmt(int n) {
    return '$n 小时';
  }

  @override
  String messagesCountFmt(int n) {
    return '$n 条消息';
  }

  @override
  String get version => '版本';

  @override
  String get toolsAndMcp => '工具与 MCP';

  @override
  String get backToChats => '返回对话';

  @override
  String get genChatTitleTip => '在首次回复后为对话命名';

  @override
  String get scrollOnNewMsg => '新消息时滚动到底部';

  @override
  String get scrollAfterSwitch => '切换对话后滚动到底部';

  @override
  String chatsCountFmt(int n) {
    return '$n 个对话';
  }

  @override
  String get emptyTrashAfter => '清空回收站间隔';

  @override
  String get trashTip => '删除的对话会先放在这里';

  @override
  String daysFmt(int n) {
    return '$n 天';
  }

  @override
  String get sync => '同步';

  @override
  String get syncNow => '立即同步';

  @override
  String get syncing => '同步中…';

  @override
  String get neverSynced => '尚未同步';

  @override
  String lastSyncFmt(String time) {
    return '上次同步：$time';
  }

  @override
  String get syncOffTip => '在下方开启 LK Cloud、iCloud 或 WebDAV 以自动同步。';

  @override
  String get backupPassword => '备份密码';

  @override
  String get backupEncrypted => '备份将用它加密';

  @override
  String get backupNotEncrypted => '未设置：文件备份为明文，且同步需要密码';

  @override
  String get backupEncryptedTip => '此备份已加密';

  @override
  String get backupPasswordRequired => '请先设置备份密码：同步的备份始终加密';

  @override
  String get passwordWrong => '密码错误，或备份已损坏';

  @override
  String get backupTooNew => '此备份来自更新版本的应用，请更新后再恢复。';

  @override
  String get syncAppSettings => '同步应用设置';

  @override
  String get syncAppSettingsTip => '窗口大小和标题栏始终按设备保存';

  @override
  String get webdavManualTip => '在同步文件旁保存带日期的副本';

  @override
  String get exportFile => '导出到文件';

  @override
  String get importFile => '从文件恢复';

  @override
  String get copyBackup => '复制到剪贴板';

  @override
  String get pasteBackup => '从剪贴板恢复';

  @override
  String get pullNewChat => '下拉新建对话';

  @override
  String get releaseNewChat => '松开新建对话';

  @override
  String get pullOlderChat => '上拉并按住,切换到上一个对话';

  @override
  String holdOlderChatFmt(String title) {
    return '继续按住:$title';
  }

  @override
  String get shellTool => 'Shell';

  @override
  String get shellToolTip => '在本机运行命令，每条命令都需要你批准';

  @override
  String get linuxEnv => 'Linux 环境';

  @override
  String get linuxEnvTip => '手机上 Shell 运行的地方，无法访问手机自身的文件。';

  @override
  String linuxInstallTip(String distro, String version, int size) {
    return '下载 $distro $version，$size MB？';
  }

  @override
  String linuxRemoveTip(String name) {
    return '删除 $name 及其中安装的所有内容？';
  }

  @override
  String get linuxInUse => '有命令正在其中运行';

  @override
  String get linuxNone => '未安装';

  @override
  String get syncChats => '同步聊天';

  @override
  String get syncAi => '同步模型、工具和记忆';

  @override
  String get syncSecrets => '同步 API 密钥和 MCP 凭据';

  @override
  String get syncPasswordMismatch => '备份密码打不开此同步的密钥：另一台设备修改了密码';

  @override
  String get syncTooNew => '同步数据来自更新的版本：请更新以继续同步';

  @override
  String syncRefused(String reason) {
    return 'LK Cloud 拒绝了同步（$reason）';
  }

  @override
  String get rotateSyncKey => '更换同步密钥';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get auto => '自動';

  @override
  String get autoCheckUpdate => '自動檢查更新';

  @override
  String get backupTip => '請確保備份檔案私密且安全！';

  @override
  String get chat => '聊天';

  @override
  String get clickToCheck => '點擊檢查';

  @override
  String get codeBlock => '程式碼區塊';

  @override
  String get copied => '已複製';

  @override
  String get current => '當前';

  @override
  String delFmt(Object id, Object type) {
    return '刪除 $type（$id）？';
  }

  @override
  String get deleteConfirm => '刪除前確認';

  @override
  String emptyFields(Object fields) {
    return '$fields 為空';
  }

  @override
  String get emptyTrashTip => '==0，下次啟動時刪除。<0 不自動刪除。';

  @override
  String get genChatTitle => '生成聊天標題';

  @override
  String get image => '圖片';

  @override
  String invalidLinkFmt(Object uri) {
    return '未知連結：$uri';
  }

  @override
  String get languageName => '繁體中文';

  @override
  String get license => '許可證';

  @override
  String get licenseMenuItem => '開放源碼許可';

  @override
  String get manual => '手動';

  @override
  String get more => '更多';

  @override
  String get myOtherApps => '我的其它 App';

  @override
  String get newChat => '新建聊天';

  @override
  String get passwd => '密碼';

  @override
  String get privacy => '隱私';

  @override
  String get privacyTip => '此 app 不蒐集任何資訊。';

  @override
  String get rename => '重新命名';

  @override
  String get share => '分享';

  @override
  String get shareFrom => '分享自';

  @override
  String get softWrap => '自動換行';

  @override
  String sureRestoreFmt(Object time) {
    return '確定恢復備份（$time）？';
  }

  @override
  String syncConflict(Object a, Object b) {
    return '衝突：不能同時開啟 $a 和 $b';
  }

  @override
  String get text => '文字';

  @override
  String get themeColorSeed => '主題顏色種子';

  @override
  String get themeMode => '主題模式';

  @override
  String get untitled => '未命名';

  @override
  String get usage => '用法';

  @override
  String get user => '使用者';

  @override
  String get trash => '垃圾桶';

  @override
  String get startChatTip => '在下方選擇模型，然後開始對話。';

  @override
  String get noProviderKey => '還沒有服務商設定了金鑰。新增一個即可開始聊天。';

  @override
  String get providers => '服務商';

  @override
  String providersCountFmt(int n) {
    return '$n 個服務商';
  }

  @override
  String get today => '今天';

  @override
  String get earlier => '更早';

  @override
  String get now => '剛剛';

  @override
  String minutesFmt(int n) {
    return '$n 分鐘';
  }

  @override
  String hoursFmt(int n) {
    return '$n 小時';
  }

  @override
  String messagesCountFmt(int n) {
    return '$n 則訊息';
  }

  @override
  String get version => '版本';

  @override
  String get toolsAndMcp => '工具與 MCP';

  @override
  String get backToChats => '返回對話';

  @override
  String get genChatTitleTip => '在首次回覆後為對話命名';

  @override
  String get scrollOnNewMsg => '新訊息時捲動到底部';

  @override
  String get scrollAfterSwitch => '切換對話後捲動到底部';

  @override
  String chatsCountFmt(int n) {
    return '$n 個對話';
  }

  @override
  String get emptyTrashAfter => '清空垃圾桶間隔';

  @override
  String get trashTip => '刪除的對話會先放在這裡';

  @override
  String daysFmt(int n) {
    return '$n 天';
  }

  @override
  String get sync => '同步';

  @override
  String get syncNow => '立即同步';

  @override
  String get syncing => '同步中…';

  @override
  String get neverSynced => '尚未同步';

  @override
  String lastSyncFmt(String time) {
    return '上次同步：$time';
  }

  @override
  String get syncOffTip => '在下方開啟 LK Cloud、iCloud 或 WebDAV 以自動同步。';

  @override
  String get backupPassword => '備份密碼';

  @override
  String get backupEncrypted => '備份將用它加密';

  @override
  String get backupNotEncrypted => '未設定：檔案備份為明文，且同步需要密碼';

  @override
  String get backupEncryptedTip => '此備份已加密';

  @override
  String get backupPasswordRequired => '請先設定備份密碼：同步的備份一律加密';

  @override
  String get passwordWrong => '密碼錯誤，或備份已損壞';

  @override
  String get backupTooNew => '此備份來自較新版本的應用程式，請更新後再還原。';

  @override
  String get syncAppSettings => '同步應用程式設定';

  @override
  String get syncAppSettingsTip => '視窗大小和標題列始終依裝置保存';

  @override
  String get webdavManualTip => '在同步檔案旁保存帶日期的副本';

  @override
  String get exportFile => '匯出到檔案';

  @override
  String get importFile => '從檔案還原';

  @override
  String get copyBackup => '複製到剪貼簿';

  @override
  String get pasteBackup => '從剪貼簿還原';

  @override
  String get pullNewChat => '下拉新建對話';

  @override
  String get releaseNewChat => '放開新建對話';

  @override
  String get pullOlderChat => '上拉並按住,切換到上一個對話';

  @override
  String holdOlderChatFmt(String title) {
    return '繼續按住:$title';
  }

  @override
  String get shellTool => 'Shell';

  @override
  String get shellToolTip => '在本機執行指令，每條指令都需要你核准';

  @override
  String get linuxEnv => 'Linux 環境';

  @override
  String get linuxEnvTip => '手機上 Shell 執行的地方，無法存取手機本身的檔案。';

  @override
  String linuxInstallTip(String distro, String version, int size) {
    return '下載 $distro $version，$size MB？';
  }

  @override
  String linuxRemoveTip(String name) {
    return '刪除 $name 及其中安裝的所有內容？';
  }

  @override
  String get linuxInUse => '有指令正在其中執行';

  @override
  String get linuxNone => '未安裝';

  @override
  String get syncChats => '同步聊天';

  @override
  String get syncAi => '同步模型、工具和記憶';

  @override
  String get syncSecrets => '同步 API 金鑰和 MCP 憑證';

  @override
  String get syncPasswordMismatch => '備份密碼打不開此同步的金鑰：另一台裝置修改了密碼';

  @override
  String get syncTooNew => '同步資料來自更新的版本：請更新以繼續同步';

  @override
  String syncRefused(String reason) {
    return 'LK Cloud 拒絕了同步（$reason）';
  }

  @override
  String get rotateSyncKey => '更換同步金鑰';
}
