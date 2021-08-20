import 'dart:typed_data';
import 'dart:developer' as dev;
import 'package:fawnora/models/SpecieTypeEnum.dart';
import 'package:fawnora/services/FirebaseStorageService.dart';
import 'package:fawnora/services/FirestoreService.dart';
import 'package:fawnora/services/LocalStorageService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    final result = await _checkVersion();
    print("The result is $result");

    if (!result.key) {
      await _resetLocalDb();

      final firestoreSubSpecieData =
          await _firestoreService.getSubspecieDocuments();
      await _storeSubSpecieLocally(firestoreSubSpecieData);

      final mainVer = _getConvVersion(result.value, 'main');
      await _storeFirestoreVersion(mainVer);
      final imageVer = _getConvVersion(result.value, 'image');

      _manageImageData(imageVer);
    }

    dev.log('$_className: Initializing complete', level: 800);
  }

  void _manageImageData(String imageVer) async {
    dev.log('$_className: Storing image data', level: 800);

    final imageMap = await _firestoreService.getImageMap();
    await _storeImageMapLocally(imageMap);

    final imageData = await _firebaseStorageService.getAllImages();
    await _storeImagesLocally(imageData);

    await _storeFirebaseStorageVersion(imageVer).then((_) {
      dev.log('$_className: Storing image data complete', level: 800);
    });
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

  Future<void> _resetLocalDb() async {
    dev.log('$_className: Resetting local boxes', level: 700);

    await _localStorageService.resetLocalDbBoxes();

    dev.log('$_className: Resetting local boxes complete', level: 700);
  }

  String _getConvVersion(Map<String, String?> verDoc, String type) {
    final version = verDoc.keys
        .firstWhere((element) => element.toLowerCase().contains(type));
    return verDoc[version] ?? "0";
  }

  Future<MapEntry<bool, Map<String, String>>> _checkVersion() async {
    dev.log('$_className: Checking versions', level: 700);

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
      dev.log('$_className: Versions are same', level: 700);

      return MapEntry(true, _firestoreVersions);
    } else {
      dev.log('$_className: Versions are not same', level: 700);

      return MapEntry(false, _firestoreVersions);
    }
  }
}
