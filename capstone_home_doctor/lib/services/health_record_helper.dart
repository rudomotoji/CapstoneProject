import 'package:shared_preferences/shared_preferences.dart';

class HealthRecordHelper {
  Future<void> initialHRId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('HEALTH_RECORD_ID', '');
  }

  Future<void> setHealthReCordId(String hrId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('HEALTH_RECORD_ID') ||
        prefs.getString('HEALTH_RECORD_ID') == '') {
      initialHRId();
    }
    prefs.setString('HEALTH_RECORD_ID', hrId);
  }

  Future<String> getHRId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('HEALTH_RECORD_ID') ||
        prefs.getString('HEALTH_RECORD_ID') == '') {
      initialHRId();
    }
    return prefs.getString('HEALTH_RECORD_ID');
  }
}
