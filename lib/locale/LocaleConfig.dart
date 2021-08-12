import 'package:fawnora/models/LocaleTypeEnum.dart';
import 'package:fawnora/locale/english/englishLocaleConstraints.dart';
import 'package:fawnora/locale/hindi/hindiLocaleConstraints.dart';
import 'package:fawnora/locale/localeConstraints.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeProvider =
    Provider<LocaleConfig>((ref) => LocaleConfig(LocaleType.ENGLISH));

class LocaleConfig extends StateNotifier<LocaleType> {
  LocaleType localeType;
  LocaleConfig(this.localeType) : super(localeType);
  LocaleConstraints get localeObject {
    if (state == LocaleType.ENGLISH)
      return EnglishLocaleConstraints();
    else if (state == LocaleType.HINDI) {
      return HindiLocaleConstraints();
    } else
      return EnglishLocaleConstraints();
  }

  set updateState(LocaleType value) => state = value;

  LocaleType get currentState => state;
}
