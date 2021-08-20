import 'package:flutter/material.dart' show Color, MaterialColor;

class AppColors {
  static const color1 = Color(0xff242634);
  static const color2 = Color(0xff2e2f41);
  static const color3 = Color(0xff6eb4fe);
  static const color4 = Color(0xffee675c);
  static const color5 = Color(0xffcb3b3b);
  static const color6 = Color(0xfff3a811);
  static const color7 = Color(0xffffffff);
  static const color8 = Color(0xff4b4c5c);
  static const color9 = Color(0xff99cc33);
  static const color10 = Color(0xffa89f9f);
  static const color11 = Color(0xff35364B);
  static const color12 = Color(0xffC4C5D1);
  static const color13 = Color(0xff86fde8);
  static const color14 = Color(0xffacb6e5);
  static const color15 = Color(0xff33C0B3);
  static const color16 = Color(0xff1E62DB);

  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }
}
