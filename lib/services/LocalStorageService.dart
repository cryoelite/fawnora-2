import 'dart:developer';
import 'dart:typed_data';

import 'package:fawnora/constants/LocalStorageBoxes.dart';
import 'package:fawnora/constants/LocalStorageKeys.dart';
import 'package:fawnora/models/LocaleTypeEnum.dart';
import 'package:fawnora/models/SpecieTypeEnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final localStorageProvider =
    Provider<LocalStorageService>((_) => LocalStorageService());

class LocalStorageService {
  final String encodingCharacter = '%';
  Future<void> storeLanguage(LocaleType localeType) async {
    final box = await Hive.openBox<LocaleType>(LocalStorageBoxes.languageBox);
    box.put(LocalStorageKeys.languageKey, localeType);
    await box.close();
  }

  Future<LocaleType?> retrieveLanguage() async {
    final box = await Hive.openBox<LocaleType>(LocalStorageBoxes.languageBox);
    final value = box.get(LocalStorageKeys.languageKey);
    await box.close();
    return value;
  }

  Future<void> storeFirestoreversions(
      String imageStorageVersion, String mainDataVersion) async {
    final box = await Hive.openBox(LocalStorageBoxes.firestoreMetadata);
    await box.put(LocalStorageKeys.imageStorageVersionKey, imageStorageVersion);
    await box.put(
        LocalStorageKeys.mainDataCollectionVersionKey, mainDataVersion);
    await box.close();
  }

  Future<Map<String, String?>> retrieveLocalVersions() async {
    final box = await Hive.openBox(LocalStorageBoxes.firestoreMetadata);
    final imageVersion =
        (await box.get(LocalStorageKeys.imageStorageVersionKey)).toString();
    final mainDataVersion =
        (await box.get(LocalStorageKeys.mainDataCollectionVersionKey))
            .toString();
    await box.close();
    final data = {
      LocalStorageKeys.imageStorageVersionKey: imageVersion,
      LocalStorageKeys.mainDataCollectionVersionKey: mainDataVersion,
    };
    return data;
  }

  Future<void> storeSubspecieData(
      Map<SpecieType, Map<String, List<String>>> subspecies) async {
    for (var elem in subspecies.entries) {
      final box = await _getSubSpecieBox(elem.key);
      final encVal = _encodeAndMap(elem.value);
      await box.putAll(encVal);

      await box.close();
    }
  }

  Map<String, Map<String, String>> _encodeAndImageMap(
      Map<String, Map<String, String>> imageMap) {
    final convMap = imageMap.map((key, value) {
      final convVal = value.map((key, value) {
        final convVal2 = _encodeKeys(value);
        return MapEntry(key, convVal2);
      });
      return MapEntry(key, convVal);
    });
    return convMap;
  }

  Map<String, List<String>> _encodeAndMap(Map<String, List<String>> data) {
    final m2 = data.map((key, val) {
      final convKey = _encodeKeys(key);

      return MapEntry(convKey, val);
    });
    return m2;
  }

  String _encodeKeys(String key) {
    final convKey = key.codeUnits.join(encodingCharacter);
    return convKey;
  }

  Map<String, Map<String, String>> _decodeAndImageMap(
      Map<String, Map<String, String>> imageMap) {
    final convImage = imageMap.map((key, value) {
      final convVal = value.map((key, value) {
        final convVal2 = _decodeKeys(value);
        return MapEntry(key, convVal2);
      });
      return MapEntry(key, convVal);
    });

    return convImage;
  }

  Map<String, List<String>> _decodeAndMap(Map<String, List<String>> data) {
    final m3 = data.map((key, val) {
      final convKey = _decodeKeys(key);
      return MapEntry(convKey, val);
    });
    return m3;
  }

  String _decodeKeys(String key) {
    final chars = key.split(encodingCharacter).map((elem) => int.parse(elem));
    key = String.fromCharCodes(chars);
    return key;
  }

  Future<Map<String, List<String>>> retrieveSubspecieData(
      SpecieType type) async {
    final box = await _getSubSpecieBox(type);
    final data = box.toMap().map((key, value) {
      final convKey = key.toString();
      if (value is List) {
        final convVal = value.map((element) {
          return element.toString();
        });
        return MapEntry(convKey, convVal.toList());
      } else {
        throw TypeError();
      }
    });
    await box.close();

    final convData = _decodeAndMap(data);
    return convData;
  }

  Future<Map<SpecieType, Map<String, List<String>>>>
      retrieveAllSubspecieData() async {
    final Map<SpecieType, Map<String, List<String>>> mapData = {};
    for (var type in SpecieType.values) {
      final data = await retrieveSubspecieData(type);
      mapData[type] = data;
    }
    return mapData;
  }

  Future<void> resetLocalDbBoxes() async {
    for (var value in SpecieType.values) {
      final box = await _getSubSpecieBox(value);
      await box.clear();
      await box.close();
    }
    final box = await Hive.openBox(LocalStorageBoxes.firestoreMetadata);
    await box.clear();
    await box.close();

    final box2 = await Hive.openBox(LocalStorageBoxes.imageBox);
    await box2.clear();
    await box2.close();

    final box3 = await Hive.openBox(LocalStorageBoxes.imageMap);
    await box3.clear();
    await box3.close();
  }

  Future<Box<dynamic>> _getSubSpecieBox(SpecieType type) async {
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
    return box;
  }

  Future<void> storeImage(Uint8List imageData, String filename) async {
    final box = await Hive.openBox(LocalStorageBoxes.imageBox);
    await box.put(filename, imageData);
    await box.close();
  }

  Future<Uint8List?> retrieveImage(String filename) async {
    final box = await Hive.openBox(LocalStorageBoxes.imageBox);
    final data = await box.get(filename);
    await box.close();
    if (data == null || !data is Uint8List) {
      return null;
    }
    return data;
  }

  Future<void> storeImageMap(Map<String, Map<String, String>> imageMap) async {
    final box = await Hive.openBox(LocalStorageBoxes.imageMap);
    final convMap = _encodeAndImageMap(imageMap);
    await box.putAll(convMap);
    await box.close();
  }

  Future<Map<String, Map<String, String>>> retrieveImageMap() async {
    final box = await Hive.openBox(LocalStorageBoxes.imageMap);
    final data = box.toMap();
    final Map<String, Map<String, String>> imageMap = data.map((key, value) {
      final convKey = key.toString();
      if (value is Map<String, String>) {
        return MapEntry(convKey, value);
      } else {
        throw TypeError();
      }
    });

    final convImageMap = _decodeAndImageMap(imageMap);
    await box.close();
    return convImageMap;
  }
}
//TODO: Sync image map and images. Then build searchBarprovider and then list for the bar.