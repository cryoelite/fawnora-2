import 'package:fawnora/models/LocaleTypeEnum.dart';
import 'package:fawnora/locale/english/englishLocaleConstraints.dart';
import 'package:fawnora/locale/hindi/hindiLocaleConstraints.dart';
import 'package:fawnora/locale/localeConstraints.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeProvider =
    Provider<LocaleConfig>((ref) => LocaleConfig(LocaleType.ENGLISH));

class LocaleConfig {
  final LocaleType localeType;
  LocaleConfig(this.localeType);
  LocaleConstraints get localeObject {
    if (localeType == LocaleType.ENGLISH)
      return EnglishLocaleConstraints();
    else if (localeType == LocaleType.HINDI) {
      return HindiLocaleConstraints();
    } else
      return EnglishLocaleConstraints();
  }
}
