import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final keyBoardStatusProvider =
    StateNotifierProvider<KeyboardStatusViewModel, bool>(
        (_) => KeyboardStatusViewModel());

class KeyboardStatusViewModel extends StateNotifier<bool> {
  KeyboardVisibilityController _keyboardVisibilityController =
      KeyboardVisibilityController();

  KeyboardStatusViewModel() : super(false) {
    Future.delayed(
        Duration.zero,
        () => {
              _keyboardVisibilityController.onChange.listen((event) {
                state = event;
              }),
            });
  }
}
