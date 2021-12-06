import 'package:shared_preferences/shared_preferences.dart';

class AppointmentHelper {
  Future<void> initialAppointmentChangeDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('APPOINTMENT_CHANGE_DATE', false);
  }

  Future<void> setAppointmentChangeDate(bool response) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('APPOINTMENT_CHANGE_DATE') ||
        prefs.getBool('APPOINTMENT_CHANGE_DATE') == null) {
      initialAppointmentChangeDate();
    }
    prefs.setBool('APPOINTMENT_CHANGE_DATE', response);
  }

  Future<bool> getAppointmentChangeDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('APPOINTMENT_CHANGE_DATE') ||
        prefs.getBool('APPOINTMENT_CHANGE_DATE') == null) {
      initialAppointmentChangeDate();
    }
    return prefs.getBool('APPOINTMENT_CHANGE_DATE');
  }
}
