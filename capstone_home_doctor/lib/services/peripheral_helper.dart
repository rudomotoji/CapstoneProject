import 'package:shared_preferences/shared_preferences.dart';

class PeripheralHelper {
  Future<void> initialPeripheralChecking() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('IS_PERIPHERALS_CONNECTED', false);
  }

  Future<void> updatePeripheralChecking(bool check) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('IS_PERIPHERALS_CONNECTED')) {
      initialPeripheralChecking();
    }
    prefs.setBool('IS_PERIPHERALS_CONNECTED', check);
  }

  Future<bool> isPeripheralConnected() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('IS_PERIPHERALS_CONNECTED')) {
      initialPeripheralChecking();
    }
    return prefs.getBool('IS_PERIPHERALS_CONNECTED');
  }
}
