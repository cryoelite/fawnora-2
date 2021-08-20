import 'dart:developer' as dev;
import 'dart:io';
import 'dart:typed_data';

import 'package:fawnora/constants/LocalStorageBoxes.dart';
import 'package:fawnora/constants/LocalStorageKeys.dart';
import 'package:fawnora/models/LocaleTypeEnum.dart';
import 'package:fawnora/models/SpecieTypeEnum.dart';
import 'package:fawnora/services/DataSanitizerService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final localStorageProvider = Provider<LocalStorageService>((_) {
  dev.log("LocalStorage Provider started", level: 800);
  return LocalStorageService();
});

class LocalStorageService {
  final String _className = 'LocalStorage';
  final _dataSanitizer = DataSanitizerService();

  Future<void> storeLanguage(LocaleType localeType) async {
    dev.log('$_className: Storing locale data', level: 800);
    final box = await Hive.openBox<LocaleType>(LocalStorageBoxes.languageBox);
    box.put(LocalStorageKeys.languageKey, localeType);
    await box.close();
    dev.log('$_className: Storing locale data complete', level: 800);
  }

  Future<LocaleType?> retrieveLanguage() async {
    dev.log('$_className: Retrieving language', level: 800);

    final box = await Hive.openBox<LocaleType>(LocalStorageBoxes.languageBox);
    final value = box.get(LocalStorageKeys.languageKey);
    await box.close();

    dev.log('$_className: Retrieval of locale complete', level: 800);

    return value;
  }

  Future<void> storeFirestoreversion(String mainDataVersion) async {
    dev.log('$_className: Storing firestore version', level: 800);

    final box = await Hive.openBox(LocalStorageBoxes.firestoreMetadata);
    await box.put(
        LocalStorageKeys.mainDataCollectionVersionKey, mainDataVersion);

    dev.log('$_className: Storing firestore version complete', level: 800);

    await box.close();
  }

  Future<void> storeFirebaseStorageversion(String imageStorageVersion) async {
    dev.log('$_className: Storing firebase storage version', level: 800);
    final file = await _getPath(LocalStorageKeys.imageStorageVersion);
    await file.create(recursive: true);

    await file.writeAsString(imageStorageVersion);

    dev.log('$_className: Storing firebase storage version complete',
        level: 800);
  }

  Future<Map<String, String?>> retrieveLocalVersions() async {
    dev.log('$_className: Retrieving local version', level: 800);

    final box = await Hive.openBox(LocalStorageBoxes.firestoreMetadata);
    final file = await _getPath(LocalStorageKeys.imageStorageVersion);
    String? imageVersion;
    if (await file.exists()) {
      imageVersion = await file.readAsString();
    }

    final mainDataVersion =
        (await box.get(LocalStorageKeys.mainDataCollectionVersionKey))
            ?.toString();
    await box.close();
    final data = {
      LocalStorageKeys.imageStorageVersion: imageVersion,
      LocalStorageKeys.mainDataCollectionVersionKey: mainDataVersion,
    };

    dev.log('$_className: Retrieving local version complete', level: 800);

    return data;
  }

  Future<void> storeSubspecieData(
      Map<SpecieType, Map<String, List<String>>> subspecies) async {
    dev.log('$_className: Storing Subspecie data', level: 800);

    for (var elem in subspecies.entries) {
      final box = await _getSubSpecieBox(elem.key);
      final encVal = _encodeAndMap(elem.value);
      await box.putAll(encVal);

      dev.log('$_className: Storing Subspecie data complete', level: 800);

      await box.close();
    }
  }

  Map<String, Map<String, String>>? _encodeAndImageMap(
      Map<String, Map<String, String>>? imageMap) {
    dev.log('$_className: Encoding image map', level: 700);

    final convMap = imageMap?.map((key, value) {
      final convKey = _dataSanitizer.encodeString(key);
      final convVal = value.map((key, value) {
        final convVal2 = _dataSanitizer.encodeString(value);
        final convkey2 = _dataSanitizer.encodeString(key);
        return MapEntry(convkey2, convVal2);
      });
      return MapEntry(convKey, convVal);
    });
    dev.log('$_className: Encoding image map complete', level: 700);

    return convMap;
  }

  Map<String, List<String>> _encodeAndMap(Map<String, List<String>> data) {
    dev.log('$_className: Encoding map', level: 700);

    final m2 = data.map((key, val) {
      final convKey = _dataSanitizer.encodeString(key);

      return MapEntry(convKey, val);
    });

    dev.log('$_className: Encoding map complete', level: 700);

    return m2;
  }

  Map<String, Map<String, String>?> _decodeAndImageMap(
      Map<String, Map<String, String>?> imageMap) {
    dev.log('$_className: Decoding image map', level: 700);

    final convImage = imageMap.map((key, value) {
      final convKey = _dataSanitizer.decodeString(key);
      final convVal = value?.map((key, value) {
        final convKey2 = _dataSanitizer.decodeString(key);
        final convVal2 = _dataSanitizer.decodeString(value);
        return MapEntry(convKey2, convVal2);
      });
      return MapEntry(convKey, convVal);
    });

    dev.log('$_className: Encoding image map complete', level: 700);

    return convImage;
  }

  Map<String, List<String>?> _decodeAndMap(Map<String, List<String>?> data) {
    dev.log('$_className: Decoding map', level: 700);

    final m3 = data.map((key, val) {
      final convKey = _dataSanitizer.decodeString(key);

      return MapEntry(convKey, val);
    });

    dev.log('$_className: Decoding map complete', level: 700);

    return m3;
  }

  Future<Map<String, List<String>?>> retrieveSubspecieData(
      SpecieType type) async {
    dev.log('$_className: Retrieving Subspecie Data', level: 800);

    final box = await _getSubSpecieBox(type);
    final data = box.toMap().map((key, value) {
      final convKey = key.toString();
      if (value is List && value.isNotEmpty) {
        final convVal = value.map((element) {
          return element.toString();
        });
        return MapEntry(convKey, convVal.toList());
      } else {
        return MapEntry(convKey, null);
      }
    });

    await box.close();

    final convData = _decodeAndMap(data);

    dev.log('$_className: Retrieving Subspecie Data complete', level: 800);

    return convData;
  }

  Future<Map<SpecieType, Map<String, List<String>?>>> retrieveAllSubspecieData(
      LocaleType localeType) async {
    dev.log('$_className: Retrieving All Subspecie Data', level: 800);

    final Map<SpecieType, Map<String, List<String>?>> mapData = {};
    for (var type in SpecieType.values) {
      if (localeType == LocaleType.HINDI) {
        if (type == SpecieType.DISTURBANCE_HINDI ||
            type == SpecieType.FAUNA_HINDI ||
            type == SpecieType.FLORA_HINDI) {
          final data = await retrieveSubspecieData(type);
          mapData[type] = data;
        }
      } else {
        if (type == SpecieType.DISTURBANCE ||
            type == SpecieType.FAUNA ||
            type == SpecieType.FLORA) {
          final data = await retrieveSubspecieData(type);
          mapData[type] = data;
        }
      }
    }

    dev.log('$_className: Retrieving All Subspecie Data complete', level: 800);

    return mapData;
  }

  Future<void> resetLocalDbBoxes() async {
    dev.log('$_className: Resetting local boxes', level: 800);

    for (var value in SpecieType.values) {
      final box = await _getSubSpecieBox(value);
      await box.clear();
      await box.close();
    }
    final box = await Hive.openBox(LocalStorageBoxes.firestoreMetadata);
    await box.clear();
    await box.close();

    final dir = await getTemporaryDirectory();
    await dir.delete(recursive: true);

    final box3 = await Hive.openBox(LocalStorageBoxes.imageMap);
    await box3.clear();
    await box3.close();

    dev.log('$_className: Resetting local boxes complete', level: 800);
  }

  Future<Box<dynamic>> _getSubSpecieBox(SpecieType type) async {
    dev.log('$_className: Get Subspecie box', level: 700);

    final Box<dynamic> box;
    if (type == SpecieType.FLORA) {
      box = await Hive.openBox(LocalStorageBoxes.floraBox);
    } else if (type == SpecieType.FAUNA) {
      box = await Hive.openBox(LocalStorageBoxes.faunaBox);
    } else if (type == SpecieType.DISTURBANCE) {
      box = await Hive.openBox(LocalStorageBoxes.disturbanceBox);
    } else if (type == SpecieType.FLORA_HINDI) {
      box = await Hive.openBox(LocalStorageBoxes.flora_hindiBox);
    } else if (type == SpecieType.FAUNA_HINDI) {
      box = await Hive.openBox(LocalStorageBoxes.fauna_hindiBox);
    } else {
      box = await Hive.openBox(LocalStorageBoxes.disturbance_hindiBox);
    }

    dev.log('$_className: Get Subspecie box complete', level: 700);

    return box;
  }

  Future<File> _getPath(String convFilename) async {
    dev.log('$_className: Get Temporary Directory', level: 700);

    final dir = await getTemporaryDirectory();
    final file =
        File('${dir.path}/${LocalStoragePaths.imageData}/$convFilename');
    dev.log('$_className: Get Temporary Directory complete', level: 700);

    return file;
  }

  Future<void> storeImage(Uint8List imageData, String filename) async {
    dev.log('$_className: Store Image', level: 800);

    final convFilename = _dataSanitizer.encodeString(filename);
    final file = await _getPath(convFilename);
    await file.create(recursive: true);
    await file.writeAsBytes(imageData);

    dev.log('$_className: Store Image complete', level: 800);
  }

  Future<Uint8List?> retrieveImage(String filename) async {
    dev.log('$_className: Retrieving Image', level: 800);
    final convFilename = _dataSanitizer.encodeString(filename);

    final file = await _getPath(convFilename);
    Uint8List data;
    if (await file.exists()) {
      data = await file.readAsBytes();
    } else {
      dev.log('$_className: Retrieving Image failed as image file doesnt exist',
          level: 800);

      return null;
    }

    dev.log('$_className: Retrieving Image Complete', level: 800);

    return data;
  }

  Future<bool> checkImage(String filename) async {
    dev.log('$_className: Checking Image', level: 800);
    final convFilename = _dataSanitizer.encodeString(filename);

    final file = await _getPath(convFilename);
    final status = await file.exists();

    dev.log('$_className: Checking Image Complete, image exists: $status',
        level: 800);

    return status;
  }

  Future<void> storeImageMap(Map<String, Map<String, String>>? imageMap) async {
    dev.log('$_className: Storing Image Map', level: 800);

    final box = await Hive.openBox(LocalStorageBoxes.imageMap);
    final convMap = _encodeAndImageMap(imageMap);

    if (convMap != null) {
      await box.putAll(convMap);
    }
    dev.log('$_className: Storing image map complete', level: 800);

    await box.close();
  }

  Future<Map<String, Map<String, String>?>> retrieveImageMap() async {
    dev.log('$_className: Retrieve image map', level: 800);

    final box = await Hive.openBox(LocalStorageBoxes.imageMap);
    final data = box.toMap();
    final Map<String, Map<String, String>?> imageMap = data.map((key, value) {
      final convKey = key.toString();
      if (value is Map && value.isNotEmpty) {
        final val1 = value.keys.first.toString();
        final val2 = value.values.first.toString();
        return MapEntry(convKey, {val1: val2});
      } else {
        return MapEntry(convKey, null);
      }
    });

    final convImageMap = _decodeAndImageMap(imageMap);
    await box.close();

    dev.log('$_className: Retrieving image map complete', level: 800);

    return convImageMap;
  }
}
