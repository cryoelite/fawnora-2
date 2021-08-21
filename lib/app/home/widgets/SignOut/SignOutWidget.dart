import 'package:fawnora/app/InitializeApp/viewmodels/ResetAppViewModel.dart';
import 'package:fawnora/app/InitializeApp/viewmodels/WatchManViewModel.dart';
import 'package:fawnora/app/authentication/viewmodels/authViewModel.dart';
import 'package:fawnora/constants/AppColors.dart';
import 'package:fawnora/constants/AppRoutes.dart';
import 'package:fawnora/locale/LocaleConfig.dart';
import 'package:fawnora/services/ScreenConstraintService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SignOutWidget extends ConsumerWidget {
  const SignOutWidget({Key? key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    await context.read(authenticationViewModelProvider.notifier).signOut();

    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoutes.splashRoute, (route) => false);
    context.read(resetAppProvider.notifier).resetState();
    context.read(watchManViewModelProvider.notifier).bumpState();
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final watchLocale = watch(localeConfigProvider);
    return ElevatedButton(
      style: ButtonStyle(
        splashFactory: NoSplash.splashFactory,
      ),
      onPressed: () async {
        await _signOut(context);
      },
      child: Container(
        height: ScreenConstraintService(context).minHeight * 3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              AppColors.color15,
              AppColors.color16,
            ],
          ),
        ),
        child: Row(
          children: [
            Container(
              width: ScreenConstraintService(context).minWidth * 30,
              height: ScreenConstraintService(context).minHeight * 2,
              padding: EdgeInsets.only(
                left: ScreenConstraintService(context).minWidth * 3,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                watchLocale.signOut,
                style: TextStyle(
                  fontFamily: GoogleFonts.merriweather().fontFamily,
                  fontWeight: FontWeight.w500,
                  fontSize: ScreenConstraintService(context).minWidth * 2,
                  color: AppColors.color2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
