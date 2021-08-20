import 'package:fawnora/app/authentication/Widgets/AuthValidator.dart';
import 'package:fawnora/app/authentication/viewmodels/authViewModel.dart';
import 'package:fawnora/common_widgets/AuthProgressIndicator.dart';
import 'package:fawnora/common_widgets/CustomTextField.dart';
import 'package:fawnora/constants/AppColors.dart';
import 'package:fawnora/constants/AppRoutes.dart';
import 'package:fawnora/constants/ImageAssets.dart';
import 'package:fawnora/locale/LocaleConfig.dart';
import 'package:fawnora/models/AuthEnum.dart';
import 'package:fawnora/models/LocaleTypeEnum.dart';
import 'package:fawnora/services/ScreenConstraintService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpWidget extends ConsumerWidget {
  SignUpWidget({Key? key}) : super(key: key);
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _accessCodeController = TextEditingController();
  final _nameController = TextEditingController();
  final _validator = AuthValidator();

  void pushLoginRoute(BuildContext context) {
    context.read(authenticationViewModelProvider.notifier).resetState();

    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoutes.loginRoute, (_) => false);
  }

  Future<void> signUp(BuildContext context) async {
    if (context.read(authenticationViewModelProvider) != AuthEnum.LOADING) {
      final watchAuth = context.read(authenticationViewModelProvider.notifier);
      await watchAuth.signUp(_usernameController.text, _passwordController.text,
          _nameController.text, _accessCodeController.text);
      if (watchAuth.currentState == AuthEnum.SUCCESS)
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.homeRoute, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final watchLocale = watch(localeConfigProvider);
    return Scaffold(
      backgroundColor: AppColors.color2,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: ScreenConstraintService(context).minHeight * 5,
              left: ScreenConstraintService(context).minWidth * 5,
              child: Text(
                watchLocale.signUpText,
                style: TextStyle(
                  fontFamily: GoogleFonts.merriweather().fontFamily,
                  fontSize: ScreenConstraintService(context).minWidth * 5,
                  color: AppColors.color7,
                ),
              ),
            ),
            Positioned(
              top: ScreenConstraintService(context).minHeight * 10.5,
              left: ScreenConstraintService(context).minWidth * 7,
              child: Column(
                children: [
                  CustomTextField(
                    _accessCodeController,
                    TextInputType.number,
                    [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    [],
                    watchLocale.accessCode,
                    errorText: _validator.validateAccessCode(
                      _accessCodeController.text,
                    ),
                  ),
                  CustomTextField(
                    _nameController,
                    TextInputType.name,
                    [
                      FilteringTextInputFormatter.singleLineFormatter,
                      watchLocale.localeType != LocaleType.ENGLISH
                          ? FilteringTextInputFormatter.allow(
                              RegExp(r"/[~`!@#$%^&()_={}[\]:;,.<>+\/?-]/"),
                            )
                          : FilteringTextInputFormatter.allow(
                              RegExp(
                                  r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"),
                            ),
                    ],
                    [],
                    watchLocale.name,
                    errorText: _validator.validateName(
                      _nameController.text,
                    ),
                  ),
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
                    watchLocale.phoneNumber,
                    errorText: _validator.validateUsername(
                      _usernameController.text,
                    ),
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
                    watchLocale.password,
                    obscure: true,
                    errorText: _validator.validatePassword(
                      _passwordController.text,
                    ),
                  ),
                ],
              ),
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
                        Text(
                          watchLocale.signUp,
                          style: TextStyle(
                            fontFamily: GoogleFonts.merriweather().fontFamily,
                            fontSize:
                                ScreenConstraintService(context).minWidth * 2,
                            fontWeight: FontWeight.bold,
                            color: AppColors.color7,
                          ),
                        ),
                        AuthProgressIndicator(
                          child: IconButton(
                            iconSize: 24,
                            splashRadius: 24,
                            icon: Image.asset(
                              ImageAssets.signUpButton,
                            ),
                            onPressed: () async {
                              await signUp(context);
                            },
                          ),
                        ),
                      ],
                    ),
                    Consumer(builder: (context, watch, child) {
                      final watchAuthProvider =
                          watch(authenticationViewModelProvider);
                      return Container(
                        width: ScreenConstraintService(context)
                            .getConvertedWidth(270),
                        height: ScreenConstraintService(context).minHeight * 4,
                        child: Text(
                          _validator.errorBuilder(watchAuthProvider) ?? "",
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
                          child: Text(
                            watchLocale.login,
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontFamily:
                                  GoogleFonts.sourceSansPro().fontFamily,
                              fontSize:
                                  ScreenConstraintService(context).minWidth * 2,
                              fontWeight: FontWeight.bold,
                              color: AppColors.color7,
                            ),
                          ),
                          onPressed: () {
                            pushLoginRoute(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
