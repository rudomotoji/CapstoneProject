import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class VitalScheduleEvent extends Equatable {
  const VitalScheduleEvent();
}

class VitalScheduleEventGet extends VitalScheduleEvent {
  final int patientId;

  const VitalScheduleEventGet({@required this.patientId});

  @override
  // TODO: implement props
  List<Object> get props => [patientId];
}
