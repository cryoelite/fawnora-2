import 'package:fawnora/app/home/viewmodels/ButtonTrackerViewModel.dart';
import 'package:fawnora/app/home/widgets/googleMaps/GoogleMapWidget.dart';
import 'package:fawnora/constants/StartStopButtonEnum.dart';
import 'package:fawnora/services/ScreenConstraintService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrackWidget extends StatefulWidget {
  const TrackWidget({Key? key}) : super(key: key);

  @override
  _TrackWidgetState createState() => _TrackWidgetState();
}

class _TrackWidgetState extends State<TrackWidget> {
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
          child: Container(
            color: Colors.red,
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
                  child: child,
                ),
              ),
            );
          },
        ),
        //TODO: Create an elevated button with quickadd mini logo and then on pressed pass the event to its viewmodel in its folder causing it to replace child here with a fullscreen stack.
        Consumer(
          child: Container(
            color: Colors.blue,
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
                  child: child,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
