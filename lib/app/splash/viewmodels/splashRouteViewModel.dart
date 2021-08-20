import 'package:fawnora/services/AppInitializerService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final splashRouteViewModelProvider =
    StateNotifierProvider<SplashRouteViewModel, bool>((ref) {
  final watchAppInit = ref.read(appinitServiceProvider);
  return SplashRouteViewModel(watchAppInit);
});

class SplashRouteViewModel extends StateNotifier<bool> {
  final AppInitializerService _appInitializerService;
  SplashRouteViewModel(this._appInitializerService) : super(false);

  Future<void> initializeApp() async {
    await Future.delayed(Duration(seconds: 5));
    final status = await _appInitializerService.init();
    if (status) state = true;
  }

  bool get splashRouteComplete => state;
}
