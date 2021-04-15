import 'package:capstone_home_doctor/features/vital_sign/events/blood_event.dart';
import 'package:capstone_home_doctor/features/vital_sign/events/vital_sign_event.dart';
import 'package:capstone_home_doctor/features/vital_sign/repositories/vital_sign_repository.dart';
import 'package:capstone_home_doctor/features/vital_sign/states/blood_state.dart';
import 'package:capstone_home_doctor/features/vital_sign/states/vital_sign_state.dart';
import 'package:capstone_home_doctor/models/vital_sign_detail_dto.dart';
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
    if (event is VitalSignEventGetList) {
      yield VitalSignStateLoading();
      try {
        final List<VitalSignDTO> list =
            await sqfLiteHelper.getListVitalSign(event.type, event.patientId);
        yield VitalSignStateGetListSuccess(list: list);
      } catch (e) {
        yield VitalSignStateFailure();
      }
    }
  }
}

class VitalSignDeviceBloc extends Bloc<VitalSignEvent, VitalSignState> {
  final SQFLiteHelper sqfLiteHelper;
  final VitalSignRepository vitalSignRepository;
  VitalSignDeviceBloc(
      {@required this.sqfLiteHelper, @required this.vitalSignRepository})
      : assert(sqfLiteHelper != null && vitalSignRepository != null),
        super(VitalSignStateInitial());

  @override
  Stream<VitalSignState> mapEventToState(VitalSignEvent event) async* {
    if (event is VitalSignEventInsert) {
      yield VitalSignStateLoading();
      try {
        await sqfLiteHelper.insertVitalSign(event.dto);
        yield VitalSignStateInsertSuccess();
      } catch (e) {
        yield VitalSignStateFailure();
      }
      return;
    }
    if (event is VitalSignEventGetHeartRateFromDevice) {
      yield VitalSignStateLoading();
      try {
        final int valueHRFromDevice = await vitalSignRepository
            .getHeartRateValueFromDevice(event.peripheralId);

        yield VitalSignStateSuccess(valueFromDevice: valueHRFromDevice);
      } catch (e) {
        yield VitalSignStateFailure();
      }
      return;
    }
  }
}

class VitalSignDetailBloc extends Bloc<VitalSignEvent, VitalSignState> {
  final VitalSignServerRepository vitalSignServerRepository;
  VitalSignDetailBloc({@required this.vitalSignServerRepository})
      : assert(vitalSignServerRepository != null),
        super(VitalSignStateInitial());
//
  @override
  Stream<VitalSignState> mapEventToState(VitalSignEvent event) async* {
    //
    if (event is VitalSignEventGetDetail) {
      yield VitalSignStateLoading();
      try {
        final VitalSignDetailDTO data = await vitalSignServerRepository
            .getVitalSign(event.patientId, event.medicalInstructionId);
        yield VitalSignGetDetailSuccess(vitalSignDetailDTO: data);
      } catch (e) {
        yield VitalSignStateFailure();
      }
    }
  }
}
