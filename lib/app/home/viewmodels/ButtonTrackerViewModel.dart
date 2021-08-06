import 'package:fawnora/app/home/widgets/anim/viewmodels/currentAnimViewModel.dart';
import 'package:fawnora/constants/StartStopButtonEnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final buttonTrackerProvider =
    StateNotifierProvider<ButtonTrackerViewModel, StartStopButtonEnum>(
        (ref) => ButtonTrackerViewModel(StartStopButtonEnum.STOP, ref));

class ButtonTrackerViewModel extends StateNotifier<StartStopButtonEnum> {
  final ProviderReference _providerReference;
  ButtonTrackerViewModel(
      StartStopButtonEnum _startEnum, this._providerReference)
      : super(_startEnum);
  void toggleState() {
    if (state == StartStopButtonEnum.PLAY)
      state = StartStopButtonEnum.STOP;
    else
      state = StartStopButtonEnum.PLAY;
    final watchAnimProvider =
        _providerReference.read(currentAnimViewModelProvider);
    watchAnimProvider.changeCurrentAnimation();
  }

  StartStopButtonEnum get currentState => state;
}
