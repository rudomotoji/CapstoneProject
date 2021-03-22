import 'package:capstone_home_doctor/features/contract/events/contract_list_event.dart';
import 'package:capstone_home_doctor/features/contract/repositories/contract_repository.dart';
import 'package:capstone_home_doctor/features/contract/states/contract_list_state.dart';
import 'package:capstone_home_doctor/features/health/vitalsigns/events/heart_rate_event.dart';
import 'package:capstone_home_doctor/features/health/vitalsigns/states/heart_rate_state.dart';

import 'package:capstone_home_doctor/models/contract_inlist_dto.dart';
import 'package:capstone_home_doctor/models/heart_rate_dto.dart';
import 'package:capstone_home_doctor/models/med_ins_by_disease_dto.dart';
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
