import 'package:shared_preferences/shared_preferences.dart';

class MeasureHelper {
  Future<void> initialMeasureHelper() async {
    //
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('MEASURE_ON', false);
  }

  //
  //
  Future<void> updateMeasureOn(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('MEASURE_ON')) {
      initialMeasureHelper();
    }
    prefs.setBool('MEASURE_ON', value);
  }

  //
  Future<bool> isMeasureOn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('MEASURE_ON')) {
      initialMeasureHelper();
    }
    return prefs.getBool('MEASURE_ON');
  }
}
