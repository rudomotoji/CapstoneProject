import 'package:shared_preferences/shared_preferences.dart';

class ReminderHelper {
  //SAVE BLUETOOTH CONNECTION
  Future<void> initialBluetoothConnection() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('BLUETOOTH_CONNECTION', false);
  }

  Future<void> updateValueBluetooth(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('BLUETOOTH_CONNECTION')) {
      initialBluetoothConnection();
    }
    prefs.setBool('BLUETOOTH_CONNECTION', value);
  }

  Future<bool> isBluetoothConnection() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('BLUETOOTH_CONNECTION')) {
      initialBluetoothConnection();
    }
    return prefs.getBool('BLUETOOTH_CONNECTION');
  }
}
