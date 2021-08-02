import 'package:flutter/material.dart';

///Screen Configuration Service, provides custom constraints.
///16:9 sized, 16 for height and 9 for width.
class ScreenConstraintService {
  ///minWidth is supposed to be 9
  double minWidth = 9.0;

  ///This is the maximum screen width
  double maxWidth = 0.0;

  ///minHeight is supposed to be 16
  double minHeight = 16.0;

  ///This is the maximum screen Height
  double maxHeight = 0.0;

  ///Prototype's max width. Prototype dimensions are taken from the XD file.
  final double protoMaxWidth = 375;

  ///Prototype's max height. Prototype dimensions are taken from the XD file.
  final double protoMaxHeight = 780;

  double getConvertedHeight(double protoHeight) {
    final double convertedNormalHeight =
        (protoHeight * maxHeight) / protoMaxHeight;
    return convertedNormalHeight;
  }

  double getConvertedWidth(double protoWidth) {
    final double convertedNormalWidth = (protoWidth * maxWidth) / protoMaxWidth;
    return convertedNormalWidth;
  }

  double getConvertedX(double protoWidth) {
    final double convertedNormalWidth = (protoWidth * maxWidth) / protoMaxWidth;
    return protoMaxWidth - convertedNormalWidth;
  }

  double getConvertedY(double protoHeight) {
    final double convertedNormalHeight =
        (protoHeight * maxHeight) / protoMaxHeight;
    return protoMaxHeight - convertedNormalHeight;
  }

  ScreenConstraintService(BuildContext context) {
    final size = MediaQuery.of(context).size;
    maxWidth = size.width;
    maxHeight = size.height;
    minHeight = maxHeight /
        48.81; //16*48.81 is the height dimension on development device. We are getting every device to follow the same constraints.
    minWidth = maxWidth /
        43.63; //16*43.63 is the width dimension on development device. We are getting every device to follow the same constraints.
  }
}
