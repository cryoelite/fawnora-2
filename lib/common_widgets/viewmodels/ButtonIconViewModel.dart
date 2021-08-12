import 'package:fawnora/models/SpecieModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activeSpecieTypeIconIdProvider =
    StateNotifierProvider<ActiveIconNotifier, SpecieModel?>(
  (_) => ActiveIconNotifier(),
);
final activeSubSpecieIconIdProvider =
    StateNotifierProvider<ActiveIconNotifier, SpecieModel?>(
  (_) => ActiveIconNotifier(),
);
final activeFinalSpecieIconIdProvider =
    StateNotifierProvider<ActiveIconNotifier, SpecieModel?>(
  (_) => ActiveIconNotifier(),
);

class ActiveIconNotifier extends StateNotifier<SpecieModel?> {
  int _uid = 1;
  ActiveIconNotifier() : super(null);

  void setActiveId(SpecieModel specieModel) {
    if (specieModel == state) {
      state = null;
    } else {
      state = specieModel;
    }
  }

  int get uid => _uid++;

  void resetState() {
    _uid = 1;
    state = null;
  }

  SpecieModel? get currentState => state;
}
