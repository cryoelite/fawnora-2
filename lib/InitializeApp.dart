import 'package:fawnora/services/SystemOverlayOverrides.dart';
import 'package:fawnora/models/LocaleTypeEnum.dart';
import 'package:fawnora/locale/LocaleConfig.dart';
import 'package:fawnora/services/LocalStorageService.dart';
import 'package:fawnora/services/WatchManService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:hive_flutter/hive_flutter.dart';

class InitializeApp {
  final StatelessWidget mainApp;

  InitializeApp(this.mainApp);

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    final deviceLanguage = await platformLanguage();

    await initLocalStorage();

    final localStorageLanguage = await getLocalStorageLanguage();
    if (localStorageLanguage == null) {
      await setLocalStorageLanguage(deviceLanguage);
    }
    _portraitModeOnly();
    _setSystemTheme();
    runApp(
      ProviderScope(
        child: Consumer(
            child: mainApp,
            builder: (context, watch, child) {
              final watchWatchMan = watch(watchManProvider);

              return KeyedSubtree(
                key: watchWatchMan,
                child: child!,
              );
            }),
        overrides: [
          localeTypeProvider.overrideWithValue(
            LocaleTypeConfig(localStorageLanguage ?? deviceLanguage),
          ),
        ],
      ),
    );
  }

  void _setSystemTheme() {
    final systemTheme = SystemOverlayOverrides.systemOverlayOverrides;
    SystemChrome.setSystemUIOverlayStyle(systemTheme);
  }

  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> initLocalStorage() async {
    await Hive.initFlutter();
    Hive.registerAdapter(LocaleTypeAdapter());
  }

  Future<LocaleType?> getLocalStorageLanguage() async {
    final localLanguage = await LocalStorageService().retrieveLanguage();
    return localLanguage;
  }

  Future<void> setLocalStorageLanguage(LocaleType localeType) async {
    await LocalStorageService().storeLanguage(localeType);
  }

  Future<LocaleType> platformLanguage() async {
    final languages = await Devicelocale.preferredLanguages;
    if (languages != null) {
      if (languages.first.toString().contains('hi')) {
        return LocaleType.HINDI;
      } //else if(languages.first.toString().contains('en')) this is default,i.e., language is set to english by default.
    }
    return LocaleType.ENGLISH;
  }
}
