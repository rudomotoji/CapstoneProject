import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class BloodEvent extends Equatable {
  const BloodEvent();
}

class BloodPressureEventGet extends BloodEvent {
  final String type;
  final int patientId;
  const BloodPressureEventGet({@required this.type, @required this.patientId});

  @override
  // TODO: implement props
  List<Object> get props => [type, patientId];
}
