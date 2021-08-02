import 'dart:math';

import 'package:device_info/device_info.dart';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final deviceIDProvider =
    Provider<GetDeviceIDService>((_) => GetDeviceIDService());

class GetDeviceIDService {
  Future<String> id() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final devID = await deviceInfoPlugin.iosInfo;
      return devID.identifierForVendor;
    } else if (Platform.isAndroid) {
      final devID = await deviceInfoPlugin.androidInfo;
      return devID.androidId;
    } else
      return "DEFAULT";
  }
}
