import 'dart:developer' as dev;
import 'package:fawnora/services/SyncLocalAndFirestoreService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final appinitServiceProvider =
    Provider<AppInitializerService>((ref) => AppInitializerService(ref));

class AppInitializerService {
  final ProviderReference _ref;
  AppInitializerService(this._ref);

  Future<bool> init() async {
    final status = await _statuses();
    final syncService = _ref.read(syncerServiceProvider);
    await syncService.init();

    return status;
  }

  Future<bool> _statuses() async {
    try {
      final List<bool> statuses = <bool>[];
      final permissionStatus = await _permissionHandler();
      statuses.add(permissionStatus);
      if (statuses.any((element) => element == false)) {
        return false;
      }
      return true;
    } catch (e) {
      dev.log("Error in app Initialization: $e", level: 1000);
      return false;
    }
  }

  Future<bool> _permissionHandler() async {
    final Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.accessMediaLocation,
      Permission.storage,
    ].request();
    if (statuses.values.any(
      (value) => value.isDenied,
    )) return false;
    dev.log("All permissions OK", level: 800);
    return true;
  }
}
