import 'package:shared_preferences/shared_preferences.dart';

class TokenHelper {
  Future<void> initialToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('TOKEN', '');
  }

  Future<void> setToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('TOKEN') || prefs.getString('TOKEN') == null) {
      initialToken();
    }
    prefs.setString('TOKEN', token);
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('TOKEN') || prefs.getString('TOKEN') == null) {
      initialToken();
    }
    return prefs.getString('TOKEN');
  }
}
