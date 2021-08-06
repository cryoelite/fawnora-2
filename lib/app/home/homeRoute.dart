import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import 'package:fawnora/app/home/routes/compass/CompassWidget.dart';
import 'package:fawnora/app/home/routes/submissions/SubmissionsWidget.dart';
import 'package:fawnora/app/home/routes/track/TrackWidget.dart';
import 'package:fawnora/app/home/viewmodels/ButtonTrackerViewModel.dart';
import 'package:fawnora/app/home/viewmodels/homeViewModel.dart';
import 'package:fawnora/app/home/widgets/anim/StartStopButtonWidget.dart';
import 'package:fawnora/constants/AnimAssets.dart';
import 'package:fawnora/constants/AppColors.dart';
import 'package:fawnora/constants/HomeRouteConstants.dart';
import 'package:fawnora/constants/SystemOverlayOverrides.dart';
import 'package:fawnora/locale/LocaleConfig.dart';
import 'package:fawnora/locale/localeConstraints.dart';
import 'package:fawnora/services/ScreenConstraintService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';

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
          final watchButton = watch(buttonTrackerProvider);

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

  void changeButtonState(BuildContext context) {
    context.read(homeRouteViewModelProvider.notifier).newState =
        HomeRouteConstants.homeVal;
    context.read(buttonTrackerProvider.notifier).toggleState();
  }

  Widget _showLeadingAppBarIcon(int watchHomeModel, BuildContext context) {
    if (watchHomeModel != HomeRouteConstants.homeVal)
      return IconButton(
        onPressed: () {
          context.read(homeRouteViewModelProvider.notifier).newState =
              HomeRouteConstants.homeVal;
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

  String _textSelector(LocaleConstraints localeObject, int watchHomeModel) {
    if (watchHomeModel == HomeRouteConstants.compassVal)
      return localeObject.compassTitle;
    else if (watchHomeModel == HomeRouteConstants.submissionsVal)
      return localeObject.submissionsTitle;
    else
      return localeObject.homeTitle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          changeButtonState(context);
        },
        child: StartStopButtonWidget(),
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
          final watchHomeModel = watch(homeRouteViewModelProvider);
          final watchLocale = watch(localeProvider);
          return AppBar(
            leading: _showLeadingAppBarIcon(watchHomeModel, context),
            leadingWidth: ScreenConstraintService(context).minHeight * 2,
            backgroundColor: AppColors.color1,
            primary: true,
            toolbarHeight: ScreenConstraintService(context).minHeight * 3,
            centerTitle: true,
            title: Text(
              _textSelector(watchLocale.localeObject, watchHomeModel),
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
