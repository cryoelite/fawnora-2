import 'package:fawnora/app/home/routes/track/viewmodels/ToShowAssistiveAddWidget.dart';
import 'package:fawnora/app/home/routes/track/viewmodels/ToShowQuickAddViewModel.dart';
import 'package:fawnora/app/home/viewmodels/ButtonTrackerViewModel.dart';
import 'package:fawnora/app/home/widgets/AssistiveAdd/AssistiveAddWidget.dart';
import 'package:fawnora/app/home/widgets/googleMaps/GoogleMapWidget.dart';
import 'package:fawnora/app/home/widgets/miniAssistiveAdd/MiniAssistiveAddWidget.dart';
import 'package:fawnora/app/home/widgets/miniQuickAdd/MiniQuickAddWidget.dart';
import 'package:fawnora/app/home/widgets/quickAdd/QuickAddWidget.dart';
import 'package:fawnora/constants/AppColors.dart';
import 'package:fawnora/constants/HeroTags.dart';
import 'package:fawnora/models/StartStopButtonEnum.dart';
import 'package:fawnora/services/ScreenConstraintService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrackWidget extends StatelessWidget {
  double _googleMapHeightSelector(
      BuildContext context, StartStopButtonEnum buttonEnum) {
    if (buttonEnum == StartStopButtonEnum.STOP)
      return ScreenConstraintService(context).getConvertedHeight(484);
    else
      return ScreenConstraintService(context).getConvertedHeight(164);
  }

  Alignment _googleMapAlignmentSelector(
      BuildContext context, StartStopButtonEnum buttonEnum) {
    if (buttonEnum == StartStopButtonEnum.STOP)
      return Alignment.center;
    else {
      return Alignment(
        0,
        -0.8,
      );
    }
  }

  Widget _visibilityWidget(ScopedReader watch, Widget _child) {
    final watchButtonState = watch(buttonTrackerProvider);
    bool show = false;
    if (watchButtonState == StartStopButtonEnum.STOP)
      show = false;
    else {
      show = true;
    }
    return Visibility(
      child: IgnorePointer(
        ignoring: !show,
        child: _child,
      ),
      visible: show,
    );
  }

  Widget _showStack(Widget _child, BuildContext context) {
    return Container(
      width: ScreenConstraintService(context).maxWidth,
      height: ScreenConstraintService(context).maxHeight,
      color: AppColors.color2,
      child: Stack(
        children: [
          _child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Consumer(
          child: GoogleMapWidget(),
          builder: (context, watch, child) {
            final watchButtonState = watch(buttonTrackerProvider);
            return Align(
              alignment: _googleMapAlignmentSelector(context, watchButtonState),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: ScreenConstraintService(context).minWidth * 30,
                height: _googleMapHeightSelector(context, watchButtonState),
                child: child,
              ),
            );
          },
        ),
        Consumer(
          child: Hero(
            tag: HeroTags.quickAddTag,
            child: MiniQuickAddWidget(),
          ),
          builder: (context, watch, child) {
            return _visibilityWidget(
              watch,
              Align(
                alignment: Alignment.center,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: ScreenConstraintService(context).minWidth * 30,
                  height:
                      ScreenConstraintService(context).getConvertedHeight(164),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: child,
                  ),
                ),
              ),
            );
          },
        ),
        Consumer(
          child: Hero(
            tag: HeroTags.assistiveAddTag,
            child: MiniAssistiveAddWidget(),
          ),
          builder: (context, watch, child) {
            return _visibilityWidget(
              watch,
              Align(
                alignment: Alignment(0, 0.8),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: ScreenConstraintService(context).minWidth * 30,
                  height:
                      ScreenConstraintService(context).getConvertedHeight(164),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: child,
                  ),
                ),
              ),
            );
          },
        ),
        Consumer(
          child: _showStack(
            Hero(
              tag: HeroTags.assistiveAddTag,
              child: AssistiveAddWidget(),
            ),
            context,
          ),
          builder: (context, watch, child) {
            final watchQuick = watch(toShowQuickAddWidgetProvider);
            final watchAssistive = watch(toShowAssistiveAddWidgetProvider);

            if (watchQuick) {
              return Hero(
                tag: HeroTags.quickAddTag,
                child: _showStack(
                  QuickAddWidget(),
                  context,
                ),
              );
            } else if (watchAssistive) {
              return child!;
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}
