import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class MedInsWithTypeEvent extends Equatable {
  const MedInsWithTypeEvent();
}

class MedInsWithTypeEventGetList extends MedInsWithTypeEvent {
  final int patientId;

  const MedInsWithTypeEventGetList({@required this.patientId})
      : assert(patientId != null);

  @override
  // TODO: implement props
  List<Object> get props => [patientId];
}

//

class MedInsWithTypeSetChecking extends MedInsWithTypeEvent {
  final bool isCheck;
  const MedInsWithTypeSetChecking({@required this.isCheck});

  @override
  // TODO: implement props
  List<Object> get props => [];
}
