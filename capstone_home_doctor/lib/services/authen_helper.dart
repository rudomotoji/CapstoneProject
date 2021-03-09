import 'package:shared_preferences/shared_preferences.dart';

class AuthenticateHelper {
  Future<void> innitalAuthen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('AUTHENTICATION', false);
    prefs.setInt('PATIENT_ID', 0);
    prefs.setInt('ACCOUNT_ID', 0);
  }

  Future<void> updateAuth(bool isAuthen, int patientId, int accountId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('AUTHENTICATION') ||
        prefs.getBool('AUTHENTICATION') == null) {
      innitalAuthen();
    }
    if (!prefs.containsKey('PATIENT_ID') ||
        prefs.getInt('PATIENT_ID') == null) {
      innitalAuthen();
    }
    if (!prefs.containsKey('ACCOUNT_ID') ||
        prefs.getInt('ACCOUNT_ID') == null) {
      innitalAuthen();
    }
    prefs.setBool('AUTHENTICATION', isAuthen);
    prefs.setInt('PATIENT_ID', patientId);
    prefs.setInt('ACCOUNT_ID', accountId);
  }

  Future<int> getPatientId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('PATIENT_ID') ||
        prefs.getInt('PATIENT_ID') == null) {
      innitalAuthen();
    }
    return prefs.getInt('PATIENT_ID');
  }

  Future<int> getAccountId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('ACCOUNT_ID') ||
        prefs.getInt('ACCOUNT_ID') == null) {
      innitalAuthen();
    }
    return prefs.getInt('ACCOUNT_ID');
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
