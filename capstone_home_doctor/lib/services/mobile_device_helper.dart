import 'package:shared_preferences/shared_preferences.dart';

class MobileDeviceHelper {
  Future<void> initialTokenDevice() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('TOKEN_DEVICE', '');
  }

  Future<void> updatelTokenDevice(String tokenDevice) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('TOKEN_DEVICE') ||
        prefs.getString('TOKEN_DEVICE') == null) {
      initialTokenDevice();
    }
    prefs.setString('TOKEN_DEVICE', tokenDevice);
  }

  Future<String> getTokenDevice() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('TOKEN_DEVICE') ||
        prefs.getString('TOKEN_DEVICE') == null) {
      initialTokenDevice();
    }
    return prefs.getString('TOKEN_DEVICE');
  }
}
