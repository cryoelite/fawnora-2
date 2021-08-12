import 'package:fawnora/app/home/routes/track/viewmodels/ToShowQuickAddViewModel.dart';
import 'package:fawnora/constants/AppColors.dart';
import 'package:fawnora/constants/ImageAssets.dart';
import 'package:fawnora/locale/LocaleConfig.dart';
import 'package:fawnora/services/ScreenConstraintService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class MiniQuickAddWidget extends StatelessWidget {
  const MiniQuickAddWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Container(
        color: AppColors.color11,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: ScreenConstraintService(context).minWidth * 30,
              height: ScreenConstraintService(context).minHeight * 8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.color5,
                        AppColors.color6,
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        child: Container(
                          height:
                              ScreenConstraintService(context).minHeight * 5,
                          width: ScreenConstraintService(context).minWidth * 10,
                          child: Image.asset(
                            ImageAssets.bookIcon,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer(
                  builder: (context, watch, _) {
                    final watchLocale = watch(localeProvider);
                    return Padding(
                      padding: EdgeInsets.only(
                        left: ScreenConstraintService(context).minWidth,
                      ),
                      child: Text(
                        watchLocale.localeObject.quickAddTitle,
                        style: TextStyle(
                          fontFamily: GoogleFonts.sourceSansPro().fontFamily,
                          color: AppColors.color7,
                          fontSize:
                              ScreenConstraintService(context).minHeight * 1.6,
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: ScreenConstraintService(context).minHeight * 0.2,
                    right: ScreenConstraintService(context).minWidth,
                  ),
                  child: Icon(
                    Icons.navigate_next_rounded,
                    size: ScreenConstraintService(context).minHeight * 2,
                  ),
                )
              ],
            )
          ],
        ),
      ),
      onPressed: () {
        context.read(toShowQuickAddWidgetProvider.notifier).newState = true;
      },
      style: ElevatedButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
