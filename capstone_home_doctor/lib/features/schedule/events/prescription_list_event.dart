import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class PrescriptionListEvent extends Equatable {
  const PrescriptionListEvent();
}

class PrescriptionListEventsetPatientId extends PrescriptionListEvent {
  final int patientId;

  const PrescriptionListEventsetPatientId({@required this.patientId})
      : assert(patientId != null);

  @override
  // TODO: implement props
  List<Object> get props => [patientId];
}

class PrescriptionListEventInitial extends PrescriptionListEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
