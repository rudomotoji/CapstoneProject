import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class VitalSignHelper {
  //SAVE LAST HEART RATE VALUE
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

  //COUNT FOR (~JSON MINUTES) INSERT HEART RATE INTO DATABSE
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

  //COUNT RUN IN BACKGROUND
  Future<void> initialCountInBackground() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('COUNT_IN_BACKGROUND', 0);
  }

  Future<void> updateCountInBackground(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('COUNT_IN_BACKGROUND')) {
      initialCountInBackground();
    }
    prefs.setInt('COUNT_IN_BACKGROUND', value);
  }

  Future<int> getCountInBackground() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('COUNT_IN_BACKGROUND')) {
      initialCountInBackground();
    }
    return prefs.getInt('COUNT_IN_BACKGROUND');
  }

  //CHECK DANGEROUS BACK TO NORMAL
  Future<void> initialCheckToNormal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('DANGER_TO_NORMAL', false);
  }

  Future<void> updateCheckToNormal(bool check) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('DANGER_TO_NORMAL')) {
      initialCheckToNormal();
    }
    prefs.setBool('DANGER_TO_NORMAL', check);
  }

  Future<bool> isCheckToNormal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('DANGER_TO_NORMAL')) {
      initialCheckToNormal();
    }
    return prefs.getBool('DANGER_TO_NORMAL');
  }

  //COUNT TO NORMAL
  Future<void> initialCountToNormal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('COUNT_TO_NORMAL', 0);
  }

  Future<void> updateCountToNormal(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('COUNT_TO_NORMAL')) {
      initialCountToNormal();
    }
    prefs.setInt('COUNT_TO_NORMAL', value);
  }

  Future<int> getCountToNormal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('COUNT_TO_NORMAL')) {
      initialCountToNormal();
    }
    return prefs.getInt('COUNT_TO_NORMAL');
  }
}
