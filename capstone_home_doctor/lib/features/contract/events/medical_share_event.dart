import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class MedicalShareEvent extends Equatable {
  const MedicalShareEvent();
}

class MedicalShareEventGet extends MedicalShareEvent {
  final List<String> diseaseIds;
  final int patientId;
  final int medicalInstructionType;

  const MedicalShareEventGet(
      {@required this.diseaseIds,
      @required this.patientId,
      @required this.medicalInstructionType})
      : assert(diseaseIds != null &&
            patientId != null &&
            medicalInstructionType != null);

  @override
  // TODO: implement props
  List<Object> get props => [diseaseIds, patientId, medicalInstructionType];
}
