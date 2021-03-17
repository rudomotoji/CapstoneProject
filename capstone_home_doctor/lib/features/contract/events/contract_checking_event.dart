import 'package:capstone_home_doctor/models/req_contract_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class CheckingContractEvent extends Equatable {
  const CheckingContractEvent();
}

class CheckingtContractEventSend extends CheckingContractEvent {
  final int doctorId;
  final int patientId;

  const CheckingtContractEventSend(
      {@required this.doctorId, @required this.patientId})
      : assert(doctorId != null && patientId != null);
  @override
  // TODO: implement props
  List<Object> get props => [doctorId, patientId];
}
