import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';

class GetDeviceID {
  String deviceID;

  GetDeviceID(this.deviceID);

  static Future<String> getDeviceUniqueId() async {
    var deviceIdentifier = 'unknown';
    var deviceInfo = DeviceInfoPlugin();

    var androidInfo = await deviceInfo.androidInfo;
    deviceIdentifier = androidInfo.id;

    return deviceIdentifier;
  }
}
