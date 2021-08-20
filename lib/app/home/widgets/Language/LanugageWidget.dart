import 'package:fawnora/app/home/widgets/Language/viewmodels/LanguageViewModel.dart';
import 'package:fawnora/constants/AppColors.dart';
import 'package:fawnora/locale/LocaleConfig.dart';
import 'package:fawnora/models/LocaleTypeEnum.dart';
import 'package:fawnora/services/ScreenConstraintService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguageWidget extends ConsumerWidget {
  const LanguageWidget({Key? key}) : super(key: key);

  List<Widget> _getListItems(BuildContext context) {
    return [
      for (final elem in LocaleType.values) _generateContainer(elem, context),
    ];
  }

  String _formatString(String enumVal) {
    final result = enumVal.toLowerCase();
    final index = result.indexOf('.') + 1;
    var convResult = result.replaceRange(0, index, '');
    convResult = convResult.replaceFirst(
        convResult.characters.first, convResult.characters.first.toUpperCase());
    return convResult;
  }

  Widget _generateContainer(LocaleType localeType, BuildContext context) {
    var convResult = _formatString(localeType.toString());
    return Container(
      alignment: Alignment.center,
      width: ScreenConstraintService(context).minWidth * 15,
      child: Text(
        convResult,
        style: TextStyle(
          fontFamily: GoogleFonts.sourceSansPro().fontFamily,
          fontSize: ScreenConstraintService(context).minHeight,
          color: AppColors.color2,
        ),
      ),
    );
  }

  List<bool> _getCurrentSelection(LocaleType selection) {
    return [
      for (var elem in LocaleType.values) elem == selection,
    ];
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final watchLocale = watch(localeConfigProvider);
    final watchLocaleType = watch(localeTypeProvider);
    final watchLanguageProvider = watch(languageModelProvider);
    return ElevatedButton(
      style: ButtonStyle(
        splashFactory: NoSplash.splashFactory,
      ),
      onPressed: () {
        context.read(languageModelProvider.notifier).newState =
            !watchLanguageProvider;
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: watchLanguageProvider
            ? ScreenConstraintService(context).minHeight * 6
            : ScreenConstraintService(context).minHeight * 3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              AppColors.color15,
              AppColors.color16,
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: ScreenConstraintService(context).minHeight * 0.5,
                  ),
                  child: Container(
                    width: ScreenConstraintService(context).minWidth * 30,
                    height: ScreenConstraintService(context).minHeight * 2,
                    padding: EdgeInsets.only(
                      left: ScreenConstraintService(context).minWidth * 3,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      watchLocale.language,
                      style: TextStyle(
                        fontFamily: GoogleFonts.merriweather().fontFamily,
                        fontWeight: FontWeight.w500,
                        fontSize: ScreenConstraintService(context).minWidth * 2,
                        color: AppColors.color2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            AnimatedContainer(
              padding: EdgeInsets.only(
                top: ScreenConstraintService(context).minHeight * 0.5,
              ),
              duration: Duration(milliseconds: 300),
              height: watchLanguageProvider
                  ? ScreenConstraintService(context).minHeight * 2
                  : 0,
              child: Visibility(
                visible: watchLanguageProvider,
                child: IgnorePointer(
                  ignoring: !watchLanguageProvider,
                  child: ToggleButtons(
                    renderBorder: false,
                    constraints: BoxConstraints(
                      maxWidth: ScreenConstraintService(context).minWidth * 15,
                    ),
                    onPressed: (index) {
                      final value = LocaleType.values[index];
                      context
                          .read(languageModelProvider.notifier)
                          .changeLocale(value);
                    },
                    children: _getListItems(context),
                    isSelected: _getCurrentSelection(
                      watchLocaleType,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
