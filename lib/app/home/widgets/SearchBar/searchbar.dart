import 'package:fawnora/app/home/widgets/SearchBar/viewmodels/searchBarViewModel.dart';
import 'package:fawnora/constants/AppColors.dart';
import 'package:fawnora/locale/LocaleConfig.dart';
import 'package:fawnora/services/ScreenConstraintService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class SearchBar extends StatelessWidget {
  final searchController = TextEditingController();
  SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      final watchLocale = watch(localeConfigProvider);

      return Container(
        width: ScreenConstraintService(context).getConvertedWidth(250),
        child: FloatingSearchBar(
          backgroundColor: AppColors.color8,
          backdropColor: Colors.transparent,
          onQueryChanged: (val) {
            if (val.isEmpty) {
              context.read(searchBarProvider.notifier).newState = null;
            }
          },
          onSubmitted: (val) {
            context.read(searchBarProvider.notifier).newState =
                val.toLowerCase();
          },
          height: ScreenConstraintService(context).minHeight * 2.5,
          transitionDuration: const Duration(milliseconds: 800),
          transitionCurve: Curves.easeInOut,
          physics: const BouncingScrollPhysics(),
          scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
          transition: CircularFloatingSearchBarTransition(),
          actions: [
            FloatingSearchBarAction(
              showIfOpened: false,
              child: CircularButton(
                icon: const Icon(
                  Icons.search,
                  color: AppColors.color7,
                ),
                onPressed: () {},
              ),
            ),
            FloatingSearchBarAction.searchToClear(
              showIfClosed: false,
              color: AppColors.color7,
            ),
          ],
          hint: watchLocale.searchSpecie,
          hintStyle: TextStyle(
            color: AppColors.color7,
            fontSize: ScreenConstraintService(context).minHeight * 1.2,
            fontFamily: GoogleFonts.sourceSansPro().fontFamily,
            fontWeight: FontWeight.w500,
          ),
          queryStyle: TextStyle(
            color: AppColors.color7,
            fontSize: ScreenConstraintService(context).minHeight * 1.2,
            fontFamily: GoogleFonts.sourceSansPro().fontFamily,
          ),
          builder: (context, transition) {
            return Container();
          },
        ),
        /* TextField(
            autocorrect: false,
            autofocus: false,
            controller: searchController,
            cursorColor: AppColors.color8,
            inputFormatters: [
              FilteringTextInputFormatter.singleLineFormatter,
              LengthLimitingTextInputFormatter(15),
            ],
            keyboardType: TextInputType.text,
            maxLines: 1,
            style: TextStyle(
              color: AppColors.color8,
              fontSize: ScreenConstraintService(context).minHeight * 1.5,
              fontFamily: GoogleFonts.sourceSansPro().fontFamily,
            ),
            decoration: InputDecoration(
              suffix: IconButton(
                padding: EdgeInsets.only(top: 10),
                icon: Icon(
                  Icons.search,
                ),
                onPressed: () {},
              ),
              hintStyle: TextStyle(
                color: AppColors.color8,
                fontSize: ScreenConstraintService(context).minHeight * 1.2,
                fontFamily: GoogleFonts.sourceSansPro().fontFamily,
                fontWeight: FontWeight.w500,
              ),
            ),
            onChanged: (val) {},
          ), */
      );
    });
  }
}
