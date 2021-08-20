import 'package:fawnora/models/SpecieModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectionStatusProvider =
    StateNotifierProvider<SelectionStatusViewModel, SpecieModel?>(
  (ref) => _getProvider(ref),
);

SelectionStatusViewModel _getProvider(ProviderReference ref) {
  return SelectionStatusViewModel();
}

class SelectionStatusViewModel extends StateNotifier<SpecieModel?> {
  SelectionStatusViewModel() : super(null);

  set newState(SpecieModel? specieModel) => state = specieModel;

  SpecieModel? get currentState => state;
}
