import 'package:fawnora/app/home/widgets/DropDown/DropDownWidget.dart';
import 'package:fawnora/app/home/widgets/DropDown/viewmodels/DropDownViewModel.dart';
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

class QuickAddWidget extends StatelessWidget {
  const QuickAddWidget({Key? key}) : super(key: key);

  int _getUid(BuildContext context) {
    return context.read(activeSpecieTypeIconIdProvider.notifier).uid;
  }

  Widget _getSpecieIcons(
    BuildContext context,
    LocaleConfig watchLocale,
  ) {
    final SpecieModel _specieModel1;
    final SpecieModel _specieModel2;
    final SpecieModel _specieModel3;

    _specieModel1 = SpecieModel(
      watchLocale.localeObject.flora,
      ImageAssets.floraIcon,
      SpecieValueType.SPECIETYPE,
      _getUid(context),
      specieType: watchLocale.localeType == LocaleType.ENGLISH
          ? SpecieType.FLORA
          : SpecieType.FLORA_HINDI,
    );
    _specieModel2 = SpecieModel(
      watchLocale.localeObject.fauna,
      ImageAssets.faunaIcon,
      SpecieValueType.SPECIETYPE,
      _getUid(context),
      specieType: watchLocale.localeType == LocaleType.ENGLISH
          ? SpecieType.FAUNA
          : SpecieType.FAUNA_HINDI,
    );
    _specieModel3 = SpecieModel(
      watchLocale.localeObject.disturbance,
      ImageAssets.disturbanceIcon,
      SpecieValueType.SPECIETYPE,
      _getUid(context),
      specieType: watchLocale.localeType == LocaleType.ENGLISH
          ? SpecieType.DISTURBANCE
          : SpecieType.DISTURBANCE_HINDI,
    );

    return Container(
      width: ScreenConstraintService(context).minWidth * 26,
      height: ScreenConstraintService(context).minHeight * 4.5,
      child: ListView(
        scrollDirection: Axis.horizontal,
        itemExtent: ScreenConstraintService(context).minWidth * 8.5,
        children: [
          ButtonIcon(
            _specieModel1,
          ),
          ButtonIcon(
            _specieModel2,
          ),
          ButtonIcon(
            _specieModel3,
          ),
        ],
      ),
    );
  }

  Future<Widget> _getSubSpecieIcons(
    BuildContext context,
    ScopedReader watch,
  ) async {
    final watchSpecie = watch(activeSpecieTypeIconIdProvider);
    final watchLocalStorage = watch(localStorageProvider);
    final watchLocale = watch(localeProvider);
    final List<ButtonIcon> buttonIcons;
    if (watchSpecie == null) {
      if (watchLocale.localeType == LocaleType.HINDI) {
        final data = await watchLocalStorage
            .retrieveSubspecieData(SpecieType.FLORA_HINDI);
        buttonIcons = _getButtonIcons(
            data, context, SpecieType.FLORA_HINDI, watchLocale.localeType);
      } else if (watchLocale.localeType == LocaleType.ENGLISH) {
        final data =
            await watchLocalStorage.retrieveSubspecieData(SpecieType.FLORA);
        buttonIcons = _getButtonIcons(
            data, context, SpecieType.FLORA, watchLocale.localeType);
      } else {
        final data =
            await watchLocalStorage.retrieveSubspecieData(SpecieType.FLORA);
        buttonIcons = _getButtonIcons(
            data, context, SpecieType.FLORA, watchLocale.localeType);
      }
    } else {
      final data =
          await watchLocalStorage.retrieveSubspecieData(watchSpecie.specieType);
      buttonIcons = _getButtonIcons(
          data, context, watchSpecie.specieType, watchLocale.localeType);
    }
    return Container(
      width: ScreenConstraintService(context).minWidth * 26,
      height: ScreenConstraintService(context).minHeight * 4.5,
      child: ListView(
        scrollDirection: Axis.horizontal,
        itemExtent: ScreenConstraintService(context).minWidth * 8.5,
        children: buttonIcons,
      ),
    );
  }

  List<ButtonIcon> _getButtonIcons(Map<String, List<String>> data,
      BuildContext context, SpecieType type, LocaleType localeType) {
    final listData = data.keys.map(
      (e) => ButtonIcon(
        SpecieModel(
          e,
          _getIconAsset(e, type, localeType),
          SpecieValueType.SUBSPECIE,
          _getUid(context),
          specieType: type,
        ),
      ),
    );
    return listData.toList();
  }

  String _getIconAsset(String name, SpecieType type, LocaleType localeType) {
    String assetName;
    if (type == SpecieType.DISTURBANCE ||
        type == SpecieType.DISTURBANCE_HINDI) {
      assetName = ImageAssets.disturbanceIcon;
    } else if (type == SpecieType.FLORA || type == SpecieType.FLORA_HINDI) {
      assetName = ImageAssets.disturbanceIcon;
    } else {
      assetName = ImageAssets.faunaIcon;
    }

    if (localeType == LocaleType.ENGLISH) {
      final engName = ImageAssets.englishMapping[name];
      if (engName != null) {
        assetName = engName;
      }
    } else if (localeType == LocaleType.HINDI) {
      final hindiName = ImageAssets.hindiMapping[name];
      if (hindiName != null) {
        assetName = hindiName;
      }
    } else {
      final engName = ImageAssets.englishMapping[name];
      if (engName != null) {
        assetName = engName;
      }
    }
    return assetName;
  }

  Future<List<DropdownMenuItem<String>>> _getSubSpecieList(
      SpecieModel specieModel,
      LocalStorageService localStorageService,
      BuildContext context) async {
    final data =
        await localStorageService.retrieveSubspecieData(specieModel.specieType);
    final listItems = data[specieModel.name];
    if (listItems == null)
      throw Exception("List items don't exist in database!");
    final dropDownItems = listItems
        .map(
          (e) => DropdownMenuItem<String>(
            child: Text(
              e,
              style: TextStyle(
                color: AppColors.color7,
                fontFamily: GoogleFonts.sourceSansPro().fontFamily,
                fontSize: ScreenConstraintService(context).minWidth * 2,
              ),
            ),
            value: e,
          ),
        )
        .toList();
    return dropDownItems;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment(
            0,
            -0.4,
          ),
          child: Container(
            alignment: Alignment.center,
            width: ScreenConstraintService(context).getConvertedWidth(234),
            height: ScreenConstraintService(context).minHeight * 23,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
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
                  alignment: Alignment(0, -0.9),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: ScreenConstraintService(context).minWidth * 10,
                        height: ScreenConstraintService(context).minHeight * 5,
                        child: Image.asset(
                          ImageAssets.bookIcon,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      Container(
                        child: Consumer(
                          builder: (context, watch, _) {
                            final watchLocale = watch(localeProvider);

                            return Text(
                              watchLocale.localeObject.quickAddTitle,
                              style: TextStyle(
                                color: AppColors.color7,
                                fontFamily:
                                    GoogleFonts.merriweather().fontFamily,
                                fontSize:
                                    ScreenConstraintService(context).minHeight *
                                        1.6,
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment(0, -0.1),
                  child: Consumer(builder: (context, watch, _) {
                    final watchLocale = watch(localeProvider);
                    return _getSpecieIcons(context, watchLocale);
                  }),
                ),
                Align(
                  alignment: Alignment(0, 0.45),
                  child: Consumer(builder: (context, watch, _) {
                    return FutureBuilder(
                        future: _getSubSpecieIcons(context, watch),
                        builder: (context, AsyncSnapshot<Widget> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return snapshot.data ?? Container();
                          } else {
                            return Container();
                          }
                        });
                  }),
                ),
                Align(
                  alignment: Alignment(0, 0.8),
                  child: Container(
                    width: ScreenConstraintService(context).minWidth * 24,
                    height: ScreenConstraintService(context).minHeight * 2.5,
                    child: Consumer(builder: (context, watch, _) {
                      final watchSubSpecie =
                          watch(activeSubSpecieIconIdProvider);
                      final watchLocalStorage = watch(localStorageProvider);
                      final watchDropDown = watch(dropDownValueProvider);
                      if (watchSubSpecie == null) {
                        watchDropDown.value = null;
                        return DropDownWidget(null);
                      } else {
                        return FutureBuilder(
                            future: _getSubSpecieList(
                                watchSubSpecie, watchLocalStorage, context),
                            builder: (context,
                                AsyncSnapshot<List<DropdownMenuItem<String>>>
                                    snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return DropDownWidget(snapshot.data);
                              } else {
                                return DropDownWidget(null);
                              }
                            });
                      }
                    }),
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
