import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class MedInsTypeEvent extends Equatable {
  const MedInsTypeEvent();
}

class MedInsTypeEventGetList extends MedInsTypeEvent {
  final String status;

  const MedInsTypeEventGetList({@required this.status})
      : assert(status != null);

  @override
  // TODO: implement props
  List<Object> get props => [status];
}

//
class MedInsTypeEventGetListToShare extends MedInsTypeEvent {
  final int patientId;
  final String diseaseId;
  final List<int> medicalInstructionsIds;

  const MedInsTypeEventGetListToShare({
    @required this.patientId,
    @required this.diseaseId,
    @required this.medicalInstructionsIds,
  });

  @override
  // TODO: implement props
  List<Object> get props => [patientId, diseaseId, medicalInstructionsIds];
}

// class MedInsTypeRequiredEventGet extends MedInsTypeEvent {
//   final List<String> diseaseIds;

//   const MedInsTypeRequiredEventGet({@required this.diseaseIds});

//   @override
//   // TODO: implement props
//   List<Object> get props => [diseaseIds];
// }

////
abstract class MedInsTypeReqEvent extends Equatable {
  const MedInsTypeReqEvent();
}

class MedInsTypeReqEventGet extends MedInsTypeReqEvent {
  final List<String> diseaseIds;

  const MedInsTypeReqEventGet({@required this.diseaseIds});

  @override
  // TODO: implement props
  List<Object> get props => [diseaseIds];
}
