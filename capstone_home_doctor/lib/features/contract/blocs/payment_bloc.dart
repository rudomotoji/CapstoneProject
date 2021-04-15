// import 'dart:async';

// import 'package:capstone_home_doctor/features/contract/repositories/payment_repository.dart';

// class PaymentBloc {
//   static PaymentBloc paymentBloc;
//   static PaymentBloc getInstance() {
//     return paymentBloc ?? (paymentBloc = PaymentBloc());
//   }

//   PaymentBloc() {
//     paymentController.stream.listen(_handlePayment);
//   }

//   String _paymentUrl = "";
//   String get paymentUrl => _paymentUrl;

//   Sink<String> get paymentSink => paymentController.sink;
//   var paymentController = StreamController<String>();

//   Stream<String> get vnPayStream => vnPayController.stream;
//   var vnPayController = StreamController<String>();

//   PaymentRepository paymentRepository;

//   void getPaymentUrl(int amount, String description) {
//     paymentRepository
//         .vnpay(amount, description)
//         .then((value) => {
//               _paymentUrl = value.body,
//             })
//         .catchError((e) {
//       print('getPaymentUrl error');
//     });
//   }

//   void _handlePayment(int amount, String description) {
//     getPaymentUrl(amount, description);
//     vnPayController.sink.add(_paymentUrl);
//   }

//   void dispose() {
//     paymentController.close();
//     vnPayController.close();
//   }
// }
