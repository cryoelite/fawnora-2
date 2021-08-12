import 'package:flutter_riverpod/flutter_riverpod.dart';

final toShowQuickAddWidgetProvider =
    StateNotifierProvider<ToShowQuickAdd, bool>((_) => ToShowQuickAdd());

class ToShowQuickAdd extends StateNotifier<bool> {
  ToShowQuickAdd() : super(false);

  bool get currentState => state;
  set newState(bool val) => state = val;
}
