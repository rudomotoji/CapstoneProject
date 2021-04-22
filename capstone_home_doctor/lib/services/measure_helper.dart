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

  //TO SAVE TIME START
  Future<void> intitialTimeStartM() async {
    //
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('TIME_M', '');
  }

  //
  //
  Future<void> updateTimeStartM(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('TIME_M')) {
      intitialTimeStartM();
    }
    prefs.setString('TIME_M', value);
  }

  //
  Future<String> getTimeStartM() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('TIME_M')) {
      intitialTimeStartM();
    }
    return prefs.getString('TIME_M');
  }

  //
  //
  //
  //
  //
  //TO SAVE DURATION TIME
  Future<void> intialDurationM() async {
    //
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('DURATION_M', 0);
  }

  //
  //
  Future<void> updateDurationM(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('DURATION_M')) {
      intialDurationM();
    }
    prefs.setInt('DURATION_M', value);
  }

  //
  Future<int> getDurationM() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('DURATION_M')) {
      intialDurationM();
    }
    return prefs.getInt('DURATION_M');
  }

  ///
  //TO COUNTING DURATION
  Future<void> intialCountingM() async {
    //
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('COUNTING_M', 0);
  }

  //
  //
  Future<void> updateCountingM(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('COUNTING_M')) {
      intialCountingM();
    }
    prefs.setInt('COUNTING_M', value);
  }

  //
  Future<int> getCountingM() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('COUNTING_M')) {
      intialCountingM();
    }
    return prefs.getInt('COUNTING_M');
  }
}
