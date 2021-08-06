import 'package:fawnora/constants/HomeRouteConstants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeRouteViewModelProvider =
    StateNotifierProvider<HomeRouteViewModel, int>((_) => HomeRouteViewModel());

class HomeRouteViewModel extends StateNotifier<int> {
  HomeRouteViewModel() : super(HomeRouteConstants.homeVal);

  set newState(int val) => state = val;

  int get homeRouteViewModelState => state;
}
