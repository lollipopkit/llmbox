import 'dart:async';
import 'dart:io';

import 'package:fl_lib/fl_lib.dart';
import 'package:fl_pi_llm_ui/fl_pi_llm_ui.dart';
import 'package:llmbox/data/model/backup.dart';
import 'package:llmbox/data/res/l10n.dart';
import 'package:llmbox/data/store/all.dart';

final icloud = ICloud(containerId: 'iCloud.tech.lolli.gptbox');

/// The name of the synced backup. Versioned, so a build that cannot read
/// this format never finds the file, and so never overwrites it.
const bakFileName = 'llmbox_bak_v4.json';

/// Remote sync needs a backup password: what leaves the device is always
/// encrypted.
final class BackupPasswordMissing implements Exception {
  const BackupPasswordMissing();

  @override
  String toString() => 'A backup password is required to sync';
}

/// Keeps the backup on iCloud or WebDAV in step with this device.
///
/// fl_lib's [SyncIface] does the cycle: download, merge, upload, and a
/// checkpoint that skips the whole thing when neither side moved. This says
/// what a backup is, where it goes, and when to run.
final class BakSync extends SyncIface<Mergeable, dynamic> {
  BakSync._();

  static final instance = BakSync._();

  /// Device-local, like everything in [PrefStore]: never part of a backup.
  static const _checkpoint = PrefProp<String>('sync_checkpoint');
  static const _lastSyncAt = PrefProp<int>('last_sync_at');

  /// A sync is running.
  final syncing = false.vn;

  /// Why the last sync did not complete, if it did not.
  final lastError = nvn<String>();

  /// When a sync last completed on this device.
  final lastSyncAt = nvn<DateTime>();

  /// The remote holds a backup from a newer build: it is read from but never
  /// written over.
  var _remoteTooNew = false;

  /// What went wrong in this run, where fl_lib's cycle only logs it.
  Object? _issue;

  final _watches = <StreamSubscription<String>>[];

  @override
  void init() {
    Webdav.shared.prefix = 'llmbox/';
    final at = _lastSyncAt.get();
    if (at != null) lastSyncAt.value = DateTime.fromMillisecondsSinceEpoch(at);
    // After any edit worth syncing. A sync's own merge writes too; the
    // checkpoint makes the next round a single request.
    for (final w in _watches) {
      unawaited(w.cancel());
    }
    _watches
      ..clear()
      ..addAll([
        for (final s in [LlmStores.chat.watch(), LlmStores.llm.watch(), LlmStores.tool.watch(), LlmStores.memory.watch()]) s.listen((_) => syncSoon()),
        Stores.setting.watch().where((k) => !Stores.setting.isDeviceLocalKey(k)).listen((_) => syncSoon()),
      ]);
  }

  static bool get _appleIcloud => (isIOS || isMacOS) && PrefProps.icloudSync.get();

  /// Whether automatic sync is on anywhere.
  static bool get enabled => _appleIcloud || PrefProps.webdavSync.get();

  @override
  RemoteStorage? get remoteStorage {
    if (_appleIcloud) return icloud;
    if (PrefProps.webdavSync.get()) return Webdav.shared;
    return null;
  }

  static Future<String?> get password async {
    final p = await SecureStoreProps.bakPwd.read();
    return p == null || p.isEmpty ? null : p;
  }

  @override
  Future<void> saveToFile() async {
    final pwd = await password;
    if (pwd == null) throw const BackupPasswordMissing();
    await Backup.toFile(password: pwd, includeSettings: PrefProps.syncAppSettings.get());
  }

  @override
  Future<Mergeable> fromFile(String path) async {
    try {
      final bak = await Backup.parse(await File(path).readAsString(), password: await password);
      _remoteTooNew = false;
      final b = PrefProps.syncAppSettings.get() ? bak : bak.withoutSettings();
      return _Tracked(b, (e) => _issue = e);
    } on BackupTooNew catch (e) {
      _remoteTooNew = true;
      _issue = e;
      rethrow;
    } catch (e) {
      _issue = e;
      rethrow;
    }
  }

  @override
  Future<void> backup([RemoteStorage? rs]) async {
    if (_remoteTooNew) {
      Loggers.app.warning('Not uploading over a backup from a newer build');
      return;
    }
    await super.backup(rs);
  }

  @override
  Future<String?> get localVersionTag async {
    final settings = PrefProps.syncAppSettings.get();
    return '${await Backup.localStamp(includeSettings: settings)}/$settings';
  }

  @override
  (String, String, int)? get syncCheckpoint {
    final parts = _checkpoint.get()?.split('\u0000');
    if (parts == null || parts.length != 3) return null;
    final at = int.tryParse(parts[2]);
    return at == null ? null : (parts[0], parts[1], at);
  }

  @override
  void saveSyncCheckpoint(String remote, String local, int atMs) =>
      _checkpoint.set('$remote\u0000$local\u0000$atMs');

  /// Forgets where the last sync ended: the next one runs in full. After the
  /// password or the remote changes.
  static void forgetCheckpoint() => _checkpoint.remove();

  /// Soon, and once for a burst of edits.
  void syncSoon() {
    if (!enabled) return;
    unawaited(_runs.soon(() => _runOnce(() => sync(milliDelay: 1000))));
  }

  /// Now, with [rs] or the configured remote; for a button or a switch.
  Future<void> syncNow({RemoteStorage? rs}) => _runs.run(() => _runOnce(() => sync(throttleMilli: 0, rs: rs)));

  /// One run at a time: each owns [_issue] and the status while it runs.
  final _runs = SerialRuns();

  Future<void> _runOnce(Future<void> Function() body) async {
    if (await password == null) {
      lastError.value = l10n.backupPasswordRequired;
      return;
    }
    syncing.value = true;
    _issue = null;
    // Set again by reading the remote's backup: a remote changed or emptied
    // since takes this device's.
    _remoteTooNew = false;
    try {
      await body();
      if (_issue case final e?) {
        lastError.value = _describe(e);
      } else {
        lastError.value = null;
        final now = DateTime.now();
        lastSyncAt.value = now;
        _lastSyncAt.set(now.millisecondsSinceEpoch);
      }
    } catch (e, s) {
      Loggers.app.warning('Sync', e, s);
      lastError.value = _describe(e);
    } finally {
      syncing.value = false;
    }
  }
}

/// [e] as the user reads it.
String _describe(Object e) => switch (e) {
  BackupPasswordMissing() => l10n.backupPasswordRequired,
  BackupTooNew() => l10n.backupTooNew,
  // Opening the remote failed: the password here is not the one it was
  // written with, most likely.
  BackupPasswordNeeded() => l10n.passwordWrong,
  // fl_lib's Cryptor says so only in its message.
  _ when '$e'.contains('Failed to decrypt') => l10n.passwordWrong,
  _ => '$e',
};

/// A backup whose merge failure is reported, not only logged.
final class _Tracked implements Mergeable {
  const _Tracked(this.inner, this.onError);

  final Backup inner;
  final void Function(Object) onError;

  @override
  Future<void> merge({bool force = false}) async {
    try {
      await inner.merge(force: force);
    } catch (e) {
      onError(e);
      rethrow;
    }
  }
}

/// Runs one after another, never two at once.
final class SerialRuns {
  Future<void> _tail = Future.value();

  /// The [soon] run waiting for its turn, if one is.
  Future<void>? _waiting;

  /// [body], after every run before it.
  Future<void> run(Future<void> Function() body, {void Function()? onStart}) {
    final run = _tail.then((_) {
      onStart?.call();
      return body();
    });
    _tail = run.then((_) {}, onError: (_) {});
    return run;
  }

  /// [body] after the run going on, unless a [soon] run already waits for
  /// its turn: that one does it, so a burst of calls is one run, and at most
  /// one waits behind the one running.
  Future<void> soon(Future<void> Function() body) =>
      _waiting ??= run(body, onStart: () => _waiting = null);
}
