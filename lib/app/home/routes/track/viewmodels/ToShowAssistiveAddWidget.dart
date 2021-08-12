import 'package:flutter_riverpod/flutter_riverpod.dart';

final toShowAssistiveAddWidgetProvider =
    StateNotifierProvider<ToShowAssistiveAddWidget, bool>(
        (_) => ToShowAssistiveAddWidget());

class ToShowAssistiveAddWidget extends StateNotifier<bool> {
  ToShowAssistiveAddWidget() : super(false);

  bool get currentState => state;
  set newState(bool val) => state = val;
}
