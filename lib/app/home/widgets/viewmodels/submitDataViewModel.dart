import 'package:fawnora/app/home/widgets/DropDown/viewmodels/DropDownViewModel.dart';
import 'package:fawnora/app/home/widgets/googleMaps/viewmodels/GoogleMapViewModel.dart';
import 'package:fawnora/common_widgets/viewmodels/ButtonIconViewModel.dart';
import 'package:fawnora/locale/LocaleConfig.dart';
import 'package:fawnora/models/LocaleTypeEnum.dart';
import 'package:fawnora/models/SpecieModel.dart';
import 'package:fawnora/models/UserDataModel.dart';
import 'package:fawnora/services/FirestoreService.dart';
import 'package:fawnora/services/ReverseGeocodingService.dart';
import 'package:fawnora/services/TransectService.dart';
import 'package:fawnora/services/UserService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final submitDataProvider =
    StateNotifierProvider((ref) => SubmitDataViewModel(ref));

class SubmitDataViewModel extends StateNotifier {
  final ProviderReference _providerReference;
  SubmitDataViewModel(this._providerReference) : super(false);

  Future<String> quickAddSubmit() async {
    state = true;

    final watchLocale = _providerReference.read(localeProvider);
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
      return watchLocale.localeObject.submissionSuccess;
    }
    state = false;
    return watchLocale.localeObject.submissionFailure;
  }

  bool get isBusy => state;
}
