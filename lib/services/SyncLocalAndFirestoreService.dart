import 'dart:typed_data';
import 'dart:developer' as dev;
import 'package:fawnora/models/SpecieTypeEnum.dart';
import 'package:fawnora/services/FirebaseStorageService.dart';
import 'package:fawnora/services/FirestoreService.dart';
import 'package:fawnora/services/LocalStorageService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final syncerServiceProvider = Provider<SyncLocalAndFireStoreService>((ref) {
  final watchLocal = ref.read(localStorageProvider);
  final watchFirestore = ref.read(firestoreProvider);
  final watchFirestorage = ref.read(firebaseStorageProvider);
  dev.log('SyncService provider started', level: 800);
  return SyncLocalAndFireStoreService(
      watchLocal, watchFirestore, watchFirestorage);
});

class SyncLocalAndFireStoreService {
  final _className = 'SyncService';
  final FirestoreService _firestoreService;
  final LocalStorageService _localStorageService;
  final FirebaseStorageService _firebaseStorageService;

  SyncLocalAndFireStoreService(
    this._localStorageService,
    this._firestoreService,
    this._firebaseStorageService,
  );

  Future<void> init() async {
    dev.log('$_className: Initializing', level: 800);

    final appVerResult = await _checkAppVersion();
    final firestoreVerResult = await _checkVersionFirestore();
    final imageVerResult = await _checkVersionImageData();

    dev.log(
        "Versions are same ? firestore: $firestoreVerResult, imageData: $imageVerResult, appVer: $appVerResult");
    if (!firestoreVerResult.key) {
      await _localStorageService.resetLocalDbFirestore();

      final firestoreSubSpecieData =
          await _firestoreService.getSubspecieDocuments();
      await _storeSubSpecieLocally(firestoreSubSpecieData);

      await _storeFirestoreVersion(firestoreVerResult.value);

      final imageMap = await _firestoreService.getImageMap();
      await _storeImageMapLocally(imageMap);
    }

    if (!imageVerResult.key) {
      await _localStorageService.resetLocalDbImageStorage();

      _manageImageData(imageVerResult.value);
    }

    if (!appVerResult.key) {
      await _storeAppVersion(appVerResult.value);
    }

    dev.log('$_className: Initializing complete', level: 800);
  }

  Future<void> _storeAppVersion(String currentVer) async {
    await _localStorageService.storeAppVersion(currentVer);
  }

  void _manageImageData(String imageVer) async {
    dev.log('$_className: Storing image data', level: 800);

    final imageData = await _firebaseStorageService.getAllImages();
    await _storeImagesLocally(imageData);

    await _storeFirebaseStorageVersion(imageVer).then((_) {
      dev.log('$_className: Storing image data complete', level: 800);
    });

    await _localStorageService.clearCacheImages();
  }

  Future<void> _storeImagesLocally(Map<String, Uint8List> imageData) async {
    dev.log('$_className: Storing images locally', level: 700);

    for (var item in imageData.entries) {
      await _localStorageService.storeImage(item.value, item.key);
    }

    dev.log('$_className: Storing images locally complete', level: 700);
  }

  Future<void> _storeImageMapLocally(
      Map<String, Map<String, String>>? imageMap) async {
    dev.log('$_className: Storing image map locally', level: 700);

    await _localStorageService.storeImageMap(imageMap);

    dev.log('$_className: Storing image map locally complete', level: 700);
  }

  Future<void> _storeSubSpecieLocally(
      Map<SpecieType, Map<String, List<String>>> mapData) async {
    dev.log('$_className: Storing sub species locally', level: 700);

    await _localStorageService.storeSubspecieData(mapData);

    dev.log('$_className: Storing sub species locally complete', level: 700);
  }

  Future<void> _storeFirestoreVersion(String mainStorageKey) async {
    dev.log('$_className: Storing firestore version locally', level: 700);

    await _localStorageService.storeFirestoreversion(mainStorageKey);

    dev.log('$_className: Storing firestore versions locally complete',
        level: 700);
  }

  Future<void> _storeFirebaseStorageVersion(String imageVersion) async {
    dev.log('$_className: Storing firebase storage version locally',
        level: 700);

    await _localStorageService.storeFirebaseStorageversion(imageVersion);

    dev.log('$_className: Storing firebase storage versions locally complete',
        level: 700);
  }

  String _getConvVersion(Map<String, String?> verDoc, String type) {
    final version = verDoc.keys
        .firstWhere((element) => element.toLowerCase().contains(type));
    return verDoc[version] ?? "0";
  }

  Future<String> _getCurrentAppVersion() async {
    final pkgInfo = await PackageInfo.fromPlatform();
    final version = pkgInfo.version;
    return version;
  }

  Future<MapEntry<bool, String>> _checkVersionFirestore() async {
    dev.log('$_className: Checking versions', level: 700);

    final localVersions = await _localStorageService.retrieveLocalVersions();

    final _firestoreVersions = await _firestoreService.getVersions();
    final firestoreMainDataVer = _getConvVersion(_firestoreVersions, 'main');

    if (localVersions.values.any((element) => element == null)) {
      return MapEntry(false, firestoreMainDataVer);
    }
    final localMainDataVer = _getConvVersion(localVersions, 'main');
    return MapEntry(
        firestoreMainDataVer == localMainDataVer, firestoreMainDataVer);
  }

  Future<MapEntry<bool, String>> _checkAppVersion() async {
    final currentAppVersion = await _getCurrentAppVersion();
    final localAppVersion =
        await _localStorageService.retrieveAppVersion() ?? "0";
    return MapEntry(currentAppVersion == localAppVersion, currentAppVersion);
  }

  Future<MapEntry<bool, String>> _checkVersionImageData() async {
    final _firestoreVersions = await _firestoreService.getVersions();
    final firestoreImageVer = _getConvVersion(_firestoreVersions, 'image');
    final localVersions = await _localStorageService.retrieveLocalVersions();
    if (localVersions.values.any((element) => element == null)) {
      return MapEntry(false, firestoreImageVer);
    }
    final localImageVer = _getConvVersion(localVersions, 'image');
    return MapEntry(localImageVer == firestoreImageVer, firestoreImageVer);
  }
}
