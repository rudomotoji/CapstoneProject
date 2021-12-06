// import 'package:capstone_home_doctor/features/vital_sign/events/real_time_event.dart';
// import 'package:capstone_home_doctor/features/vital_sign/repositories/vital_sign_repository.dart';
// import 'package:capstone_home_doctor/features/vital_sign/states/real_time_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class RealTimeVitalSignBloc
//     extends Bloc<RealtimeVitalSignEvent, RealtimeState> {
//   final VitalSignRepository vitalSignRepository;
//   RealTimeVitalSignBloc({@required this.vitalSignRepository})
//       : assert(vitalSignRepository != null),
//         super(RealtimeStateInitial());

//   @override
//   Stream<RealtimeState> mapEventToState(RealtimeVitalSignEvent event) async* {
//     // TODO: implement mapEventToState
//     if (event is RealtimeVitalSignEventGet) {
//       yield RealtimeStateLoading();
//       try {
//         //
//         await vitalSignRepository.kickHRCOn(event.peripheralId);
//         yield RealtimeStateSuccessful(valueKickedOn: )
//       } catch (e) {
//         yield RealtimeStateFailure();
//       }
//     }
//   }
// }

import 'dart:async';
import 'package:rxdart/subjects.dart';

class RealTimeHeartRateBloc {
  // int heartRateListened = 0;
  // StreamController realtimeHRController = new StreamController<int>.broadcast();
  // Stream get heartRateStream =>
  //     realtimeHRController.stream.transform(heartRateTranformer);
  // var heartRateTranformer =
  //     StreamTransformer<int, int>.fromHandlers(handleData: (data, sink) {
  //   //
  //   sink.add(data);
  // });

  // void dispose() {
  //   realtimeHRController.close();
  // }
  var realtimeHrController = BehaviorSubject<int>();
  StreamSink get realtimeHrSink => realtimeHrController.sink;
  Stream get realtimeHrStream => realtimeHrController.stream;
  //

  //
  var realTimeListController = BehaviorSubject<List<int>>();
  StreamSink get realtimeListSink => realTimeListController.sink;
  Stream get realtimeListStream => realTimeListController.stream;

  //
  List<int> list = [];
  List<int> get getList => list;

  //
  void updateRealtimeHR(int value) {
    if (value != 0) {
      list.add(value);
      realtimeListSink.add(list);
    }
  }

  void dispose() {
    realtimeHrController?.close();
    realTimeListController?.close();
  }
}

final realtimeHeartRateBloc = RealTimeHeartRateBloc();
