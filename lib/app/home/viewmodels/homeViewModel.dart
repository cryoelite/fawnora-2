import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeRouteViewModelProvider =
    StateNotifierProvider<HomeRouteViewModel, bool>(
        (_) => HomeRouteViewModel());

class HomeRouteViewModel extends StateNotifier<bool> {
  HomeRouteViewModel() : super(false);

  bool get homeRouteViewModelState => state;
}
