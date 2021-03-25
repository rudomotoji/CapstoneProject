import 'package:capstone_home_doctor/models/vital_sign_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class VitalSignEvent extends Equatable {
  const VitalSignEvent();
}

class VitalSignEventGetHeartRateFromDevice extends VitalSignEvent {
  final String peripheralId;
  const VitalSignEventGetHeartRateFromDevice({@required this.peripheralId});
  @override
  // TODO: implement props
  List<Object> get props => [peripheralId];
}

class VitalSignEventInsert extends VitalSignEvent {
  final VitalSignDTO dto;
  const VitalSignEventInsert({@required this.dto});
  @override
  // TODO: implement props
  List<Object> get props => [dto];
}

class VitalSignEventGetList extends VitalSignEvent {
  final String type;
  final int patientId;
  const VitalSignEventGetList({@required this.type, @required this.patientId});

  @override
  // TODO: implement props
  List<Object> get props => [type, patientId];
}

class VitalSignEventDelete extends VitalSignEvent {
  final String valueType;
  final int patientId;

  const VitalSignEventDelete(
      {@required this.valueType, @required this.patientId});

  @override
  // TODO: implement props
  List<Object> get props => [valueType, patientId];
}
