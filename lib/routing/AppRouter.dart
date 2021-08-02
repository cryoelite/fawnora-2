import 'package:fawnora/app/authentication/AuthenticationRoute.dart';
import 'package:fawnora/app/authentication/Widgets/loginWidget.dart';
import 'package:fawnora/app/authentication/Widgets/signUpWidget.dart';
import 'package:fawnora/app/home/homeRoute.dart';
import 'package:fawnora/app/splash/splashRoute.dart';
import 'package:fawnora/constants/AppRoutes.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.splashRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => SplashRoute(),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.authRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => AuthenticationRoute(),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.signUpRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => SignUpWidget(),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.loginRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => LoginWidget(),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.homeRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => HomeRoute(),
          settings: settings,
          fullscreenDialog: true,
        );
      default:
        return null;
    }
  }
}
