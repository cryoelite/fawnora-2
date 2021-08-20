import 'package:fawnora/app/home/widgets/DropDown/viewmodels/DropDownViewModel.dart';
import 'package:fawnora/constants/AppColors.dart';
import 'package:fawnora/locale/LocaleConfig.dart';
import 'package:fawnora/services/ScreenConstraintService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class DropDownWidget extends StatelessWidget {
  final List<DropdownMenuItem<String>>? dropDownItems;

  DropDownWidget(this.dropDownItems, {Key? key}) : super(key: key);

  void _onChanged(String? val, ValueNotifier<String?> valueNotifier) {
    valueNotifier.value = val;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.color2,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.only(
        left: ScreenConstraintService(context).minWidth,
        right: ScreenConstraintService(context).minWidth,
      ),
      child: Consumer(builder: (context, watch, _) {
        final watchDropDownProvider = watch(dropDownValueProvider);
        final watchLocale = watch(localeConfigProvider);
        return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            items: dropDownItems,
            hint: Text(
              watchLocale.selectSpecie,
              style: TextStyle(
                color: AppColors.color7,
                fontFamily: GoogleFonts.sourceSansPro().fontFamily,
                fontSize: ScreenConstraintService(context).minWidth * 2,
              ),
            ),
            dropdownColor: AppColors.color2,
            isExpanded: true,
            value: watchDropDownProvider.value,
            onChanged: (String? val) {
              _onChanged(val, watchDropDownProvider);
            },
          ),
        );
      }),
    );
  }
}
