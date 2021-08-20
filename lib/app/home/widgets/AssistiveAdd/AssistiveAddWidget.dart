import 'package:fawnora/app/home/widgets/AssistiveAdd/GridViewBuilder.dart';
import 'package:fawnora/app/home/widgets/AssistiveAdd/viewmodels/SpecieModelBuilderViewModel.dart';
import 'package:fawnora/app/home/widgets/SearchBar/searchbar.dart';
import 'package:fawnora/app/home/widgets/SearchBar/viewmodels/searchBarViewModel.dart';
import 'package:fawnora/constants/AppColors.dart';
import 'package:fawnora/locale/LocaleConfig.dart';
import 'package:fawnora/models/SpecieModel.dart';

import 'package:fawnora/services/ScreenConstraintService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AssistiveAddWidget extends StatelessWidget {
  AssistiveAddWidget({Key? key}) : super(key: key);

  List<SpecieModel>? _getSearchQueryItems(
      BuildContext context, String? query, List<SpecieModel>? items) {
    if (query == null) {
      return items;
    } else {
      if (items == null) {
        return null;
      } else {
        List<SpecieModel>? searchItems;
        for (final item in items) {
          if (_isItemFound(item, query)) {
            if (searchItems == null) {
              searchItems = [];
            }
            searchItems.add(item);
          }
        }
        return searchItems;
      }
    }
  }

  bool _isItemFound(SpecieModel item, String query) {
    if (item.name.toLowerCase().contains(query)) {
      return true;
    } else if (item.specieType.toString().toLowerCase().contains(query)) {
      return true;
    } else if (item.subSpecie.toString().toLowerCase().contains(query)) {
      return true;
    } else {
      return false;
    }
  }

  Widget _noResultFound(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(
        left: ScreenConstraintService(context).minWidth * 2,
        right: ScreenConstraintService(context).minWidth * 2,
      ),
      child: Container(
        width: ScreenConstraintService(context).minWidth * 38,
        height: ScreenConstraintService(context).minHeight * 4,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: GoogleFonts.sourceSansPro().fontFamily,
            fontSize: ScreenConstraintService(context).minHeight,
            color: AppColors.color7,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenConstraintService(context).minHeight * 42,
      width: ScreenConstraintService(context).maxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(
              ScreenConstraintService(context).minHeight,
            ),
            child: Container(
              width: ScreenConstraintService(context).maxWidth,
              height: ScreenConstraintService(context).minHeight * 3,
              child: SearchBar(),
            ),
          ),
          Consumer(builder: (context, watch, child) {
            final watchSearch = watch(specieModelBuilderProvider);
            return FutureBuilder(
              future:
                  context.read(specieModelBuilderProvider.notifier).initList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final watchQueryString = watch(searchBarProvider);
                  final items = _getSearchQueryItems(
                    context,
                    watchQueryString,
                    watchSearch,
                  );
                  final watchLocale = watch(localeConfigProvider);
                  if (items == null) {
                    return _noResultFound(
                      context,
                      watchLocale.itemNotFound(watchQueryString ?? ""),
                    );
                  } else {
                    return GridViewBuilder(items);
                  }
                } else {
                  return Container();
                }
              },
            );
          }),
          /* Align(
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
                      child: Consumer(builder: (context, watch, child) {
                        final watchSearchProvider =
                            watch(searchBarProvider.notifier);
                        return FutureBuilder(
                          future: watchSearchProvider.initList(),
                          builder: (context, snapshot) {
                            return ListView(
                              children: [
                                Container(
                                  color: Colors.red,
                                ),
                              ],
                            );
                          },
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ) */
        ],
      ),
    );
  }
}
