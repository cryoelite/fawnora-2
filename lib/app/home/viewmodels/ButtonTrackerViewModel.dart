import 'package:fawnora/app/home/widgets/anim/viewmodels/currentAnimViewModel.dart';
import 'package:fawnora/models/StartStopButtonEnum.dart';
import 'package:fawnora/services/TransectService.dart';
import 'package:fawnora/services/UserService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final buttonTrackerProvider =
    StateNotifierProvider<ButtonTrackerViewModel, StartStopButtonEnum>(
        (ref) => ButtonTrackerViewModel(StartStopButtonEnum.STOP, ref));

class ButtonTrackerViewModel extends StateNotifier<StartStopButtonEnum> {
  final ProviderReference _providerReference;
  ButtonTrackerViewModel(
      StartStopButtonEnum _startEnum, this._providerReference)
      : super(_startEnum);
  Future<void> toggleState() async {
    if (state == StartStopButtonEnum.PLAY) {
      final readUserService =
          _providerReference.read(userServiceProvider).userModel;
      if (readUserService != null) {
        final readTransectService =
            _providerReference.read(transectServiceProvider);
        await readTransectService.increment(readUserService.username);
      }
      state = StartStopButtonEnum.STOP;
    } else {
      state = StartStopButtonEnum.PLAY;
    }
    final watchAnimProvider =
        _providerReference.read(currentAnimViewModelProvider);
    watchAnimProvider.changeCurrentAnimation();
  }

  StartStopButtonEnum get currentState => state;
}
