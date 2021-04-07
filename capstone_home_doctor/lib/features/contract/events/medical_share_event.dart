import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class MedicalShareEvent extends Equatable {
  const MedicalShareEvent();
}

class MedicalShareEventGet extends MedicalShareEvent {
  final int patientId;
  final int medicalInstructionType;

  const MedicalShareEventGet(
      {@required this.patientId, @required this.medicalInstructionType})
      : assert(patientId != null && medicalInstructionType != null);

  @override
  // TODO: implement props
  List<Object> get props => [patientId, medicalInstructionType];
}

class MedicalShareEventGetMediIns extends MedicalShareEvent {
  final int patientID;
  final int contractID;
  final int healthRecordId;

  const MedicalShareEventGetMediIns(
      {this.patientID, this.contractID, this.healthRecordId})
      : assert(patientID != null, contractID != null);
  @override
  // TODO: implement props
  List<Object> get props => [patientID, contractID];
}
