import 'package:auto_size_text/auto_size_text.dart';
import 'package:fawnora/app/home/routes/submissions/viewmodels/SubmissionsViewModel.dart';

import 'package:fawnora/constants/AppColors.dart';
import 'package:fawnora/constants/ImageAssets.dart';
import 'package:fawnora/locale/LocaleConfig.dart';
import 'package:fawnora/locale/hindi/hindiLocaleConstraints.dart';
import 'package:fawnora/models/SpecieTypeEnum.dart';
import 'package:fawnora/models/UserDataModel.dart';
import 'package:fawnora/services/ScreenConstraintService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SubmissionsWidget extends ConsumerWidget {
  List<Widget> _generateContainers(
      BuildContext context, List<UserDataModel> userData) {
    final List<Widget> itemList = [];
    for (final elem in userData) {
      final _container = Padding(
        padding: EdgeInsets.only(
            top: ScreenConstraintService(context).minHeight * 2),
        child: Container(
          width: ScreenConstraintService(context).minWidth * 30,
          height: ScreenConstraintService(context).minHeight * 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.color7,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(
                      ScreenConstraintService(context).minWidth * 0.4,
                    ),
                    child: Container(
                      width: ScreenConstraintService(context).minWidth * 5.3,
                      height: ScreenConstraintService(context).minHeight * 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          _getImageAsset(elem.specieType),
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: ScreenConstraintService(context).minWidth * 23,
                    height: ScreenConstraintService(context).minHeight * 3,
                    alignment: Alignment.bottomCenter,
                    child: AutoSizeText(
                      elem.specie,
                      style: TextStyle(
                        color: AppColors.color2,
                        fontFamily: GoogleFonts.sourceSansPro().fontFamily,
                        fontSize:
                            ScreenConstraintService(context).minHeight * 1.3,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: ScreenConstraintService(context).minWidth * 0.4,
                      left: ScreenConstraintService(context).minWidth * 1.2,
                    ),
                    child: Container(
                      width: ScreenConstraintService(context).minWidth * 11,
                      height: ScreenConstraintService(context).minHeight * 1.5,
                      child: AutoSizeText(
                        elem.transect.toString(),
                        style: TextStyle(
                          color: AppColors.color2,
                          fontFamily: GoogleFonts.sourceSansPro().fontFamily,
                          fontSize:
                              ScreenConstraintService(context).minHeight * 1,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: ScreenConstraintService(context).minWidth * 13,
                    height: ScreenConstraintService(context).minHeight * 1.5,
                    padding: EdgeInsets.only(
                        right: ScreenConstraintService(context).minWidth),
                    alignment: Alignment.centerRight,
                    child: AutoSizeText(
                      elem.subSpecie,
                      style: TextStyle(
                        color: AppColors.color2,
                        fontFamily: GoogleFonts.sourceSansPro().fontFamily,
                        fontSize:
                            ScreenConstraintService(context).minHeight * 1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      itemList.add(_container);
    }
    return itemList;
  }

  String _getImageAsset(String specieType) {
    String? asset;
    for (final elem in SpecieType.values) {
      if (elem.toString().toLowerCase().contains(specieType.toLowerCase())) {
        if (elem == SpecieType.DISTURBANCE ||
            elem == SpecieType.DISTURBANCE_HINDI) {
          asset = ImageAssets.disturbanceIcon;
        } else if (elem == SpecieType.FLORA || elem == SpecieType.FLORA_HINDI) {
          asset = ImageAssets.floraIcon;
        } else {
          asset = ImageAssets.faunaIcon;
        }
      }
    }
    if (asset == null) {
      final hindi = HindiLocaleConstraints();
      if (specieType == hindi.disturbance) {
        asset = ImageAssets.disturbanceIcon;
      } else if (specieType == hindi.flora) {
        asset = ImageAssets.floraIcon;
      } else if (specieType == hindi.fauna) {
        asset = ImageAssets.faunaIcon;
      } else {
        asset = ImageAssets.floraIcon;
      }
    }
    return asset;
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final watchLocale = watch(localeConfigProvider);
    return Container(
      width: ScreenConstraintService(context).maxWidth,
      height: ScreenConstraintService(context).maxHeight,
      padding: EdgeInsets.all(
        ScreenConstraintService(context).minWidth * 4,
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: ScreenConstraintService(context).minWidth * 30,
              height: ScreenConstraintService(context).minHeight * 4,
              alignment: Alignment.center,
              child: Text(
                watchLocale.submissionsTitle,
                style: TextStyle(
                  color: AppColors.color7,
                  fontFamily: GoogleFonts.merriweather().fontFamily,
                  fontSize: ScreenConstraintService(context).minHeight * 2,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 2.4),
            child: Container(
              width: ScreenConstraintService(context).minWidth * 33,
              height: ScreenConstraintService(context).minHeight * 35,
              child: FutureBuilder(
                future:
                    context.read(submissionViewModelProvider.notifier).init(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final watchSubmissions =
                        context.read(submissionViewModelProvider);
                    if (watchSubmissions == null) {
                      return Container();
                    } else {
                      return ListView(
                        physics: BouncingScrollPhysics(),
                        itemExtent:
                            ScreenConstraintService(context).minHeight * 8,
                        children: _generateContainers(
                          context,
                          watchSubmissions,
                        ),
                      );
                    }
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
