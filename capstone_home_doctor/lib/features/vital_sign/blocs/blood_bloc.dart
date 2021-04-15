import 'package:capstone_home_doctor/features/vital_sign/events/blood_event.dart';
import 'package:capstone_home_doctor/features/vital_sign/repositories/vital_sign_repository.dart';
import 'package:capstone_home_doctor/features/vital_sign/states/blood_state.dart';
import 'package:capstone_home_doctor/models/vital_sign_dto.dart';
import 'package:capstone_home_doctor/services/sqflite_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VitalSignBloodBloc extends Bloc<BloodEvent, BloodState> {
  final SQFLiteHelper sqfLiteHelper;
  final VitalSignRepository vitalSignRepository;
  VitalSignBloodBloc(
      {@required this.sqfLiteHelper, @required this.vitalSignRepository})
      : assert(sqfLiteHelper != null && vitalSignRepository != null),
        super(BloodPressureStateInitial());

  @override
  Stream<BloodState> mapEventToState(BloodEvent event) async* {
    if (event is BloodPressureEventGet) {
      yield BloodPressureStateLoading();
      try {
        final List<VitalSignDTO> list = await sqfLiteHelper
            .getListBloodVitalSign(event.type, event.patientId);
        yield BloodPressureStateGetListSuccess(list: list);
      } catch (e) {
        yield BloodPressureStateFailure();
      }
    }
  }
}
