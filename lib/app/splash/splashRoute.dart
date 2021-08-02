import 'package:fawnora/app/splash/splashWidget.dart';
import 'package:fawnora/app/splash/viewmodels/splashRouteViewModel.dart';
import 'package:fawnora/constants/AppColors.dart';
import 'package:fawnora/constants/AppRoutes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashRoute extends StatelessWidget {
  Future<void> initializeApp(BuildContext context) async {
    final splashRouteViewModel =
        context.read(splashRouteViewModelProvider.notifier);
    await splashRouteViewModel.initializeApp();
    nextRoute(context);
  }

  void nextRoute(BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoutes.authRoute, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color2,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: FutureBuilder(
          future: initializeApp(context),
          builder: (_, __) {
            return SplashWidget();
          },
        ),
      ),
    );
  }
}
