import 'package:fawnora/constants/AppColors.dart';
import 'package:fawnora/services/ScreenConstraintService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final List<TextInputFormatter> inputFormatters;
  final List<String> autofillHints;
  final String hintText;
  final bool obscure;
  final String? errorText;

  CustomTextField(this.textEditingController, this.textInputType,
      this.inputFormatters, this.autofillHints, this.hintText,
      {this.obscure = false, this.errorText});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenConstraintService(context).getConvertedWidth(250),
      height: ScreenConstraintService(context).minHeight * 5,
      child: TextField(
        autocorrect: false,
        autofillHints: autofillHints,
        autofocus: false,
        controller: textEditingController,
        cursorColor: AppColors.color7,
        inputFormatters: inputFormatters,
        keyboardType: textInputType,
        obscureText: obscure,
        maxLines: 1,
        style: TextStyle(
          color: AppColors.color7,
          fontSize: ScreenConstraintService(context).minHeight * 1.5,
          fontFamily: GoogleFonts.sourceSansPro().fontFamily,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          errorMaxLines: 2,
          errorText: errorText,
          errorStyle: TextStyle(
            fontFamily: GoogleFonts.sourceSansPro().fontFamily,
            fontSize: ScreenConstraintService(context).minWidth * 1.5,
          ),
          hintStyle: TextStyle(
            color: AppColors.color7.withOpacity(0.6),
            fontSize: ScreenConstraintService(context).minHeight * 1.2,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.color10,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.color7,
            ),
          ),
        ),
      ),
    );
  }
}
