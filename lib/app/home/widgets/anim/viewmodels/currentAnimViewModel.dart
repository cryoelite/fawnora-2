import 'package:fawnora/constants/AnimAssets.dart';
import 'package:fawnora/models/RiveAnimationModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

final currentAnimViewModelProvider =
    ChangeNotifierProvider((ref) => CurrentAnimViewModel(
          RiveAnimationModel(
            [
              'ShowPause',
              'ShowPlay',
            ],
            [
              'def_artboard',
            ],
            AnimAssets.start_stop_anim,
          ),
        ));

class CurrentAnimViewModel extends ChangeNotifier {
  int _value = 1;
  String currentAnimation;
  late Artboard artboard;
  final RiveAnimationModel animationModel;
  CurrentAnimViewModel(this.animationModel)
      : currentAnimation = animationModel.animations[0];

  Future<void> init() async {
    final file = await _loadFile();
    artboard = file.mainArtboard;
    final controller = SimpleAnimation(animationModel.animations[_value]);
    controller.isActive = false;
    _assignControllerToArtboard(controller);
  }

  void _assignControllerToArtboard(
      RiveAnimationController<dynamic> controller) {
    artboard.addController(controller);
  }

  Future<RiveFile> _loadFile() async {
    final bytes = await rootBundle.load(animationModel.localRiveAsset);
    final file = RiveFile.import(bytes);
    return file;
  }

  void changeCurrentAnimation() {
    _value++;
    if (_value >= animationModel.animations.length) _value = 0;
    currentAnimation = animationModel.animations[_value];
    _assignControllerToArtboard(
        SimpleAnimation(animationModel.animations[_value]));
  }
}
