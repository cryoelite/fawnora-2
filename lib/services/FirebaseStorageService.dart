import 'dart:developer' as dev;
import 'dart:typed_data';

import 'package:fawnora/services/LocalStorageService.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseStorageProvider = Provider<FirebaseStorageService>((ref) {
  dev.log("FirebaseStorage Provider started", level: 800);
  final watchLocalStorage = ref.read(localStorageProvider);
  return FirebaseStorageService(FirebaseStorage.instance, watchLocalStorage);
});

Future<Uint8List> _getImage(String url) async {
  dev.log("FirebaseStorage: Downloading an image", level: 700);

  Uint8List bytes =
      (await NetworkAssetBundle(Uri.parse(url)).load(url)).buffer.asUint8List();

  dev.log("FirebaseStorage: Downloading an image complete", level: 700);

  return bytes;
}

class FirebaseStorageService {
  final _className = 'FirebaseStorage';
  final LocalStorageService _localStorageService;
  final FirebaseStorage _instance;
  const FirebaseStorageService(this._instance, this._localStorageService);

  Future<List<String>> getImageNames() async {
    dev.log("$_className: Getting All ImageNames", level: 800);

    final list = <String>[];
    final _path = '/Species/';
    final _refData = await _instance.ref(_path).list();
    for (final image in _refData.items) {
      final name = image.name;
      if (_fileTypeChecker(name)) {
        list.add(name);
      }
    }

    dev.log("$_className: Getting All ImageNames complete", level: 800);

    return list;
  }

  Future<Map<String, Uint8List>> getAllImages() async {
    dev.log("$_className: Getting All Images", level: 800);

    final Map<String, Uint8List> items = await _getItems();

    dev.log("$_className: Getting All Images complete", level: 800);

    return items;
  }

  bool _fileTypeChecker(String item) {
    dev.log("$_className: Running file type checker", level: 700);

    final List<String> acceptableFileTypes = [
      '.jpg',
      '.png',
      '.jpeg',
    ];

    final result = acceptableFileTypes.any((element) => item.endsWith(element));
    dev.log("$_className: file type checker complete", level: 700);

    return result;
  }

  Future<Map<String, Uint8List>> _getItems() async {
    final Map<String, Uint8List> items = Map();

    final _path = '/Species/';
    final _refData = await _instance.ref(_path).list();

    for (final image in _refData.items) {
      final name = image.name;
      if (_fileTypeChecker(name)) {
        final localFile = await _localStorageService.retrieveCacheImage(name);
        if (localFile == null) {
          final url = await image.getDownloadURL();

          final data = await compute(_getImage, url);
          items[name] = data;
          await _localStorageService.storeCacheImage(data, name);
        } else {
          items[name] = localFile;
        }
      }
    }

    return items;
  }
}
