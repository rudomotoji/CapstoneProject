import 'package:shared_preferences/shared_preferences.dart';

class PaymentHelper {
  //PAY SUCCESSFULLY OR FAILED
  Future<void> initialPaymentCheck() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('PAYMENT_CHECK', false);
  }

  Future<void> updatePaymentCheck(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('PAYMENT_CHECK')) {
      initialPaymentCheck();
    }
    prefs.setBool('PAYMENT_CHECK', value);
  }

  Future<bool> isPaymentCheck() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('PAYMENT_CHECK')) {
      initialPaymentCheck();
    }
    return prefs.getBool('PAYMENT_CHECK');
  }
}
