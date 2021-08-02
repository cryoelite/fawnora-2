import 'package:fawnora/constants/AppColors.dart';
import 'package:fawnora/constants/ImageAssets.dart';
import 'package:fawnora/locale/LocaleConfig.dart';
import 'package:fawnora/services/ScreenConstraintService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashWidget extends StatefulWidget {
  const SplashWidget({Key? key}) : super(key: key);

  @override
  _SplashWidgetState createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          child: Container(
            alignment: Alignment.center,
            width: ScreenConstraintService(context).maxWidth,
            child: Container(
              width: ScreenConstraintService(context).getConvertedWidth(276),
              height: ScreenConstraintService(context).getConvertedHeight(572),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                  image: AssetImage(
                    ImageAssets.splashImage,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: ScreenConstraintService(context).minHeight * 2,
          child: Container(
            alignment: Alignment.center,
            width: ScreenConstraintService(context).maxWidth,
            child: Consumer(builder: (context, watch, child) {
              final watchLocale = watch(localeProvider);
              return Text(
                watchLocale.localeObject.welcomeText,
                style: TextStyle(
                  color: AppColors.color7,
                  fontSize:
                      ScreenConstraintService(context).getConvertedHeight(15),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
