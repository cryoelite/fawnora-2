import 'package:fawnora/locale/LocaleConfig.dart';
import 'package:fawnora/models/LocaleTypeEnum.dart';
import 'package:fawnora/services/LocalStorageService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final languageModelProvider =
    StateNotifierProvider<LanguageViewModel, bool>((ref) {
  final watchLocale = ref.watch(localeTypeProvider);
  final watchLocalStorage = ref.read(localStorageProvider);
  return LanguageViewModel(watchLocale, watchLocalStorage, ref);
});

class LanguageViewModel extends StateNotifier<bool> {
  final LocaleType _localeType;
  final ProviderReference _ref;
  final LocalStorageService _localStorageService;
  LanguageViewModel(this._localeType, this._localStorageService, this._ref)
      : super(false);

  void changeLocale(LocaleType localeType) {
    if (localeType != _localeType) {
      _ref.read(localeTypeProvider.notifier).updateState = localeType;
      _localStorageService.storeLanguage(localeType);
    }
    state = false;
  }

  bool get currentState => state;

  set newState(bool val) => state = val;
}
