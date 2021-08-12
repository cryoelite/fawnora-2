import 'package:fawnora/app/home/widgets/DropDown/DropDownWidget.dart';
import 'package:fawnora/app/home/widgets/DropDown/viewmodels/DropDownViewModel.dart';
import 'package:fawnora/app/home/widgets/SearchBar/searchbar.dart';
import 'package:fawnora/common_widgets/ButtonIcon.dart';
import 'package:fawnora/common_widgets/viewmodels/ButtonIconViewModel.dart';
import 'package:fawnora/constants/AppColors.dart';
import 'package:fawnora/constants/ImageAssets.dart';
import 'package:fawnora/locale/LocaleConfig.dart';
import 'package:fawnora/models/LocaleTypeEnum.dart';
import 'package:fawnora/models/SpecieModel.dart';
import 'package:fawnora/models/SpecieTypeEnum.dart';
import 'package:fawnora/models/SpecieValueTypeEnum.dart';
import 'package:fawnora/services/LocalStorageService.dart';
import 'package:fawnora/services/ScreenConstraintService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AssistiveAddWidget extends StatelessWidget {
  const AssistiveAddWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment(
            0,
            -0.4,
          ),
          child: AnimatedContainer(
            duration: Duration(
              milliseconds: 300,
            ),
            alignment: Alignment.center,
            width: ScreenConstraintService(context).getConvertedWidth(234),
            height: ScreenConstraintService(context).minHeight * 14,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              gradient: LinearGradient(
                colors: [
                  AppColors.color8,
                  AppColors.color1,
                ],
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment(0, -0.7),
                  child: Container(
                    child: Consumer(
                      builder: (context, watch, _) {
                        final watchLocale = watch(localeProvider);

                        return Text(
                          watchLocale.localeObject.assistiveAddTitle,
                          style: TextStyle(
                            color: AppColors.color7,
                            fontFamily: GoogleFonts.merriweather().fontFamily,
                            fontSize:
                                ScreenConstraintService(context).minHeight *
                                    1.6,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0, -0.2),
                  child: Container(
                    width: ScreenConstraintService(context).minWidth * 24,
                    height: ScreenConstraintService(context).minHeight * 2.5,
                    child: SearchBar(),
                  ),
                ),
                Align(
                  alignment: Alignment(0, 0.7),
                  child: Container(
                    width: ScreenConstraintService(context).minWidth * 26,
                    height: ScreenConstraintService(context).minHeight * 4.5,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
