import 'package:fawnora/app/authentication/viewmodels/authViewModel.dart';
import 'package:fawnora/models/AuthEnum.dart';
import 'package:fawnora/services/AppInitializerService.dart';
import 'package:fawnora/services/LocalStorageService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final splashRouteViewModelProvider =
    StateNotifierProvider<SplashRouteViewModel, bool>((ref) {
  final watchAppInit = ref.read(appinitServiceProvider);
  final watchLocalStorage = ref.read(localStorageProvider);
  final watchAuth = ref.read(authenticationViewModelProvider.notifier);
  return SplashRouteViewModel(watchAppInit, watchLocalStorage, watchAuth);
});

class SplashRouteViewModel extends StateNotifier<bool> {
  final AppInitializerService _appInitializerService;
  final LocalStorageService _localStorageService;
  final AuthenticationViewModel _authenticationViewModel;
  bool autoLoginStatus = false;
  SplashRouteViewModel(
    this._appInitializerService,
    this._localStorageService,
    this._authenticationViewModel,
  ) : super(false);

  Future<bool> initializeApp() async {
    await Future.delayed(Duration(seconds: 5));
    final status = await _appInitializerService.permStatus();
    if (status) {
      await _appInitializerService.init();
      final data = await _localStorageService.retrieveLoginCredentials();
      if (data != null) {
        final result = await _authenticationViewModel.autoLogin(data);
        if (result == AuthEnum.SUCCESS) {
          autoLoginStatus = true;
        }
      }
      state = true;
    }
    return state;
  }

  bool get splashRouteComplete => state;
}
