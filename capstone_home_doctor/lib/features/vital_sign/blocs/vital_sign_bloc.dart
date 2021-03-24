import 'package:capstone_home_doctor/features/vital_sign/events/vital_sign_event.dart';
import 'package:capstone_home_doctor/features/vital_sign/repositories/vital_sign_repository.dart';
import 'package:capstone_home_doctor/features/vital_sign/states/vital_sign_state.dart';
import 'package:capstone_home_doctor/models/vital_sign_dto.dart';
import 'package:capstone_home_doctor/services/sqflite_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VitalSignBloc extends Bloc<VitalSignEvent, VitalSignState> {
  final SQFLiteHelper sqfLiteHelper;
  final VitalSignRepository vitalSignRepository;
  VitalSignBloc(
      {@required this.sqfLiteHelper, @required this.vitalSignRepository})
      : assert(sqfLiteHelper != null && vitalSignRepository != null),
        super(VitalSignStateInitial());

  @override
  Stream<VitalSignState> mapEventToState(VitalSignEvent event) async* {
    if (event is VitalSignEventGetHeartRateFromDevice) {
      yield VitalSignStateLoading();
      try {
        final int valueHRFromDevice = await vitalSignRepository
            .getHeartRateValueFromDevice(event.peripheralId);
        yield VitalSignStateSuccess(valueFromDevice: valueHRFromDevice);
      } catch (e) {
        yield VitalSignStateFailure();
      }
    }
    if (event is VitalSignEventInsert) {
      yield VitalSignStateLoading();
      try {
        await sqfLiteHelper.insertVitalSign(event.dto);
        yield VitalSignStateInsertSuccess();
      } catch (e) {
        yield VitalSignStateFailure();
      }
    }
    if (event is VitalSignEventGetList) {
      yield VitalSignStateLoading();
      try {
        final List<VitalSignDTO> list =
            await sqfLiteHelper.getListVitalSign(event.type);
        yield VitalSignStateGetListSuccess(list: list);
      } catch (e) {
        yield VitalSignStateFailure();
      }
    }
  }
}
