import 'package:flutter_riverpod/flutter_riverpod.dart';

final splashRouteViewModelProvider =
    StateNotifierProvider<SplashRouteViewModel, bool>(
        (_) => SplashRouteViewModel());

class SplashRouteViewModel extends StateNotifier<bool> {
  SplashRouteViewModel() : super(false);

  Future<void> initializeApp() async {
    await Future.delayed(Duration(seconds: 5));
    state = true;
  }

  bool get splashRouteComplete => state;
}
