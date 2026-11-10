// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get auto => '自動';

  @override
  String get autoCheckUpdate => '自動更新チェック';

  @override
  String get backupTip => 'バックアップファイルのプライバシーと安全性を確保してください！';

  @override
  String get chat => 'チャット';

  @override
  String get clickToCheck => 'クリックでチェック';

  @override
  String get codeBlock => 'コードブロック';

  @override
  String get copied => 'コピーしました';

  @override
  String get current => '現在';

  @override
  String delFmt(Object id, Object type) {
    return '$type（$id）を削除しますか？';
  }

  @override
  String get deleteConfirm => '削除前に確認';

  @override
  String emptyFields(Object fields) {
    return '$fieldsが空です';
  }

  @override
  String get emptyTrashTip => '==0、次回起動時に削除。<0 自動削除しない。';

  @override
  String get genChatTitle => 'チャットタイトルを生成';

  @override
  String get image => '画像';

  @override
  String invalidLinkFmt(Object uri) {
    return '不明なリンク：$uri';
  }

  @override
  String get languageName => '日本語';

  @override
  String get license => 'ライセンス';

  @override
  String get licenseMenuItem => 'オープンソースライセンス';

  @override
  String get manual => '手動';

  @override
  String get more => 'もっと';

  @override
  String get myOtherApps => '他のアプリ';

  @override
  String get newChat => '新しいチャット';

  @override
  String get passwd => 'パスワード';

  @override
  String get privacy => 'プライバシー';

  @override
  String get privacyTip => 'このアプリは情報を収集しません。';

  @override
  String get rename => '名前変更';

  @override
  String get share => '共有';

  @override
  String get shareFrom => '共有元';

  @override
  String get softWrap => 'ソフトラップ';

  @override
  String sureRestoreFmt(Object time) {
    return 'バックアップ（$time）を復元してもよろしいですか？';
  }

  @override
  String syncConflict(Object a, Object b) {
    return '競合：$aと$bを同時に有効にすることはできません';
  }

  @override
  String get text => 'テキスト';

  @override
  String get themeColorSeed => 'テーマカラーシード';

  @override
  String get themeMode => 'テーマモード';

  @override
  String get untitled => '無題';

  @override
  String get usage => '使用法';

  @override
  String get user => 'ユーザー';

  @override
  String get trash => 'ゴミ箱';

  @override
  String get startChatTip => '下でモデルを選んで話しかけてください。';

  @override
  String get noProviderKey => 'キーが設定されたプロバイダーがまだありません。追加するとチャットを始められます。';

  @override
  String get providers => 'プロバイダー';

  @override
  String providersCountFmt(int n) {
    return '$n 個のプロバイダー';
  }

  @override
  String get today => '今日';

  @override
  String get earlier => 'それ以前';

  @override
  String get now => 'たった今';

  @override
  String minutesFmt(int n) {
    return '$n 分';
  }

  @override
  String hoursFmt(int n) {
    return '$n 時間';
  }

  @override
  String messagesCountFmt(int n) {
    return '$n 件のメッセージ';
  }

  @override
  String get version => 'バージョン';

  @override
  String get toolsAndMcp => 'ツールと MCP';

  @override
  String get backToChats => 'チャットに戻る';

  @override
  String get genChatTitleTip => '最初の返信の後にチャットに名前を付けます';

  @override
  String get scrollOnNewMsg => '新しいメッセージで一番下へスクロール';

  @override
  String get scrollAfterSwitch => 'チャット切り替え後に一番下へスクロール';

  @override
  String chatsCountFmt(int n) {
    return '$n 件のチャット';
  }

  @override
  String get emptyTrashAfter => 'ゴミ箱を空にするまで';

  @override
  String get trashTip => '削除したチャットはまずここに入ります';

  @override
  String daysFmt(int n) {
    return '$n 日';
  }

  @override
  String get sync => '同期';

  @override
  String get syncNow => '今すぐ同期';

  @override
  String get syncing => '同期中…';

  @override
  String get neverSynced => 'まだ同期していません';

  @override
  String lastSyncFmt(String time) {
    return '最終同期：$time';
  }

  @override
  String get syncOffTip => '下で LK Cloud、iCloud または WebDAV をオンにすると自動で同期します。';

  @override
  String get backupPassword => 'バックアップのパスワード';

  @override
  String get backupEncrypted => 'バックアップはこれで暗号化されます';

  @override
  String get backupNotEncrypted => '未設定：ファイルのバックアップは平文になり、同期には必要です';

  @override
  String get backupEncryptedTip => 'このバックアップは暗号化されています';

  @override
  String get backupPasswordRequired =>
      '先にバックアップのパスワードを設定してください。同期するバックアップは常に暗号化されます';

  @override
  String get passwordWrong => 'パスワードが違うか、バックアップが壊れています';

  @override
  String get backupTooNew => 'このバックアップは新しいバージョンのアプリで作成されました。復元するには更新してください。';

  @override
  String get syncAppSettings => 'アプリの設定を同期';

  @override
  String get syncAppSettingsTip => 'ウィンドウサイズとタイトルバーは端末ごとに保持されます';

  @override
  String get webdavManualTip => '同期ファイルの横に日付付きのコピー';

  @override
  String get exportFile => 'ファイルに書き出す';

  @override
  String get importFile => 'ファイルから復元';

  @override
  String get copyBackup => 'クリップボードにコピー';

  @override
  String get pasteBackup => 'クリップボードから復元';

  @override
  String get pullNewChat => '下に引いて新しいチャット';

  @override
  String get releaseNewChat => '離すと新しいチャット';

  @override
  String get pullOlderChat => '上に引いて長押しで前のチャット';

  @override
  String holdOlderChatFmt(String title) {
    return 'そのまま押し続ける: $title';
  }

  @override
  String get shellTool => 'シェル';

  @override
  String get shellToolTip => 'このデバイスでコマンドを実行します。各コマンドは承認後に実行されます';

  @override
  String get linuxEnv => 'Linux 環境';

  @override
  String get linuxEnvTip => 'この端末でシェルが動く場所です。端末自体のファイルにはアクセスできません。';

  @override
  String linuxInstallTip(String distro, String version, int size) {
    return '$distro $version（$size MB）をダウンロードしますか？';
  }

  @override
  String linuxRemoveTip(String name) {
    return '$name とその中にインストールしたものをすべて削除しますか？';
  }

  @override
  String get linuxInUse => 'コマンドが実行中です';

  @override
  String get linuxNone => '未インストール';

  @override
  String get syncChats => 'チャットを同期';

  @override
  String get syncAi => 'モデル、ツール、メモリを同期';

  @override
  String get syncSecrets => 'API キーと MCP シークレットを同期';

  @override
  String get syncPasswordMismatch =>
      'バックアップパスワードではこの同期のキーを開けません：別のデバイスで変更されました';

  @override
  String get syncTooNew => '新しいバージョンから同期されました：同期を続けるには更新してください';

  @override
  String syncRefused(String reason) {
    return 'LK Cloud が同期を拒否しました（$reason）';
  }

  @override
  String get rotateSyncKey => '同期キーを置き換える';
}
