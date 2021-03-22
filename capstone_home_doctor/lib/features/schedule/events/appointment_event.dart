import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();
}

class AppointmentGetListEvent extends AppointmentEvent {
  final int patientId;
  final String date;

  const AppointmentGetListEvent({this.patientId, this.date})
      : assert(patientId != null);

  @override
  // TODO: implement props
  List<Object> get props => [patientId];
}

class AppointmentCancelEvent extends AppointmentEvent {
  final int appointmentId;
  final String reasonCancel;

  const AppointmentCancelEvent({this.appointmentId, this.reasonCancel});

  @override
  // TODO: implement props
  List<Object> get props => [appointmentId, reasonCancel];
}
