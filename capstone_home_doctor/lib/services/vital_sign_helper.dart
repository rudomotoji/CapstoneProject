import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class VitalSignHelper {
  Future<void> initialHeartRateValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('HEART_RATE_VALUE', 0);
  }

  Future<void> updateHeartValue(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('HEART_RATE_VALUE')) {
      initialHeartRateValue();
    }
    prefs.setInt('HEART_RATE_VALUE', value);
  }

  Future<int> getHeartRateValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('HEART_RATE_VALUE')) {
      initialHeartRateValue();
    }
    return prefs.getInt('HEART_RATE_VALUE');
  }

  //COUNT FOR 5 MINUTES INSERT HEART RATE INTO DATABSE
  Future<void> initalCountingHR() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('HEART_RATE_COUNTING_TIME', 0);
  }

  Future<void> updateCountingHR(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('HEART_RATE_COUNTING_TIME')) {
      initalCountingHR();
    }
    prefs.setInt('HEART_RATE_COUNTING_TIME', value);
  }

  Future<int> getCountingHR() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('HEART_RATE_COUNTING_TIME')) {
      initalCountingHR();
    }
    return prefs.getInt('HEART_RATE_COUNTING_TIME');
  }

  //COUNTDOWN DANGEROUS
  Future<void> initialCountDownDangerous() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('COUNT_DOWN_DANGEROUS', 0);
  }

  Future<void> updateCountDownDangerous(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('COUNT_DOWN_DANGEROUS')) {
      initialCountDownDangerous();
    }
    prefs.setInt('COUNT_DOWN_DANGEROUS', value);
  }

  Future<int> getCountDownDangerous() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('COUNT_DOWN_DANGEROUS')) {
      initialCountDownDangerous();
    }
    return prefs.getInt('COUNT_DOWN_DANGEROUS');
  }
}
