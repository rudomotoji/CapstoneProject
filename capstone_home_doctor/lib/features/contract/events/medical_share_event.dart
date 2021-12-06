import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class MedicalShareEvent extends Equatable {
  const MedicalShareEvent();
}

class MedicalShareEventGet extends MedicalShareEvent {
  final int patientId;
  final int medicalInstructionType;
  final String diseaseId;
  final List<int> medicalInstructionIds;

  const MedicalShareEventGet(
      {@required this.patientId,
      @required this.medicalInstructionType,
      @required this.diseaseId,
      this.medicalInstructionIds});
  // : assert(patientId != null &&
  //       medicalInstructionType != null &&
  //       diseaseId != null &&
  //       medicalInstructionIds != null);

  @override
  // TODO: implement props
  List<Object> get props =>
      [patientId, medicalInstructionType, diseaseId, medicalInstructionIds];
}

class MedicalShareEventGetMediIns extends MedicalShareEvent {
  final int patientID;
  final int healthRecordId;
  final int typeID;

  const MedicalShareEventGetMediIns(
      {this.patientID, this.healthRecordId, this.typeID})
      : assert(patientID != null, healthRecordId != null);
  @override
  // TODO: implement props
  List<Object> get props => [patientID, healthRecordId, typeID];
}
