import 'dart:developer' as dev;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final splashRouteViewModelProvider =
    StateNotifierProvider<SplashRouteViewModel, bool>(
        (_) => SplashRouteViewModel());

class SplashRouteViewModel extends StateNotifier<bool> {
  SplashRouteViewModel() : super(false);

  Future<void> initializeApp() async {
    await Future.delayed(Duration(seconds: 5));
    final status = await _permissionHandler();
    if (status) state = true;
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

  bool get splashRouteComplete => state;
}
