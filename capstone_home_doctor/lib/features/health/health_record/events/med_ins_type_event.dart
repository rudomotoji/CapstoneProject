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

  const MedInsTypeEventGetListToShare({@required this.patientId})
      : assert(patientId != null);

  @override
  // TODO: implement props
  List<Object> get props => [patientId];
}

class MedInsTypeRequiredEventGet extends MedInsTypeEvent {
  final List<String> diseaseIds;

  const MedInsTypeRequiredEventGet({@required this.diseaseIds});

  @override
  // TODO: implement props
  List<Object> get props => [diseaseIds];
}
