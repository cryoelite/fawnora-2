import 'package:fawnora/app/home/widgets/AssistiveAdd/viewmodels/selectionStatusViewModel.dart';
import 'package:fawnora/app/home/widgets/DropDown/viewmodels/DropDownViewModel.dart';
import 'package:fawnora/app/home/widgets/anim/viewmodels/animViewModel.dart';
import 'package:fawnora/common_widgets/viewmodels/ButtonIconViewModel.dart';
import 'package:fawnora/constants/ImageAssets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

class CenterButton extends StatelessWidget {
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
                  final watchSpecie = watch(activeSpecieTypeIconIdProvider);
                  final watchSubSpecie = watch(activeSubSpecieIconIdProvider);
                  final watchDropdown = watch(dropDownValueProvider);
                  final watchAssistive = watch(selectionStatusProvider);
                  if (snapshot.connectionState == ConnectionState.done) {
                    if ((watchSpecie != null &&
                            watchSubSpecie != null &&
                            watchDropdown.value != null) ||
                        (watchAssistive != null)) {
                      return Image(
                        image: AssetImage(
                          ImageAssets.tickIcon,
                        ),
                      );
                    } else {
                      return Rive(
                        artboard: watchAnimModel.artboard,
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                      );
                    }
                  } else
                    return Container();
                },
              );
            }),
      ),
    );
  }
}
