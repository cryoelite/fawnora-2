import 'package:fawnora/constants/AppColors.dart';
import 'package:fawnora/constants/ImageAssets.dart';
import 'package:fawnora/locale/LocaleConfig.dart';
import 'package:fawnora/services/ScreenConstraintService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutWidget extends ConsumerWidget {
  const AboutWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final watchLocale = watch(localeConfigProvider);
    return ElevatedButton(
      style: ButtonStyle(
        splashFactory: NoSplash.splashFactory,
      ),
      onPressed: () {
        showAboutDialog(
          context: context,
          applicationIcon: Image.asset(
            ImageAssets.launcherIcon,
            width: ScreenConstraintService(context).minWidth * 5,
            height: ScreenConstraintService(context).minHeight * 5,
          ),
          applicationName: 'Fawnora',
          applicationVersion: '1.0.0',
        );
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
                watchLocale.aboutApp,
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
