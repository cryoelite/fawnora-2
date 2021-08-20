import 'dart:developer' as dev;
import 'package:fawnora/services/SyncLocalAndFirestoreService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final appinitServiceProvider = Provider<AppInitializerService>((ref) {
  dev.log("AppInitializer Provider started", level: 800);

  return AppInitializerService(ref);
});

class AppInitializerService {
  final _className = 'AppInitializerService';
  final ProviderReference _ref;
  AppInitializerService(this._ref);

  Future<bool> init() async {
    dev.log('$_className: Initializing', level: 800);

    final status = await _statuses();
    final syncService = _ref.read(syncerServiceProvider);
    await syncService.init();

    dev.log('$_className: Initializing complete', level: 800);

    return status;
  }

  Future<bool> _statuses() async {
    dev.log('$_className: Getting statuses', level: 700);

    try {
      final List<bool> statuses = <bool>[];
      final permissionStatus = await _permissionHandler();
      statuses.add(permissionStatus);
      if (statuses.any((element) => element == false)) {
        return false;
      }
      dev.log('$_className: Getting statuses complete', level: 700);

      return true;
    } catch (e) {
      dev.log("$_className: Error in app Initialization: $e", level: 1000);
      return false;
    }
  }

  Future<bool> _permissionHandler() async {
    dev.log('$_className: Getting permissions', level: 700);

    final Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.accessMediaLocation,
      Permission.manageExternalStorage,
    ].request();
    if (statuses.values.any(
      (value) => value.isDenied,
    )) {
      dev.log("$_className: Inadequate Permissions granted", level: 1000);

      return false;
    }
    dev.log("$_className: All permissions OK", level: 800);
    return true;
  }
}
