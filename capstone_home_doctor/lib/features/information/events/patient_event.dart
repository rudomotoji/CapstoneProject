import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class PatientEvent extends Equatable {
  const PatientEvent();
}

class PatientEventSetId extends PatientEvent {
  final int id;

  const PatientEventSetId({@required this.id});

  @override
  // TODO: implement props
  List<Object> get props => [id];
}
