import 'package:fawnora/models/LocaleTypeEnum.dart';
import 'package:fawnora/locale/english/englishLocaleConstraints.dart';
import 'package:fawnora/locale/hindi/hindiLocaleConstraints.dart';
import 'package:fawnora/locale/localeConstraints.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeConfigProvider =
    StateNotifierProvider<LocaleConfig, LocaleConstraints>((ref) {
  final watchLocale = ref.watch(localeTypeProvider);
  if (watchLocale == LocaleType.HINDI) {
    return LocaleConfig(HindiLocaleConstraints());
  } else {
    return LocaleConfig(EnglishLocaleConstraints());
  }
});

final localeTypeProvider =
    StateNotifierProvider<LocaleTypeConfig, LocaleType>((ref) {
  return LocaleTypeConfig(LocaleType.ENGLISH);
});

class LocaleConfig extends StateNotifier<LocaleConstraints> {
  LocaleConfig(LocaleConstraints _localeConstraints)
      : super(_localeConstraints);

  LocaleConstraints get locale => state;

  set newLocale(LocaleConstraints value) => state = value;
}

class LocaleTypeConfig extends StateNotifier<LocaleType> {
  LocaleTypeConfig(LocaleType value) : super(value);

  set updateState(LocaleType value) {
    state = value;
  }

  LocaleType get currentState => state;
}
