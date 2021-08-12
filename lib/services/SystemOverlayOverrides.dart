import 'package:fawnora/constants/AppColors.dart';
import 'package:flutter/services.dart';

class SystemOverlayOverrides {
  static get systemOverlayOverrides {
    final systemTheme = SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: AppColors.color11,
      systemNavigationBarIconBrightness: Brightness.light,
    );
    return systemTheme;
  }
}
