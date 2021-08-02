import 'package:fawnora/app/authentication/viewmodels/authViewModel.dart';
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

class SignUpWidget extends ConsumerWidget {
  SignUpWidget({Key? key}) : super(key: key);
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _accessCodeController = TextEditingController();
  final _nameController = TextEditingController();

  void pushLoginRoute(BuildContext context) {
    context.read(authenticationViewModelProvider.notifier).resetState();

    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoutes.loginRoute, (_) => false);
  }

  Future<void> signUp(BuildContext context, ScopedReader watch) async {
    final watchAuth = watch(authenticationViewModelProvider.notifier);
    await watchAuth.signUp(_usernameController.text, _passwordController.text,
        _nameController.text, _accessCodeController.text);
    if (watchAuth.currentState == AuthEnum.SUCCESS)
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.homeRoute, (_) => false);
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final watchLocale = watch(localeProvider);
    final watchAuth = watch(authenticationViewModelProvider.notifier);
    return Scaffold(
      backgroundColor: AppColors.color2,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: ScreenConstraintService(context).minHeight * 5,
              left: ScreenConstraintService(context).minWidth * 5,
              child: Text(
                watchLocale.localeObject.signUpText,
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
                    "Access Code",
                    errorText: watchAuth.validateAccessCode(
                      _accessCodeController.text,
                    ),
                  ),
                  CustomTextField(
                    _nameController,
                    TextInputType.name,
                    [
                      FilteringTextInputFormatter.singleLineFormatter,
                      FilteringTextInputFormatter.allow(
                        RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"),
                      ),
                    ],
                    [],
                    "Name",
                    errorText: watchAuth.validateName(
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
                    "Phone Number",
                    errorText: watchAuth.validateUsername(
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
                    "Password",
                    obscure: true,
                    errorText: watchAuth.validatePassword(
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
                          watchLocale.localeObject.signUp,
                          style: TextStyle(
                            fontFamily: GoogleFonts.merriweather().fontFamily,
                            fontSize:
                                ScreenConstraintService(context).minWidth * 2,
                            fontWeight: FontWeight.bold,
                            color: AppColors.color7,
                          ),
                        ),
                        Container(
                          width: ScreenConstraintService(context).minWidth * 9,
                          height:
                              ScreenConstraintService(context).minHeight * 5,
                          child: IconButton(
                            iconSize: 24,
                            splashRadius: 24,
                            icon: Image.asset(
                              ImageAssets.signUpButton,
                            ),
                            onPressed: () async {
                              await signUp(context, watch);
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
                          watchAuth.errorBuilder(watchAuthProvider) ?? "",
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
                            watchLocale.localeObject.login,
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
