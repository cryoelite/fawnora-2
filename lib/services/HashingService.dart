import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:developer' as dev;

import 'package:fawnora/constants/KeyAssets.dart';
import 'package:flutter/foundation.dart' hide Key;
import 'package:flutter/services.dart';
import 'package:aes_crypt/aes_crypt.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart';

enum KEYTYPE {
  USERNAME,
  PASSWORD,
  AUXILIARY,
}

int _spinB(int val) {
  int wbsvVal = 0;
  val ~/= 478;
  wbsvVal += pow((pow(6 * val, 3) + 1), 3).toInt();
  wbsvVal -= pow((pow(6 * val, 3) - 1), 3).toInt();
  wbsvVal -= pow(pow(6 * val, 2), 3).toInt();
  return wbsvVal;
}

class HashingService {
  final _className = 'HashingService';
  final String _uKeyKey = (r"crfuixm{r5u8x:{1DAG*J-OdSgijYo\s");
  final String _pKeyKey = (r"Xm[r5u8x;{&D(G+JBOdSgVjYo\s6v9y#");
  final String _aKeyKey = (r"zr4u7x:{1DAG*J-OdSgUjXo[s5v4h;|&");

  final String _uKey = '/uKey.aes';
  final String _aKey = '/aKey.aes';
  final String _pKey = '/pKey.aes';
  /* Map<KEYTYPE, String> _keyMap = {
    KEYTYPE.USERNAME: "uKey.aes",
    KEYTYPE.PASSWORD: "pKey.aes",
    KEYTYPE.AUXILIARY: "aKey.aes",
  }; */

  Future<String> _deserialize(String key) async {
    dev.log('$_className: Deserializing key', level: 700);

    String decKey = "";
    final rand = Random(954).nextInt(96);
    int val = await compute(_spinB, rand);
    for (int i = 0; i < key.length; ++i)
      decKey += String.fromCharCode(key.codeUnitAt(i) - val);
    dev.log('$_className: Deserializing key complete', level: 700);

    return decKey;
  }

  Future<String> _getPath() async {
    dev.log('$_className: Getting path', level: 700);

    final dir = await getTemporaryDirectory();
    final file = await dir.createTemp();
    final path = file.path;

    dev.log('$_className: Getting path complete', level: 700);

    return path;
  }

  Future<Uint8List> _getDataFromAsset(String location) async {
    dev.log('$_className: Getting data from assets', level: 700);

    final loadedFile = await rootBundle.load(location);
    final data = loadedFile.buffer.asUint8List();

    dev.log('$_className: Getting data from assets complete', level: 700);

    return data;
  }

  Future<String> _getFile(KEYTYPE keytype) async {
    dev.log('$_className: Getting file', level: 700);

    String path = await _getPath();
    final Uint8List data;

    if (keytype == KEYTYPE.AUXILIARY) {
      data = await _getDataFromAsset(KeyAssets.auxilliaryKey);
      path = path + _aKey;
    } else if (keytype == KEYTYPE.PASSWORD) {
      data = await _getDataFromAsset(KeyAssets.passwordKey);
      path = path + _pKey;
    } else if (keytype == KEYTYPE.USERNAME) {
      data = await _getDataFromAsset(KeyAssets.usernameKey);
      path = path + _uKey;
    } else {
      throw UnimplementedError("This Keytype is not implemented yet.");
    }
    final file = File(path);
    await file.writeAsBytes(data);

    dev.log('$_className: Getting file complete', level: 700);

    return path;
  }

  Future<String> _decrKey(KEYTYPE keytype) async {
    dev.log('$_className: Decrypting key', level: 700);

    final String path = await _getFile(keytype);

    var crypt = AesCrypt();
    if (keytype == KEYTYPE.USERNAME)
      crypt.setPassword(await _deserialize(this._uKeyKey));
    if (keytype == KEYTYPE.PASSWORD)
      crypt.setPassword(await _deserialize(this._pKeyKey));
    if (keytype == KEYTYPE.AUXILIARY)
      crypt.setPassword(await _deserialize(this._aKeyKey));

    final decDataPath = await crypt.decryptFile(path);
    final decData = await File(decDataPath).readAsString();

    dev.log('$_className: Decrypting key complete', level: 700);

    return decData;
  }

  String genIV() {
    dev.log('$_className: Generating random IV', level: 800);

    final randVal = SecureRandom(16).base64;

    dev.log('$_className: Generating random IV complete', level: 800);

    return randVal;
  }

  /* Future<String> genHash(String username) async {
    final byteData = utf8.encode(username);
    final digestData = sha256.convert(byteData);
    return digestData.toString();
  } */

  Future<String> encrUsername(String username, String ivString) async {
    dev.log('$_className: Encrypt username', level: 800);

    final encrKey = Key.fromUtf8(await _decrKey(KEYTYPE.USERNAME));
    final encrypter = Encrypter(AES(encrKey));
    final IV iv = IV.fromBase64(ivString);
    final encryptedText = encrypter.encrypt(username, iv: iv);

    dev.log('$_className: Encrypt username complete', level: 800);

    return encryptedText.base64;
  }

  Future<String> encrIV(String normaliv, String ivString) async {
    dev.log('$_className: Encrypt IV', level: 800);

    final encrKey = Key.fromUtf8(await _decrKey(KEYTYPE.AUXILIARY));
    final encrypter = Encrypter(AES(encrKey));
    final IV iv = IV.fromBase64(ivString);
    final encrIV = encrypter.encrypt(normaliv, iv: iv);

    dev.log('$_className: Encrypt IV complete', level: 800);

    return encrIV.base64;
  }

  Future<String> encrPassword(String password, String ivString) async {
    dev.log('$_className: Encrypt Password', level: 800);

    final encrKey = Key.fromUtf8(await _decrKey(KEYTYPE.PASSWORD));
    final encrypter = Encrypter(AES(encrKey));
    final IV iv = IV.fromBase64(ivString);
    final encryptedText = encrypter.encrypt(password, iv: iv);

    dev.log('$_className: Encrypt Password complete', level: 800);

    return encryptedText.base64;
  }

  Future<String> decrUsername(String username, String ivString) async {
    dev.log('$_className: Decrypt username', level: 800);

    final encrKey = Key.fromUtf8(await _decrKey(KEYTYPE.USERNAME));
    final encrypter = Encrypter(AES(encrKey));
    final IV iv = IV.fromBase64(ivString);
    final decryptedText =
        encrypter.decrypt(Encrypted.fromBase64(username), iv: iv);

    dev.log('$_className: Decrypt username complete', level: 800);

    return decryptedText;
  }

  Future<String> decrIV(String encrIV, String ivString) async {
    dev.log('$_className: Decrypt iv', level: 800);

    final encrKey = Key.fromUtf8(await _decrKey(KEYTYPE.AUXILIARY));

    final encrypter = Encrypter(AES(encrKey));

    final IV iv = IV.fromBase64(ivString);

    final decrIV = encrypter.decrypt(Encrypted.fromBase64(encrIV), iv: iv);

    dev.log('$_className: Decrypt iv complete', level: 800);

    return decrIV;
  }

  Future<String> decrPassword(String password, String ivString) async {
    dev.log('$_className: Decrypt password', level: 800);

    final encrKey = Key.fromUtf8(await _decrKey(KEYTYPE.PASSWORD));

    final encrypter = Encrypter(AES(encrKey));
    final IV iv = IV.fromBase64(ivString);
    final decryptedText =
        encrypter.decrypt(Encrypted.fromBase64(password), iv: iv);

    dev.log('$_className: Decrypt password complete', level: 800);

    return decryptedText;
  }
}
