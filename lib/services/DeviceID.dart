import 'dart:io';
import 'dart:developer' as dev;
import 'dart:math';
import 'package:device_info/device_info.dart';

class DeviceID {
  final _className = 'DeviceID';
  Future<String> getDeviceid() async {
    dev.log('$_className: Getting Device ID', level: 800);
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final devID = await deviceInfoPlugin.iosInfo;

      dev.log('$_className: Device ios and id ${devID.identifierForVendor}',
          level: 800);

      return devID.identifierForVendor;
    } else if (Platform.isAndroid) {
      final devID = await deviceInfoPlugin.androidInfo;

      dev.log('$_className: Device android and id ${devID.androidId}',
          level: 800);

      return devID.androidId;
    } else {
      final devID = Random().nextInt(100020).toString();
      dev.log('$_className: Device unknown and id $devID', level: 800);

      return devID;
    }
  }
}
