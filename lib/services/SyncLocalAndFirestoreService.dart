import 'package:fawnora/models/SpecieTypeEnum.dart';
import 'package:fawnora/services/FirestoreService.dart';
import 'package:fawnora/services/LocalStorageService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final syncerServiceProvider = Provider<SyncLocalAndFireStoreService>((ref) {
  final watchLocal = ref.watch(localStorageProvider);
  final watchFirestore = ref.watch(firestoreProvider);

  return SyncLocalAndFireStoreService(watchLocal, watchFirestore);
});

class SyncLocalAndFireStoreService {
  final FirestoreService _firestoreService;
  final LocalStorageService _localStorageService;

  SyncLocalAndFireStoreService(
    this._localStorageService,
    this._firestoreService,
  );

  Future<void> init() async {
    final result = await _checkVersion();
    print("The result is $result");

    if (!result.key) {
      await _resetLocalDb();
      final firestoreSubSpecieData =
          await _firestoreService.getSubspecieDocuments();
      final imageVer = _getConvVersion(result.value, 'image');
      final mainVer = _getConvVersion(result.value, 'main');
      await _storeSubSpecieLocally(firestoreSubSpecieData);
      await _storeVersions(imageVer, mainVer);
    }
  }

  Future<void> _storeSubSpecieLocally(
      Map<SpecieType, Map<String, List<String>>> mapData) async {
    await _localStorageService.storeSubspecieData(mapData);
  }

  Future<void> _storeVersions(
      String imageStorageKey, String mainStorageKey) async {
    await _localStorageService.storeFirestoreversions(
        imageStorageKey, mainStorageKey);
  }

  Future<void> _resetLocalDb() async {
    await _localStorageService.resetLocalDbBoxes();
  }

  String _getConvVersion(Map<String, String?> verDoc, String type) {
    final version = verDoc.keys
        .firstWhere((element) => element.toLowerCase().contains(type));
    return verDoc[version] ?? "0";
  }

  Future<MapEntry<bool, Map<String, String>>> _checkVersion() async {
    final localVersions = await _localStorageService.retrieveLocalVersions();
    final _firestoreVersions = await _firestoreService.getVersions();
    if (localVersions.values.any((element) => element == null)) {
      return MapEntry(false, _firestoreVersions);
    }
    final localImageVer = _getConvVersion(localVersions, 'image');
    final localMainDataVer = _getConvVersion(localVersions, 'main');
    final firestoreImageVer = _getConvVersion(_firestoreVersions, 'image');
    final firestoreMainDataVer = _getConvVersion(_firestoreVersions, 'main');
    if (localImageVer == firestoreImageVer &&
        localMainDataVer == firestoreMainDataVer) {
      return MapEntry(true, _firestoreVersions);
    } else {
      return MapEntry(false, _firestoreVersions);
    }
  }
}
