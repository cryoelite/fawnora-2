import 'package:fawnora/common_widgets/viewmodels/ButtonIconViewModel.dart';
import 'package:fawnora/models/SpecieModel.dart';
import 'package:fawnora/models/SpecieTypeEnum.dart';
import 'package:fawnora/services/LocalStorageService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchBarProvider = StateNotifierProvider<SearchBarViewModel, String?>(
  (ref) {
    final watchLocalStorage = ref.read(localStorageProvider);
    final watchSpecieIconId =
        ref.read(activeFinalSpecieIconIdProvider.notifier);
    return SearchBarViewModel(watchLocalStorage, watchSpecieIconId);
  },
);

class SearchBarViewModel extends StateNotifier<String?> {
  final LocalStorageService _localStorageService;
  final ActiveIconNotifier _specieIconData;
  SearchBarViewModel(this._localStorageService, this._specieIconData)
      : super(null);

  Future<void> initList() async {
    final specieData = await _localStorageService.retrieveAllSubspecieData();
    final List<SpecieModel> elems=await _getSpecieData(specieData);
  }

  Future<List<SpecieModel>> _getSpecieData(Map<SpecieType, Map<String, List<String>>> specieData) async{
    final List<SpecieModel> elems=[];
    
    for (var elem in specieData.entries) {
      for (var elemData in elem.value.entries) {
        for (var specie in elemData.value) {
          final specieElem= SpecieModel(specie, localImageAsset, specieValueType, specieId, specieType: elem.key)
        }
      }
    }
    return elems;
  }

  String? get currentState => state;
}
