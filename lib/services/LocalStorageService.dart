import 'package:fawnora/constants/LocalStorageBoxes.dart';
import 'package:fawnora/constants/LocalStorageKeys.dart';
import 'package:fawnora/models/LocaleTypeEnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final localStorageProvider =
    Provider<LocalStorageService>((_) => LocalStorageService());

class LocalStorageService {
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
}
