import 'package:fawnora/app/InitializeApp/InitializeApp.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fawnora/app/splash/splashRoute.dart';
import 'package:fawnora/constants/AppColors.dart';
import 'package:fawnora/routing/AppRouter.dart';

Future<void> main() async {
  await InitializeApp(MainApp()).init();
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fawnora',
      theme: ThemeData(
        primarySwatch: AppColors.createMaterialColor(
          AppColors.color2,
        ),
        textTheme: TextTheme(
          headline1: GoogleFonts.merriweather(color: AppColors.color7),
          bodyText1: GoogleFonts.sourceSansPro(color: AppColors.color7),
        ),
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) => AppRouter.onGenerateRoute(settings),
      home: SplashRoute(),
    );
  }
}
