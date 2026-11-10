import 'dart:async';
import 'dart:io';

import 'package:fl_lib/fl_lib.dart';
import 'package:material_ui/material_ui.dart';
import 'package:llmbox/core/lkc.dart';
import 'package:llmbox/core/util/log_sync.dart';
import 'package:llmbox/core/util/sync.dart';
import 'package:llmbox/data/model/backup.dart';
import 'package:llmbox/data/res/l10n.dart';
import 'package:webdav_client_plus/webdav_client_plus.dart';
import 'package:fl_pi_llm_ui/fl_pi_llm_ui.dart';

/// Sync (iCloud, WebDAV), the backup password, and backups by hand.
///
/// What leaves the device on its own — the synced backup, a WebDAV snapshot —
/// is always encrypted, so turning sync on asks for a password first. A
/// backup kept by hand (a file, the clipboard) is encrypted when a password
/// is set.
final class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

final class _BackupPageState extends State<BackupPage> {
  final _hasPassword = false.vn;
  final _webdavBusy = false.vn;

  @override
  void initState() {
    super.initState();
    _readPassword();
  }

  @override
  void dispose() {
    _hasPassword.dispose();
    _webdavBusy.dispose();
    super.dispose();
  }

  Future<void> _readPassword() async => _hasPassword.value = await BakSync.password != null;

  @override
  Widget build(BuildContext context) {
    return SectionList(
      children: [
        SettingsGroup(
          title: l10n.sync,
          rows: [
            _status(),
            _password(),
            _syncSettings(),
            _group(LogSyncs.chats, Icons.chat_bubble_outline, l10n.syncChats),
            _group(LogSyncs.ai, Icons.auto_awesome_outlined, l10n.syncAi),
            _group(LogSyncs.secrets, Icons.key_outlined, l10n.syncSecrets),
          ],
        ),
        SettingsGroup(title: 'LK Cloud', rows: [_lkcAuto(), _rotateKey()]),
        if (isMacOS || isIOS) SettingsGroup(title: 'iCloud', rows: [_icloudAuto()]),
        SettingsGroup(
          title: 'WebDAV',
          rows: [
            SettingsRow(
              icon: Icons.settings_outlined,
              title: libL10n.setting,
              subtitle: PrefProps.webdavUrl.get(),
              trailing: const RowChevron(),
              onTap: _webdavSettings,
            ),
            _webdavAuto(),
            _webdavManual(),
          ],
        ),
        SettingsGroup(
          title: libL10n.file,
          rows: [
            SettingsRow(icon: Icons.ios_share, title: l10n.exportFile, trailing: const RowChevron(), onTap: _exportFile),
            SettingsRow(icon: Icons.file_open_outlined, title: l10n.importFile, trailing: const RowChevron(), onTap: _importFile),
            SettingsRow(icon: Icons.content_copy, title: l10n.copyBackup, trailing: const RowChevron(), onTap: _copy),
            SettingsRow(icon: Icons.content_paste, title: l10n.pasteBackup, trailing: const RowChevron(), onTap: _paste),
          ],
          footer: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Text(l10n.backupTip, style: UIs.text12Grey),
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------------------------------
  // Sync

  /// Whether anything syncs on its own.
  static bool get _anySync => BakSync.enabled || LogSyncs.lkcEnabled.get();

  /// What the operation-log syncs last ran into, as the person reads it.
  static String? _logIssue() {
    if (SyncKeyring.passwordMismatch.value.isNotEmpty) return l10n.syncPasswordMismatch;
    if (LogSyncs.lkc.tooNew.value || LogSyncs.files.tooNew.value) return l10n.syncTooNew;
    for (final e in [LogSyncs.lkc.lastFailure.value, LogSyncs.files.lastFailure.value]) {
      switch (e) {
        case null || SyncPasswordMissing() || SyncPasswordMismatch():
          continue;
        case SyncRefused(:final reason):
          return l10n.syncRefused(reason);
        default:
          return '$e';
      }
    }
    return null;
  }

  Widget _status() {
    final sync = BakSync.instance;
    return ListenableBuilder(
      listenable: Listenable.merge([
        sync.syncing,
        sync.lastError,
        sync.lastSyncAt,
        LogSyncs.lkcEnabled.listenable(),
        SyncKeyring.passwordMismatch,
        LogSyncs.lkc.tooNew,
        LogSyncs.lkc.lastFailure,
        LogSyncs.files.tooNew,
        LogSyncs.files.lastFailure,
        LogSyncs.lkc.running,
        LogSyncs.lkc.lastSyncAt,
        LogSyncs.files.running,
        LogSyncs.files.lastSyncAt,
      ]),
      builder: (context, _) {
        final err = sync.lastError.value ?? _logIssue();
        final syncing = sync.syncing.value || LogSyncs.lkc.running.value || LogSyncs.files.running.value;
        final at = [sync.lastSyncAt.value, LogSyncs.lkc.lastSyncAt.value, LogSyncs.files.lastSyncAt.value]
            .nonNulls
            .fold<DateTime?>(null, (a, b) => a == null || b.isAfter(a) ? b : a);
        final String sub;
        if (!_anySync) {
          sub = l10n.syncOffTip;
        } else if (syncing) {
          sub = l10n.syncing;
        } else {
          sub = at == null ? l10n.neverSynced : l10n.lastSyncFmt(at.simple());
        }
        return SettingsRow(
          icon: Icons.sync,
          title: l10n.syncNow,
          subtitle: sub,
          error: err,
          trailing: syncing
              ? const SizedLoading(20, padding: 6, builder: SizedLoading.circularBuilder)
              : const RowChevron(),
          onTap: !_anySync || syncing ? null : _syncNow,
        );
      },
    );
  }

  Future<void> _syncNow() async {
    await Future.wait([
      if (BakSync.enabled) BakSync.instance.syncNow(),
      LogSyncs.lkc.sync(),
      LogSyncs.files.sync(),
    ]);
  }

  /// One group of records, synced or not on this device.
  Widget _group(SyncGroup group, IconData icon, String title) {
    return SettingsRow(
      icon: icon,
      title: title,
      trailing: StoreSwitch(prop: group.pref),
    );
  }

  // --------------------------------------------------------------------------
  // LK Cloud

  Widget _lkcAuto() {
    return SettingsRow(
      icon: Icons.cloud_sync_outlined,
      title: l10n.auto,
      trailing: StoreSwitch(
        prop: LogSyncs.lkcEnabled,
        validator: (on) async {
          if (!on) return true;
          if (!Lkc.client.signedIn || Lkc.client.user.value == null) {
            Toast.show(libL10n.lkcNotSignedIn);
            return false;
          }
          return _ensurePassword();
        },
      ),
    );
  }

  Widget _rotateKey() {
    return LogSyncs.lkcEnabled.listenable().listenVal((on) {
      return SettingsRow(
        icon: Icons.key_off_outlined,
        title: l10n.rotateSyncKey,
        trailing: const RowChevron(),
        onTap: on ? _onRotateKey : null,
      );
    });
  }

  Future<void> _onRotateKey() async {
    final ok = await context.showRoundDialog<bool>(
      title: l10n.rotateSyncKey,
      child: Text(libL10n.askContinue(l10n.rotateSyncKey)),
      actions: Btnx.cancelRedOk,
    );
    if (ok != true) return;
    try {
      await LogSyncs.lkc.rotateKey();
      Toast.success(libL10n.success);
    } catch (e, s) {
      Loggers.app.warning('Replace sync key', e, s);
      Toast.show('$e');
    }
  }

  Widget _password() {
    return _hasPassword.listenVal((has) {
      return SettingsRow(
        icon: has ? Icons.lock_outline : Icons.lock_open,
        iconColor: has ? context.theme.colorScheme.primary : null,
        title: l10n.backupPassword,
        subtitle: has ? l10n.backupEncrypted : l10n.backupNotEncrypted,
        trailing: has
            ? Btn.text(text: libL10n.delete, onTap: _deletePassword)
            : const RowChevron(),
        onTap: _setPassword,
      );
    });
  }

  Widget _syncSettings() {
    return SettingsRow(
      icon: Icons.tune,
      title: l10n.syncAppSettings,
      subtitle: l10n.syncAppSettingsTip,
      trailing: StoreSwitch(
        prop: PrefProps.syncAppSettings,
        callback: (_) {
          // What is compared changed with it: sync in full next time.
          BakSync.forgetCheckpoint();
          BakSync.instance.syncSoon();
        },
      ),
    );
  }

  /// Asks for a password until one is set or the user gives up.
  Future<bool> _ensurePassword() async {
    if (await BakSync.password != null) return true;
    if (!mounted) return false;
    Toast.show(l10n.backupPasswordRequired);
    return _setPassword();
  }

  Future<bool> _setPassword() async {
    final ctrl = TextEditingController(text: await BakSync.password);
    if (!mounted) return false;
    final v = await context.showRoundDialog<String>(
      title: l10n.backupPassword,
      child: Input(controller: ctrl, obscureText: true, autoFocus: true, onSubmitted: (v) => context.pop(v)),
      actions: [Btn.ok(onTap: () => context.pop(ctrl.text))],
    );
    ctrl.dispose();
    if (v == null) return false;
    if (v.isEmpty) {
      Toast.show(libL10n.empty);
      return false;
    }
    // The sync keys are sealed with it: sealed again with the new one.
    await SyncKeyring.passwordChanged(await BakSync.password);
    await SecureStoreProps.bakPwd.write(v);
    BakSync.forgetCheckpoint();
    await _readPassword();
    await SyncKeyring.recheck();
    unawaited(LogSyncs.lkc.sync());
    unawaited(LogSyncs.files.sync());
    Toast.success(libL10n.success);
    return true;
  }

  Future<void> _deletePassword() async {
    if (_anySync) {
      Toast.show(l10n.backupPasswordRequired);
      return;
    }
    final ok = await context.showRoundDialog<bool>(
      title: libL10n.delete,
      child: Text(libL10n.askContinue('${libL10n.delete} ${l10n.backupPassword}')),
      actions: Btnx.cancelRedOk,
    );
    if (ok != true) return;
    await SecureStoreProps.bakPwd.write(null);
    BakSync.forgetCheckpoint();
    await _readPassword();
  }

  // --------------------------------------------------------------------------
  // iCloud

  Widget _icloudAuto() {
    return SettingsRow(
      icon: Icons.cloud_outlined,
      title: l10n.auto,
      trailing: StoreSwitch(
        prop: PrefProps.icloudSync,
        validator: (on) async {
          if (!on) return true;
          if (PrefProps.webdavSync.get()) {
            Toast.show(l10n.syncConflict('iCloud', 'WebDAV'));
            return false;
          }
          return _ensurePassword();
        },
        callback: (on) async {
          if (on) await BakSync.instance.syncNow(rs: icloud);
        },
      ),
    );
  }

  // --------------------------------------------------------------------------
  // WebDAV

  Widget _webdavAuto() {
    return SettingsRow(
      icon: Icons.sync,
      title: l10n.auto,
      trailing: StoreSwitch(
        prop: PrefProps.webdavSync,
        validator: (on) async {
          if (!on) return true;
          if (PrefProps.icloudSync.get()) {
            Toast.show(l10n.syncConflict('iCloud', 'WebDAV'));
            return false;
          }
          if (PrefProps.webdavUrl.get() == null ||
              PrefProps.webdavUser.get() == null ||
              await SecureStoreProps.webdavPwd.read() == null) {
            Toast.show(l10n.emptyFields(libL10n.setting));
            return false;
          }
          return _ensurePassword();
        },
        callback: (on) async {
          if (on) await BakSync.instance.syncNow(rs: Webdav.shared);
        },
      ),
    );
  }

  Widget _webdavManual() {
    return SettingsRow(
      icon: Icons.swap_vert,
      title: l10n.manual,
      subtitle: l10n.webdavManualTip,
      trailing: _webdavBusy.listenVal((busy) {
        if (busy) return const SizedLoading(20, padding: 6, builder: SizedLoading.circularBuilder);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Btn.text(onTap: _webdavRestore, text: libL10n.restore),
            Btn.text(onTap: _webdavSnapshot, text: libL10n.backup),
          ],
        );
      }),
    );
  }

  Future<void> _webdavBusyDo(Future<void> Function() fn, String what) async {
    _webdavBusy.value = true;
    try {
      await fn();
    } catch (e, s) {
      if (mounted) context.showErrDialog(e, s, what);
    } finally {
      _webdavBusy.value = false;
    }
  }

  /// Any backup on the server, the synced one or a snapshot.
  Future<void> _webdavRestore() => _webdavBusyDo(() async {
    final files = await Webdav.shared.list();
    if (files.isEmpty) {
      Toast.show(libL10n.empty);
      return;
    }
    if (!mounted) return;
    final name = await context.showPickSingleDialog(title: libL10n.select, items: files..sort((a, b) => b.compareTo(a)));
    if (name == null) return;
    await Webdav.shared.download(relativePath: name);
    final text = await File(Paths.doc.joinPath(name)).readAsString();
    if (mounted) await restoreFromText(context, text);
  }, 'WebDAV restore');

  /// A dated copy beside the synced one, for going back to later.
  Future<void> _webdavSnapshot() => _webdavBusyDo(() async {
    if (!await _ensurePassword()) return;
    final t = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    final name = '${t.year}-${two(t.month)}-${two(t.day)}-${two(t.hour)}${two(t.minute)}${two(t.second)}-$bakFileName';
    await Backup.toFile(password: await BakSync.password, name: name);
    await Webdav.shared.upload(relativePath: name);
    Toast.success(libL10n.success);
  }, 'WebDAV backup');

  Future<void> _webdavSettings() async {
    final url = TextEditingController(text: PrefProps.webdavUrl.get());
    final user = TextEditingController(text: PrefProps.webdavUser.get());
    final pwd = TextEditingController(text: await SecureStoreProps.webdavPwd.read());
    if (!mounted) return;
    final ok = await context.showRoundDialog<bool>(
      title: 'WebDAV',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Input(label: 'URL', hint: 'https://example.com/webdav/', controller: url, autoFocus: true),
          Input(label: l10n.user, controller: user),
          Input(label: l10n.passwd, controller: pwd, obscureText: true),
        ],
      ),
      actions: Btnx.oks,
    );
    if (ok == true && mounted) {
      final (_, err) = await context.showLoadingDialog(
        fn: () async {
          await Webdav.test(url.text, user.text, pwd.text);
          Webdav.shared.client = WebdavClient.basicAuth(url: url.text, user: user.text, pwd: pwd.text);
          PrefProps.webdavUrl.set(url.text);
          PrefProps.webdavUser.set(user.text);
          await SecureStoreProps.webdavPwd.write(pwd.text);
          // Another server, or another account: nothing is known about it.
          BakSync.forgetCheckpoint();
        },
      );
      if (err == null) {
        Toast.success(libL10n.success);
        if (mounted) setState(() {});
      }
    }
    url.dispose();
    user.dispose();
    pwd.dispose();
  }

  // --------------------------------------------------------------------------
  // By hand

  Future<void> _exportFile() async {
    final (path, err) = await context.showLoadingDialog(fn: () async => Backup.toFile(password: await BakSync.password));
    if (err != null || path == null) return;
    await Pfs.sharePaths(paths: [path]);
  }

  Future<void> _importFile() async {
    final text = await Pfs.pickFileString();
    if (text == null || !mounted) return;
    await restoreFromText(context, text);
  }

  Future<void> _copy() async {
    final (text, err) = await context.showLoadingDialog(
      fn: () async => (await Backup.fromStores()).encode(password: await BakSync.password),
    );
    if (err != null || text == null) return;
    Pfs.copy(text);
    Toast.success(l10n.copied);
  }

  Future<void> _paste() async {
    final text = (await Pfs.paste())?.trim();
    if (text == null || text.isEmpty) {
      Toast.show(libL10n.empty);
      return;
    }
    if (mounted) await restoreFromText(context, text);
  }
}

/// Restores a backup's [text], after asking: opened with the saved password,
/// or one the user types, and merged in with the backup's side taken.
Future<void> restoreFromText(BuildContext context, String text) async {
  Backup? bak;
  String? pwd = await BakSync.password;
  while (bak == null) {
    if (!context.mounted) return;
    final encrypted = Backup.isEncrypted(text);
    if (encrypted && pwd == null) {
      final ctrl = TextEditingController();
      pwd = await context.showRoundDialog<String>(
        title: l10n.backupPassword,
        child: Input(controller: ctrl, obscureText: true, autoFocus: true, hint: l10n.backupEncryptedTip, onSubmitted: (v) => context.pop(v)),
        actions: [Btn.ok(onTap: () => context.pop(ctrl.text))],
      );
      ctrl.dispose();
      if (pwd == null || pwd.isEmpty) return;
    }
    if (!context.mounted) return;
    final p = pwd;
    final (parsed, err) = await context.showLoadingDialog(fn: () => Backup.parse(text, password: p), onErr: (_, _) {});
    if (parsed != null) {
      bak = parsed;
    } else if (err is BackupTooNew) {
      Toast.show(l10n.backupTooNew);
      return;
    } else if (encrypted) {
      // Most likely the password: ask again.
      Toast.show(l10n.passwordWrong);
      pwd = null;
    } else {
      return;
    }
  }
  if (!context.mounted) return;
  final ok = await context.showRoundDialog<bool>(
    title: libL10n.restore,
    child: Text(l10n.sureRestoreFmt(bak.dateStr)),
    actions: Btnx.cancelOk,
  );
  if (ok != true || !context.mounted) return;
  final b = bak;
  final (_, err) = await context.showLoadingDialog(fn: () => b.merge(force: true));
  if (err == null) Toast.success(libL10n.success);
}
