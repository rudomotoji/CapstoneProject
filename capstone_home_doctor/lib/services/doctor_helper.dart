import 'package:shared_preferences/shared_preferences.dart';

class DoctorHelper {
  Future<void> initialDoctor() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('DOCTOR_ACCOUNT_ID', 0);
  }

  Future<void> updateDoctor(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('DOCTOR_ACCOUNT_ID') ||
        prefs.getInt('DOCTOR_ACCOUNT_ID') == null) {
      initialDoctor();
    }
    prefs.setInt('DOCTOR_ACCOUNT_ID', id);
  }

  Future<int> getDoctorId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('DOCTOR_ACCOUNT_ID') ||
        prefs.getInt('DOCTOR_ACCOUNT_ID') == null) {
      initialDoctor();
    }
    return prefs.getInt('DOCTOR_ACCOUNT_ID');
  }
}
