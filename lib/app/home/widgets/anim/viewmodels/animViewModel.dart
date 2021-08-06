import 'package:fawnora/app/home/widgets/anim/viewmodels/currentAnimViewModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final animViewModelProvider =
    StateNotifierProvider<AnimViewModel, CurrentAnimViewModel>(
  (ref) => AnimViewModel(
    ref.read(currentAnimViewModelProvider),
  ),
);

class AnimViewModel extends StateNotifier<CurrentAnimViewModel> {
  final CurrentAnimViewModel _riveModel;
  AnimViewModel(this._riveModel) : super(_riveModel);

  CurrentAnimViewModel get currentModel => _riveModel;
}
