import 'package:fawnora/app/authentication/Widgets/loginWidget.dart';
import 'package:fawnora/constants/AppColors.dart';
import 'package:flutter/material.dart';

class AuthenticationRoute extends StatefulWidget {
  const AuthenticationRoute({Key? key}) : super(key: key);

  @override
  _AuthenticationRouteState createState() => _AuthenticationRouteState();
}

class _AuthenticationRouteState extends State<AuthenticationRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color2,
      body: SafeArea(
        child: LoginWidget(),
      ),
    );
  }
}
