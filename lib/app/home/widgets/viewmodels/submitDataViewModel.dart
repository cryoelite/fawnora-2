import 'package:fawnora/app/home/widgets/AssistiveAdd/viewmodels/selectionStatusViewModel.dart';
import 'package:fawnora/app/home/widgets/DropDown/viewmodels/DropDownViewModel.dart';
import 'package:fawnora/app/home/widgets/googleMaps/viewmodels/GoogleMapViewModel.dart';
import 'package:fawnora/common_widgets/viewmodels/ButtonIconViewModel.dart';
import 'package:fawnora/locale/LocaleConfig.dart';
import 'package:fawnora/models/LocaleTypeEnum.dart';
import 'package:fawnora/models/UserDataModel.dart';
import 'package:fawnora/services/FirestoreService.dart';
import 'package:fawnora/services/ReverseGeocodingService.dart';
import 'package:fawnora/services/TransectService.dart';
import 'package:fawnora/services/UserService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart' show StringCharacters;
import 'package:google_maps_flutter/google_maps_flutter.dart';

final submitDataProvider = StateNotifierProvider<SubmitDataViewModel, bool>(
    (ref) => SubmitDataViewModel(ref));

class SubmitDataViewModel extends StateNotifier<bool> {
  final ProviderReference _providerReference;
  SubmitDataViewModel(this._providerReference) : super(false);

  Future<String> quickAddSubmit() async {
    state = true;

    final watchLocale = _providerReference.read(localeConfigProvider);

    final language =
        watchLocale.localeType == LocaleType.ENGLISH ? 'english' : 'hindi';
    final watchSpecie = _providerReference.read(activeSpecieTypeIconIdProvider);
    final watchSubSpecie =
        _providerReference.read(activeSubSpecieIconIdProvider);
    final watchdropdown = _providerReference.read(dropDownValueProvider).value;
    final watchUserModel =
        _providerReference.read(userServiceProvider).userModel;
    if (watchSpecie != null &&
        watchSubSpecie != null &&
        watchdropdown != null &&
        watchUserModel != null) {
      final watchTransect =
          _providerReference.read(transectServiceProvider).transectVal;
      final watchLocation = _providerReference.read(googleMapViewModelProvider);
      final LatLng location;
      if (watchLocation == null) {
        location = await _providerReference
            .read(googleMapViewModelProvider.notifier)
            .getCurrentLocation();
      } else {
        location = watchLocation;
      }
      final locMap = await ReverseGeocodingService()
          .findDistrict(location.latitude, location.longitude);
      final currentDateTIme = DateTime.now();
      final userDataModel = UserDataModel(
          watchUserModel.username,
          watchdropdown,
          watchSpecie.name,
          watchSubSpecie.name,
          location,
          locMap.value,
          locMap.key,
          currentDateTIme,
          watchTransect,
          language);
      await _providerReference
          .read(firestoreProvider)
          .submitData(userDataModel);
      state = false;

      return watchLocale.submissionSuccess;
    }
    state = false;
    return watchLocale.submissionFailure;
  }

  Future<String> assistiveAddSubmit() async {
    state = true;

    final watchLocale = _providerReference.read(localeConfigProvider);
    final watchAssistive = _providerReference.read(selectionStatusProvider);
    final language =
        watchLocale.localeType == LocaleType.ENGLISH ? 'english' : 'hindi';
    final watchUserModel =
        _providerReference.read(userServiceProvider).userModel;
    if (watchAssistive != null && watchUserModel != null) {
      final watchTransect =
          _providerReference.read(transectServiceProvider).transectVal;
      final watchLocation = _providerReference.read(googleMapViewModelProvider);
      final LatLng location;
      if (watchLocation == null) {
        location = await _providerReference
            .read(googleMapViewModelProvider.notifier)
            .getCurrentLocation();
      } else {
        location = watchLocation;
      }
      final locMap = await ReverseGeocodingService()
          .findDistrict(location.latitude, location.longitude);
      final currentDateTIme = DateTime.now();
      final userDataModel = UserDataModel(
        watchUserModel.username,
        watchAssistive.name,
        _formatEnum(watchAssistive.specieType.toString()),
        watchAssistive.subSpecie!,
        location,
        locMap.value,
        locMap.key,
        currentDateTIme,
        watchTransect,
        language,
      );
      await _providerReference
          .read(firestoreProvider)
          .submitData(userDataModel);
      state = false;
      return watchLocale.submissionSuccess;
    }
    state = false;

    return watchLocale.submissionFailure;
  }

  String _formatEnum(String enumVal) {
    final result = enumVal.toLowerCase();
    final index = result.indexOf('.') + 1;
    var convResult = result.replaceRange(0, index, '');
    convResult = convResult.trim();

    convResult = convResult.replaceFirst(
        convResult.characters.first, convResult.characters.first.toUpperCase());
    final latterString = convResult.indexOf('_');
    if (latterString != -1) {
      convResult = convResult.substring(0, latterString);
    }
    return convResult;
  }

  String? get isBusy {
    final watchLocale = _providerReference.read(localeConfigProvider);

    if (state) {
      return watchLocale.waitCompletion;
    } else {
      return null;
    }
  }
}
