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

class AppointmentChangeDateEvent extends AppointmentEvent {
  final int contractID;
  final int appointmentID;
  final String dateAppointment;

  const AppointmentChangeDateEvent(
      {this.contractID, this.appointmentID, this.dateAppointment});

  @override
  // TODO: implement props
  List<Object> get props => [contractID, appointmentID, dateAppointment];
}
