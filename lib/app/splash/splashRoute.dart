import 'package:fawnora/app/splash/splashWidget.dart';
import 'package:fawnora/app/splash/viewmodels/splashRouteViewModel.dart';
import 'package:fawnora/common_widgets/ShowSnackBar.dart';
import 'package:fawnora/constants/AppColors.dart';
import 'package:fawnora/constants/AppRoutes.dart';
import 'package:fawnora/locale/LocaleConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashRoute extends StatelessWidget {
  Future<void> initializeApp(BuildContext context) async {
    final splashRouteViewModel =
        context.read(splashRouteViewModelProvider.notifier);
    final status = await splashRouteViewModel.initializeApp();
    if (status) {
      nextRoute(context);
    } else {
      final watchLocale = context.read(localeConfigProvider);
      ShowSnackBar().showSnackBar(watchLocale.inadequatePerms, context);
    }
  }

  void nextRoute(BuildContext context) {
    if (context.read(splashRouteViewModelProvider.notifier).autoLoginStatus) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.homeRoute, (route) => false);
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.authRoute, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color2,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: FutureBuilder(
          future: initializeApp(context),
          builder: (_, snapshot) {
            return SplashWidget();
          },
        ),
      ),
    );
  }
}
