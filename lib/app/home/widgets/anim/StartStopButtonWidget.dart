import 'package:fawnora/app/home/widgets/anim/viewmodels/animViewModel.dart';
import 'package:fawnora/services/ScreenConstraintService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

class StartStopButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipOval(
        child: FutureBuilder(
            future: context.read(animViewModelProvider).init(),
            builder: (context, snapshot) {
              return Consumer(
                builder: (context, watch, child) {
                  final watchAnimModel = watch(animViewModelProvider);
                  if (snapshot.connectionState == ConnectionState.done)
                    return Rive(
                      artboard: watchAnimModel.artboard,
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                    );
                  else
                    return Container();
                },
              );
            }),
      ),
    );
  }
}
