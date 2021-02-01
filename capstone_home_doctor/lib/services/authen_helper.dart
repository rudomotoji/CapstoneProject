import 'package:shared_preferences/shared_preferences.dart';

class AuthenticateHelper {
  Future<void> innitalAuthen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('AUTHENTICATION', false);
  }

  Future<void> updateAuth(bool isAuthen) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('AUTHENTICATION') ||
        prefs.getBool('AUTHENTICATION') == null) {
      innitalAuthen();
    }
    prefs.setBool('AUTHENTICATION', isAuthen);
  }

  Future<bool> isAuthenticated() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('AUTHENTICATION') ||
        prefs.getBool('AUTHENTICATION') == null) {
      innitalAuthen();
    }
    return prefs.getBool('AUTHENTICATION');
  }
}
