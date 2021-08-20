import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import 'package:fawnora/app/home/routes/settings/SettingsWidget.dart';
import 'package:fawnora/app/home/routes/submissions/SubmissionsWidget.dart';
import 'package:fawnora/app/home/routes/track/TrackWidget.dart';
import 'package:fawnora/app/home/routes/track/viewmodels/ToShowAssistiveAddWidget.dart';
import 'package:fawnora/app/home/routes/track/viewmodels/ToShowQuickAddViewModel.dart';
import 'package:fawnora/app/home/viewmodels/ButtonTrackerViewModel.dart';
import 'package:fawnora/app/home/viewmodels/homeViewModel.dart';
import 'package:fawnora/app/home/widgets/AssistiveAdd/viewmodels/selectionStatusViewModel.dart';
import 'package:fawnora/app/home/widgets/DropDown/viewmodels/DropDownViewModel.dart';
import 'package:fawnora/app/home/widgets/SearchBar/viewmodels/searchBarViewModel.dart';
import 'package:fawnora/app/home/widgets/anim/CenterButton.dart';
import 'package:fawnora/app/home/widgets/viewmodels/submitDataViewModel.dart';
import 'package:fawnora/common_widgets/viewmodels/ButtonIconViewModel.dart';
import 'package:fawnora/constants/AppColors.dart';
import 'package:fawnora/constants/HomeRouteConstants.dart';
import 'package:fawnora/services/ScreenConstraintService.dart';
import 'package:fawnora/services/SystemOverlayOverrides.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeRoute extends StatelessWidget {
  final iconsList = <IconData>[
    Icons.folder_special_outlined,
    Icons.settings,
  ];

  Widget visibleChildWidget(Widget child, int index) {
    return Consumer(
      child: child,
      builder: (context, watch, _child) {
        final watchHomeModel = watch(homeRouteViewModelProvider);
        return Visibility(
          visible: index == watchHomeModel,
          child: IgnorePointer(
            child: _child,
            ignoring: index != watchHomeModel,
          ),
          maintainAnimation: true,
          maintainSize: true,
          maintainState: true,
        );
      },
    );
  }

  Future<void> changeButtonState(BuildContext context) async {
    final watchSpecie = context.read(activeSpecieTypeIconIdProvider);
    final watchSubSpecie = context.read(activeSubSpecieIconIdProvider);
    final watchDropdown = context.read(dropDownValueProvider);
    final watchAssistive = context.read(selectionStatusProvider);
    final watchSubmitStatus = context.read(submitDataProvider.notifier);
    if (watchSubmitStatus.isBusy == null) {
      if (watchSpecie != null &&
          watchSubSpecie != null &&
          watchDropdown.value != null) {
        final result = await watchSubmitStatus.quickAddSubmit();
        _showSnackBar(result, context);

        _resetState(context);
      } else if (watchAssistive != null) {
        final watchSubmitStatus = context.read(submitDataProvider.notifier);
        final result = await watchSubmitStatus.assistiveAddSubmit();
        _showSnackBar(result, context);

        _resetState(context);
      } else {
        _resetState(context);

        await context.read(buttonTrackerProvider.notifier).toggleState();
      }
    } else {
      _showSnackBar(watchSubmitStatus.isBusy!, context);
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
    context.read(selectionStatusProvider.notifier).newState = null;
    context.read(searchBarProvider.notifier).newState = null;
    context.read(activeSpecieTypeIconIdProvider.notifier).resetState();
    context.read(activeSubSpecieIconIdProvider.notifier).resetState();
    context.read(dropDownValueProvider.notifier).value = null;
  }

  bool _onWillPop(BuildContext context) {
    final watchHomeModel = context.read(homeRouteViewModelProvider);
    final watchQuickAdd = context.read(toShowQuickAddWidgetProvider);
    final watchAssistiveAdd = context.read(toShowAssistiveAddWidgetProvider);
    if (watchHomeModel != HomeRouteConstants.homeVal ||
        watchQuickAdd ||
        watchAssistiveAdd) {
      _resetState(context);
    }
    return false;
  }

  /*  String _textSelector(ScopedReader watch) {
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
  } */

  @override
  Widget build(BuildContext context) {
    final theme = SystemOverlayOverrides.systemOverlayOverrides;
    SystemChrome.setSystemUIOverlayStyle(theme);

    return WillPopScope(
      onWillPop: () async {
        return _onWillPop(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                context.read(homeRouteViewModelProvider.notifier).newState =
                    val;
              });
        }),
        /* appBar: PreferredSize(
        preferredSize: Size(
          AppBar().preferredSize.width,
          ScreenConstraintService(context).minHeight * 3,
        ),
        child: Consumer(
          builder: (context, watch, _) {
            return AppBar(
              leading: _showLeadingAppBarIcon(watch, context), // which is now _onWillPop().
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
          },
        ),
      ), */

        backgroundColor: AppColors.color2,
        body: SafeArea(
          child: Stack(
            children: [
              visibleChildWidget(TrackWidget(), HomeRouteConstants.homeVal),
              visibleChildWidget(
                  SubmissionsWidget(), HomeRouteConstants.submissionsVal),
              visibleChildWidget(
                  SettingsWidget(), HomeRouteConstants.compassVal),
            ],
          ),
        ),
      ),
    );
  }
}
