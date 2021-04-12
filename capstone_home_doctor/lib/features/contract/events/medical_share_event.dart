import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class MedicalShareEvent extends Equatable {
  const MedicalShareEvent();
}

class MedicalShareEventGet extends MedicalShareEvent {
  final int patientId;
  final int medicalInstructionType;
  final String diseaseId;

  const MedicalShareEventGet(
      {@required this.patientId,
      @required this.medicalInstructionType,
      @required this.diseaseId})
      : assert(patientId != null &&
            medicalInstructionType != null &&
            diseaseId != null);

  @override
  // TODO: implement props
  List<Object> get props => [patientId, medicalInstructionType, diseaseId];
}

class MedicalShareEventGetMediIns extends MedicalShareEvent {
  final int patientID;
  final int healthRecordId;

  const MedicalShareEventGetMediIns({this.patientID, this.healthRecordId})
      : assert(patientID != null, healthRecordId != null);
  @override
  // TODO: implement props
  List<Object> get props => [patientID, healthRecordId];
}
