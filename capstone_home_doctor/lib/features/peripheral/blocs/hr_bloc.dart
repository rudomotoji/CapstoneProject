import 'dart:async';

import 'package:rxdart/subjects.dart';

class HRBloc {
  var calHrController = BehaviorSubject<int>();
  StreamSink get hrSink => calHrController.sink;
  Stream get hrStream => calHrController.stream;

  var heartRatesController = BehaviorSubject<List<int>>();
  StreamSink get heartRateSink => heartRatesController.sink;
  Stream get heartRateStream => heartRatesController.stream;

  List<int> _heartRates = [];
  List<int> get getHeartRates => _heartRates;

  void updateHR(int hrm) {
    if (hrm == 0) return;
    _heartRates.add(hrm);
    heartRateSink.add(_heartRates);
  }

  void dispose() {
    calHrController?.close();
    heartRatesController?.close();
  }
}

final hrBloc = HRBloc();
