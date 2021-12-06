import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class MedInsWithTypeEvent extends Equatable {
  const MedInsWithTypeEvent();
}

class MedInsWithTypeEventGetList extends MedInsWithTypeEvent {
  final int patientId;
  final String diseaseId;

  const MedInsWithTypeEventGetList({@required this.patientId, this.diseaseId})
      : assert(patientId != null && diseaseId != null);

  @override
  // TODO: implement props
  List<Object> get props => [patientId, diseaseId];
}

//

class MedInsWithTypeSetChecking extends MedInsWithTypeEvent {
  final bool isCheck;
  final int itemID;
  final int indexMedical;
  final List<MedicalInstructionByTypeDTO> listMedical;
  const MedInsWithTypeSetChecking(
      {@required this.isCheck,
      @required this.itemID,
      @required this.listMedical,
      @required this.indexMedical});

  @override
  // TODO: implement props
  List<Object> get props => [];
}
