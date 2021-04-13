import 'dart:async';

import 'package:capstone_home_doctor/features/contract/repositories/payment_repository.dart';

class PaymentBloc {
  static PaymentBloc paymentBloc;
  static PaymentBloc getInstance() {
    return paymentBloc ?? (paymentBloc = PaymentBloc());
  }

  PaymentBloc() {
    paymentController.stream.listen(_handlePayment);
  }

  String _paymentUrl = "";
  String get paymentUrl => _paymentUrl;

  Sink<String> get paymentSink => paymentController.sink;
  var paymentController = StreamController<String>();

  Stream<String> get vnPayStream => vnPayController.stream;
  var vnPayController = StreamController<String>();

  PaymentRepository paymentRepository;

  void getPaymentUrl(String contract) {
    paymentRepository
        .vnpay(contract)
        .then((value) => {
              _paymentUrl = value.body,
            })
        .catchError((e) {
      print('getPaymentUrl error');
    });
  }

  void _handlePayment(String contract) {
    getPaymentUrl(contract);
    vnPayController.sink.add(_paymentUrl);
  }

  void dispose() {
    paymentController.close();
    vnPayController.close();
  }
}
