import 'package:capstone_home_doctor/features/vital_sign/events/heart_rate_event.dart';
import 'package:capstone_home_doctor/features/vital_sign/states/heart_rate_state.dart';
import 'package:capstone_home_doctor/models/heart_rate_dto.dart';
import 'package:capstone_home_doctor/services/sqflite_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HeartRateBloc extends Bloc<HeartRateEvent, HeartRateState> {
  final SQFLiteHelper sqfLiteHelper;
  HeartRateBloc({@required this.sqfLiteHelper})
      : assert(sqfLiteHelper != null),
        super(HeartRateStateStateInitial());

  @override
  Stream<HeartRateState> mapEventToState(HeartRateEvent event) async* {
    if (event is HeartRateEventGetList) {
      yield HeartRateStateLoading();
      try {
        final List<HeartRateDTO> list = await sqfLiteHelper.getListHeartRate();
        yield HeartRateStateSuccess(listHeartRate: list);
      } catch (e) {
        yield HeartRateStateFailure();
      }
    }
  }
}
