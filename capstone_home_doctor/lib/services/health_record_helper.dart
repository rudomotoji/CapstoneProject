import 'package:shared_preferences/shared_preferences.dart';

class HealthRecordHelper {
  Future<void> initialHRId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('HEALTH_RECORD_ID', 0);
  }

  Future<void> setHealthReCordId(int hrId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('HEALTH_RECORD_ID') ||
        prefs.getInt('HEALTH_RECORD_ID') == null) {
      initialHRId();
    }
    prefs.setInt('HEALTH_RECORD_ID', hrId);
  }

  Future<int> getHRId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('HEALTH_RECORD_ID') ||
        prefs.getInt('HEALTH_RECORD_ID') == null) {
      initialHRId();
    }
    return prefs.getInt('HEALTH_RECORD_ID');
  }
}
