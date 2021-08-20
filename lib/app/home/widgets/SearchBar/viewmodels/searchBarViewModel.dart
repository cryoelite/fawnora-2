import 'package:fawnora/app/home/widgets/AssistiveAdd/viewmodels/selectionStatusViewModel.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchBarProvider = StateNotifierProvider<SearchBarViewModel, String?>(
  (ref) {
    final watchSelectionStatus = ref.read(selectionStatusProvider.notifier);

    return SearchBarViewModel(watchSelectionStatus);
  },
);

class SearchBarViewModel extends StateNotifier<String?> {
  final SelectionStatusViewModel _selectionStatusViewModel;

  SearchBarViewModel(
    this._selectionStatusViewModel,
  ) : super(null);

  String? get currentState => state;

  set newState(String? value) {
    _selectionStatusViewModel.newState = null;
    state = value;
  }
}
