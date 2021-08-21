import 'package:fawnora/constants/AppColors.dart';
import 'package:fawnora/services/ScreenConstraintService.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowSnackBar {
  void showSnackBar(String result, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(
        result,
        style: TextStyle(
          fontFamily: GoogleFonts.sourceSansPro().fontFamily,
          fontSize: ScreenConstraintService(context).minWidth * 1.6,
          color: AppColors.color2,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: AppColors.color12,
      width: ScreenConstraintService(context).minWidth * 20,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
