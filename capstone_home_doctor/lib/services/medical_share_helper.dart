import 'package:shared_preferences/shared_preferences.dart';

class MedicalShareHelper {
//FOR MEDICAL SHARE CHECKING
  Future<void> initialMedicalShareChecking() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('MED_SHARE_CHECKING', false);
  }

  Future<void> updateMedicalShareChecking(bool isSent) async {
    //
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('MED_SHARE_CHECKING') ||
        prefs.getBool('MED_SHARE_CHECKING') == null) {
      //
      initialMedicalShareChecking();
    }

    prefs.setBool('MED_SHARE_CHECKING', isSent);
  }

  Future<bool> isMedicalShared() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('MED_SHARE_CHECKING') ||
        prefs.getBool('MED_SHARE_CHECKING') == null) {
      //
      initialMedicalShareChecking();
    }

    return prefs.getBool('MED_SHARE_CHECKING');
  }
}
