import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import 'package:fawnora/app/home/routes/compass/CompassWidget.dart';
import 'package:fawnora/app/home/routes/submissions/SubmissionsWidget.dart';
import 'package:fawnora/app/home/routes/track/TrackWidget.dart';
import 'package:fawnora/app/home/routes/track/viewmodels/ToShowAssistiveAddWidget.dart';
import 'package:fawnora/app/home/routes/track/viewmodels/ToShowQuickAddViewModel.dart';
import 'package:fawnora/app/home/viewmodels/ButtonTrackerViewModel.dart';
import 'package:fawnora/app/home/viewmodels/homeViewModel.dart';
import 'package:fawnora/app/home/widgets/DropDown/viewmodels/DropDownViewModel.dart';
import 'package:fawnora/app/home/widgets/anim/CenterButton.dart';
import 'package:fawnora/app/home/widgets/viewmodels/submitDataViewModel.dart';
import 'package:fawnora/common_widgets/viewmodels/ButtonIconViewModel.dart';
import 'package:fawnora/constants/AppColors.dart';
import 'package:fawnora/constants/HomeRouteConstants.dart';
import 'package:fawnora/locale/LocaleConfig.dart';
import 'package:fawnora/services/ScreenConstraintService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeRoute extends StatelessWidget {
  final iconsList = <IconData>[
    Icons.folder_special_outlined,
    Icons.compass_calibration_outlined,
  ];

  Consumer visibleChildWidget(Widget child, int index) {
    return Consumer(
        child: child,
        builder: (context, watch, conChild) {
          final watchHomeModel = watch(homeRouteViewModelProvider);

          return Visibility(
            visible: index == watchHomeModel,
            child: IgnorePointer(
              child: conChild,
              ignoring: index != watchHomeModel,
            ),
            maintainAnimation: true,
            maintainSize: true,
            maintainState: true,
          );
        });
  }

  Future<void> changeButtonState(BuildContext context) async {
    final watchSpecie = context.read(activeSpecieTypeIconIdProvider);
    final watchSubSpecie = context.read(activeSubSpecieIconIdProvider);
    final watchDropdown = context.read(dropDownValueProvider);
    if (watchSpecie != null &&
        watchSubSpecie != null &&
        watchDropdown.value != null) {
      final watchSubmitStatus = context.read(submitDataProvider.notifier);
      final result = await watchSubmitStatus.quickAddSubmit();
      _showSnackBar(result, context);

      _resetState(context);
    } else {
      _resetState(context);

      await context.read(buttonTrackerProvider.notifier).toggleState();
    }
  }

  void _showSnackBar(String result, BuildContext context) {
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

  void _resetState(BuildContext context) {
    context.read(homeRouteViewModelProvider.notifier).newState =
        HomeRouteConstants.homeVal;
    context.read(toShowQuickAddWidgetProvider.notifier).newState = false;
    context.read(toShowAssistiveAddWidgetProvider.notifier).newState = false;
    context.read(activeSpecieTypeIconIdProvider.notifier).resetState();
    context.read(activeSubSpecieIconIdProvider.notifier).resetState();
    context.read(dropDownValueProvider.notifier).value = null;
  }

  Widget _showLeadingAppBarIcon(ScopedReader watch, BuildContext context) {
    final watchHomeModel = watch(homeRouteViewModelProvider);
    final watchQuickAdd = watch(toShowQuickAddWidgetProvider);
    final watchAssistiveAdd = watch(toShowAssistiveAddWidgetProvider);
    if (watchHomeModel != HomeRouteConstants.homeVal ||
        watchQuickAdd ||
        watchAssistiveAdd)
      return IconButton(
        onPressed: () {
          _resetState(context);
        },
        splashRadius: 1,
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: ScreenConstraintService(context).minHeight * 1.5,
        ),
      );
    else
      return Container();
  }

  String _textSelector(ScopedReader watch) {
    final localeObject = watch(localeProvider).localeObject;
    final watchHomeModel = watch(homeRouteViewModelProvider);
    final watchQuickAdd = watch(toShowQuickAddWidgetProvider);
    final watchAssistiveAdd = watch(toShowAssistiveAddWidgetProvider);

    if (watchHomeModel == HomeRouteConstants.compassVal)
      return localeObject.compassTitle;
    else if (watchHomeModel == HomeRouteConstants.submissionsVal)
      return localeObject.submissionsTitle;
    else {
      if (watchQuickAdd) {
        return localeObject.quickAddTitle;
      } else if (watchAssistiveAdd) {
        return localeObject.assistiveAddTitle;
      } else {
        return localeObject.homeTitle;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await changeButtonState(context);
        },
        child: CenterButton(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Consumer(builder: (context, watch, _) {
        final watchHomeModel = watch(homeRouteViewModelProvider);
        return AnimatedBottomNavigationBar(
            icons: iconsList,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.softEdge,
            activeIndex: watchHomeModel,
            leftCornerRadius: 32,
            rightCornerRadius: 32,
            backgroundColor: AppColors.color8,
            activeColor: AppColors.color3,
            inactiveColor: AppColors.color12,
            height: ScreenConstraintService(context).minHeight * 3,
            onTap: (val) {
              context.read(homeRouteViewModelProvider.notifier).newState = val;
            });
      }),
      appBar: PreferredSize(
        preferredSize: Size(
          AppBar().preferredSize.width,
          ScreenConstraintService(context).minHeight * 3,
        ),
        child: Consumer(builder: (context, watch, _) {
          return AppBar(
            leading: _showLeadingAppBarIcon(watch, context),
            leadingWidth: ScreenConstraintService(context).minHeight * 2,
            backgroundColor: AppColors.color1,
            primary: true,
            toolbarHeight: ScreenConstraintService(context).minHeight * 3,
            centerTitle: true,
            title: Text(
              _textSelector(watch),
              style: TextStyle(
                fontFamily: GoogleFonts.merriweather().fontFamily,
                fontSize: ScreenConstraintService(context).minHeight * 1.7,
              ),
            ),
          );
        }),
      ),
      backgroundColor: AppColors.color2,
      body: SafeArea(
        child: Stack(
          children: [
            visibleChildWidget(TrackWidget(), HomeRouteConstants.homeVal),
            visibleChildWidget(
                SubmissionsWidget(), HomeRouteConstants.submissionsVal),
            visibleChildWidget(CompassWidget(), HomeRouteConstants.compassVal),
          ],
        ),
      ),
    );
  }
}
