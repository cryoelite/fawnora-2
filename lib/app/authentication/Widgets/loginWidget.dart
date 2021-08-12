import 'package:fawnora/app/authentication/viewmodels/authViewModel.dart';
import 'package:fawnora/common_widgets/AuthProgressIndicator.dart';
import 'package:fawnora/common_widgets/CustomTextField.dart';
import 'package:fawnora/constants/AppColors.dart';
import 'package:fawnora/constants/AppRoutes.dart';
import 'package:fawnora/constants/ImageAssets.dart';
import 'package:fawnora/locale/LocaleConfig.dart';
import 'package:fawnora/models/AuthEnum.dart';
import 'package:fawnora/services/ScreenConstraintService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginWidget extends StatelessWidget {
  LoginWidget({Key? key}) : super(key: key);
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void pushsignUpRoute(BuildContext context) {
    context.read(authenticationViewModelProvider.notifier).resetState();
    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoutes.signUpRoute, (_) => false);
  }

  Future<void> signIn(BuildContext context) async {
    if (context.read(authenticationViewModelProvider) != AuthEnum.LOADING) {
      final watchAuth = context.read(authenticationViewModelProvider.notifier);
      await watchAuth.signIn(
          _usernameController.text, _passwordController.text);
      if (watchAuth.currentState == AuthEnum.SUCCESS)
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.homeRoute, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color2,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: ScreenConstraintService(context).minHeight * 5,
              left: ScreenConstraintService(context).minWidth * 5,
              child: Consumer(
                builder: (context, watch, _) {
                  final watchLocale = watch(localeProvider);
                  return Text(
                    watchLocale.localeObject.loginText,
                    style: TextStyle(
                      fontFamily: GoogleFonts.merriweather().fontFamily,
                      fontSize: ScreenConstraintService(context).minWidth * 5,
                      color: AppColors.color7,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: ScreenConstraintService(context).minHeight * 21,
              left: ScreenConstraintService(context).minWidth * 7,
              child: Consumer(builder: (context, watch, _) {
                final watchLocale = watch(localeProvider);

                return Column(
                  children: [
                    CustomTextField(
                      _usernameController,
                      TextInputType.phone,
                      [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      [
                        AutofillHints.telephoneNumber,
                      ],
                      watchLocale.localeObject.phoneNumber,
                      errorText: context
                          .read(authenticationViewModelProvider.notifier)
                          .validateUsername(_usernameController.text),
                    ),
                    CustomTextField(
                      _passwordController,
                      TextInputType.visiblePassword,
                      [
                        FilteringTextInputFormatter.singleLineFormatter,
                      ],
                      [
                        AutofillHints.password,
                      ],
                      watchLocale.localeObject.password,
                      obscure: true,
                    ),
                  ],
                );
              }),
            ),
            Positioned(
              top: ScreenConstraintService(context).minHeight * 31.5,
              left: ScreenConstraintService(context).minWidth * 7,
              child: Container(
                width: ScreenConstraintService(context).getConvertedWidth(270),
                height: ScreenConstraintService(context).minHeight * 12,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Consumer(
                          builder: (context, watch, _) {
                            final watchLocale = watch(localeProvider);
                            return Text(
                              watchLocale.localeObject.login,
                              style: TextStyle(
                                fontFamily:
                                    GoogleFonts.merriweather().fontFamily,
                                fontSize:
                                    ScreenConstraintService(context).minWidth *
                                        2,
                                fontWeight: FontWeight.bold,
                                color: AppColors.color7,
                              ),
                            );
                          },
                        ),
                        AuthProgressIndicator(
                          child: IconButton(
                            iconSize: 24,
                            splashRadius: 24,
                            icon: Image.asset(
                              ImageAssets.loginButton,
                            ),
                            onPressed: () async {
                              await signIn(context);
                            },
                          ),
                        ),
                      ],
                    ),
                    Consumer(builder: (context, watch, _) {
                      final watchAuthProvider =
                          watch(authenticationViewModelProvider);
                      final authModel =
                          watch(authenticationViewModelProvider.notifier);
                      return Container(
                        width: ScreenConstraintService(context)
                            .getConvertedWidth(270),
                        height: ScreenConstraintService(context).minHeight * 4,
                        child: Text(
                          authModel.errorBuilder(watchAuthProvider) ?? "",
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: GoogleFonts.sourceSansPro().fontFamily,
                            fontSize:
                                ScreenConstraintService(context).minWidth * 1.5,
                          ),
                        ),
                      );
                    }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.zero,
                            ),
                          ),
                          child: Consumer(
                            builder: (context, watch, _) {
                              final watchLocale = watch(localeProvider);
                              return Text(
                                watchLocale.localeObject.signUp,
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontFamily:
                                      GoogleFonts.sourceSansPro().fontFamily,
                                  fontSize: ScreenConstraintService(context)
                                          .minWidth *
                                      2,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.color7,
                                ),
                              );
                            },
                          ),
                          onPressed: () {
                            pushsignUpRoute(context);
                          },
                        ),
                        TextButton(
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.zero,
                            ),
                          ),
                          child: Consumer(
                            builder: (context, watch, _) {
                              final watchLocale = watch(localeProvider);
                              return Text(
                                watchLocale.localeObject.forgotPassword,
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontFamily:
                                      GoogleFonts.sourceSansPro().fontFamily,
                                  fontSize: ScreenConstraintService(context)
                                          .minWidth *
                                      2,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.color7,
                                ),
                              );
                            },
                          ),
                          onPressed: () {
                            //TODO: Forgot Password
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: 50,
                height: 50,
                child: ElevatedButton(
                  child: Container(
                    color: Colors.red,
                  ),
                  onPressed: () {
                    _usernameController.text = "9305459563";
                    _passwordController.text = "Rex123@123";
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
