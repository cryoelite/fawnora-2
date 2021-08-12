import 'package:fawnora/common_widgets/CustomTextField.dart';
import 'package:fawnora/constants/AppColors.dart';
import 'package:fawnora/locale/LocaleConfig.dart';
import 'package:fawnora/services/ScreenConstraintService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchBar extends ConsumerWidget {
  final searchController = TextEditingController();
  SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final watchLocale = watch(localeProvider);

    return Container(
      decoration: BoxDecoration(
          color: AppColors.color2, borderRadius: BorderRadius.circular(16)),
      padding: EdgeInsets.only(
        left: ScreenConstraintService(context).minWidth * 2,
      ),
      width: ScreenConstraintService(context).getConvertedWidth(250),
      height: ScreenConstraintService(context).minHeight * 5,
      child: TextField(
        autocorrect: false,
        autofocus: false,
        controller: searchController,
        cursorColor: AppColors.color7,
        inputFormatters: [
          FilteringTextInputFormatter.singleLineFormatter,
          LengthLimitingTextInputFormatter(15),
        ],
        keyboardType: TextInputType.text,
        maxLines: 1,
        style: TextStyle(
          color: AppColors.color7,
          fontSize: ScreenConstraintService(context).minHeight * 1.5,
          fontFamily: GoogleFonts.sourceSansPro().fontFamily,
        ),
        decoration: InputDecoration(
          hintText: watchLocale.localeObject.searchSpecie,
          contentPadding: EdgeInsets.only(
            left: ScreenConstraintService(context).minWidth * 3,
            top: -ScreenConstraintService(context).minHeight * 0.8,
          ),
          hintStyle: TextStyle(
            color: AppColors.color7,
            fontSize: ScreenConstraintService(context).minHeight * 1.2,
            fontFamily: GoogleFonts.sourceSansPro().fontFamily,
            fontWeight: FontWeight.w500,
          ),
        ),
        onChanged: (val) {},
      ),
    );
  }
}
