import 'dart:developer' as dev;

class DataSanitizerService {
  final _className = 'DataSanitizer';
  final _encodingCharacter = '%';

  String encodeString(String inp) {
    dev.log('$_className: Encoding key', level: 700);

    final convKey = inp.codeUnits.join(_encodingCharacter);

    dev.log('$_className: Encoding key complete', level: 700);
    return convKey;
  }

  String decodeString(String inp) {
    dev.log('$_className: Decoding key', level: 700);

    final chars = inp.split(_encodingCharacter).map((elem) => int.parse(elem));
    final result = String.fromCharCodes(chars);

    dev.log('$_className: Decoding key complete', level: 700);

    return result;
  }
}
