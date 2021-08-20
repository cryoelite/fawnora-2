import 'dart:typed_data';

import 'package:fawnora/common_widgets/viewmodels/ButtonIconViewModel.dart';
import 'package:fawnora/constants/FirestoreDocuments.dart';
import 'package:fawnora/constants/ImageAssets.dart';
import 'package:fawnora/locale/LocaleConfig.dart';
import 'package:fawnora/models/LocaleTypeEnum.dart';
import 'package:fawnora/models/SpecieModel.dart';
import 'package:fawnora/models/SpecieTypeEnum.dart';
import 'package:fawnora/models/SpecieValueTypeEnum.dart';
import 'package:fawnora/services/LocalStorageService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final specieModelBuilderProvider =
    StateNotifierProvider<SpecieModelBuilderViewModel, List<SpecieModel>?>(
        (ref) {
  final watchLocalStorage = ref.read(localStorageProvider);
  final watchSpecieIconId = ref.read(activeFinalSpecieIconIdProvider.notifier);
  final watchLocale = ref.watch(localeTypeProvider);
  print("locale changed");
  return SpecieModelBuilderViewModel(
    watchLocalStorage,
    watchSpecieIconId,
    watchLocale,
  );
});

class SpecieModelBuilderViewModel extends StateNotifier<List<SpecieModel>?> {
  final LocalStorageService _localStorageService;
  final ActiveIconNotifier _specieIconData;
  final LocaleType _localeType;
  SpecieModelBuilderViewModel(
    this._localStorageService,
    this._specieIconData,
    this._localeType,
  ) : super(null);

  Future<void> 
  initList() async {
    if (state == null) {
      final specieData =
          await _localStorageService.retrieveAllSubspecieData(_localeType);
      final List<SpecieModel> elems = await _getSpecieData(specieData);
      state = elems;
    }
  }

  Future<List<SpecieModel>> _getSpecieData(
      Map<SpecieType, Map<String, List<String>?>> specieData) async {
    final imageMap = await _localStorageService.retrieveImageMap();
    final List<SpecieModel> elems = [];
    for (var elem in specieData.entries) {
      for (var elemData in elem.value.entries) {
        if (elemData.value != null && elemData.value!.isNotEmpty) {
          for (var specie in elemData.value!) {
            final _localAsset = _getIconAsset(specie, elem.key);
            final _imageData = await _getImageData(specie, imageMap);
            final specieElem = SpecieModel(
              specie,
              _localAsset,
              SpecieValueType.SPECIE,
              _specieIconData.uid,
              specieType: elem.key,
              subSpecie: elemData.key,
              imagedata: _imageData,
            );
            elems.add(specieElem);
          }
        }
      }
    }
    return elems;
  }

  Future<Uint8List?> _getImageData(
      String specie, Map<String, Map<String, String>?> imageMap) async {
    final _filename = _checkImageMap(specie, imageMap);
    Uint8List? data;

    if (_filename != null) {
      data = await _localStorageService.retrieveImage(_filename);
    }
    return data;
  }

  String? _checkImageMap(
      String specie, Map<String, Map<String, String>?> imageMap) {
    String? _filename;
    final localeType = _localeType;
    for (final filemap in imageMap.entries) {
      if (filemap.value != null && filemap.value!.isNotEmpty) {
        for (final languagemap in filemap.value!.entries) {
          if (localeType == LocaleType.HINDI) {
            if (languagemap.key == FirestoreDocumentsAndFields.imageMapHindi &&
                languagemap.value == specie) {
              _filename = filemap.key;
            }
          } else {
            if (languagemap.key ==
                    FirestoreDocumentsAndFields.imageMapEnglish &&
                languagemap.value == specie) {
              _filename = filemap.key;
            }
          }
        }
      }
    }
    return _filename;
  }

  String _getIconAsset(String name, SpecieType type) {
    final localeType = _localeType;
    String assetName;
    if (type == SpecieType.DISTURBANCE ||
        type == SpecieType.DISTURBANCE_HINDI) {
      assetName = ImageAssets.disturbanceIcon;
    } else if (type == SpecieType.FLORA || type == SpecieType.FLORA_HINDI) {
      assetName = ImageAssets.floraIcon;
    } else {
      assetName = ImageAssets.faunaIcon;
    }

    if (localeType == LocaleType.ENGLISH) {
      final engName = ImageAssets.englishMapping[name];
      if (engName != null) {
        assetName = engName;
      }
    } else if (localeType == LocaleType.HINDI) {
      final hindiName = ImageAssets.hindiMapping[name];
      if (hindiName != null) {
        assetName = hindiName;
      }
    } else {
      final engName = ImageAssets.englishMapping[name];
      if (engName != null) {
        assetName = engName;
      }
    }
    return assetName;
  }

  List<SpecieModel>? get currentState => state;

  set newState(List<SpecieModel>? value) => state = value;
}
