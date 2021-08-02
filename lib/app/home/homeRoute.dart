import 'package:fawnora/app/authentication/Widgets/loginWidget.dart';
import 'package:fawnora/constants/AppColors.dart';
import 'package:fawnora/locale/LocaleConfig.dart';
import 'package:flutter/material.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({Key? key}) : super(key: key);

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color2,
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
