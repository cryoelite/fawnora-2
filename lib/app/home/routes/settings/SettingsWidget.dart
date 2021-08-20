import 'package:fawnora/app/home/widgets/About/AboutWidget.dart';
import 'package:fawnora/app/home/widgets/Language/LanugageWidget.dart';
import 'package:fawnora/services/ScreenConstraintService.dart';
import 'package:flutter/material.dart';

class SettingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenConstraintService(context).maxWidth,
      height: ScreenConstraintService(context).maxHeight,
      padding: EdgeInsets.all(
        ScreenConstraintService(context).minWidth * 4,
      ),
      child: ListView(
        physics: BouncingScrollPhysics(),
        itemExtent: ScreenConstraintService(context).minHeight * 5,
        children: [
          LanguageWidget(),
          AboutWidget(),
        ],
      ),
    );
  }
}
