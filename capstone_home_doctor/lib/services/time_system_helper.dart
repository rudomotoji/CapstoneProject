import 'package:shared_preferences/shared_preferences.dart';

class TimeSystemHelper {
  Future<void> initialTimeSystem() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('TIME_SYSTEM', '');
  }

  Future<void> setTimeSystem(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('TIME_SYSTEM') ||
        prefs.getString('TIME_SYSTEM') == null) {
      initialTimeSystem();
    }
    prefs.setString('TIME_SYSTEM', value);
  }

  Future<String> getTimeSystem() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('TIME_SYSTEM') ||
        prefs.getString('TIME_SYSTEM') == null) {
      initialTimeSystem();
    }
    return prefs.getString('TIME_SYSTEM');
  }
}
