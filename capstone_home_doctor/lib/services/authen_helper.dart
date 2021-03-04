import 'package:shared_preferences/shared_preferences.dart';

class AuthenticateHelper {
  Future<void> innitalAuthen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('AUTHENTICATION', false);
    prefs.setInt('PATIENT_ID', 0);
  }

  Future<void> updateAuth(bool isAuthen, int patientId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('AUTHENTICATION') ||
        prefs.getBool('AUTHENTICATION') == null) {
      innitalAuthen();
    }
    if (!prefs.containsKey('PATIENT_ID') ||
        prefs.getInt('PATIENT_ID') == null) {
      innitalAuthen();
    }
    prefs.setBool('AUTHENTICATION', isAuthen);
    prefs.setInt('PATIENT_ID', patientId);
  }

  Future<int> getPatientId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('PATIENT_ID') ||
        prefs.getInt('PATIENT_ID') == null) {
      innitalAuthen();
    }
    return prefs.getInt('PATIENT_ID');
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
