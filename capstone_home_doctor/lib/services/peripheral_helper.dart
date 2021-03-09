import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class PeripheralHelper {
  Future<void> initialPeripheralChecking() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('IS_PERIPHERALS_CONNECTED', false);
    prefs.setString('PERIPHERAL_ID', '');
  }

  Future<void> updatePeripheralChecking(bool check, String pId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('IS_PERIPHERALS_CONNECTED')) {
      initialPeripheralChecking();
    }
    if (!prefs.containsKey('PERIPHERAL_ID')) {
      initialPeripheralChecking();
    }
    prefs.setBool('IS_PERIPHERALS_CONNECTED', check);
    prefs.setString('PERIPHERAL_ID', pId);
  }

  Future<String> getPeripheralId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('PERIPHERAL_ID')) {
      initialPeripheralChecking();
    }
    return prefs.getString('PERIPHERAL_ID');
  }

  Future<bool> isPeripheralConnected() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('IS_PERIPHERALS_CONNECTED')) {
      initialPeripheralChecking();
    }
    return prefs.getBool('IS_PERIPHERALS_CONNECTED');
  }
}
