import 'package:capstone_home_doctor/models/appointment_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();
}

class AppointmentEventGetList extends AppointmentEvent {
  // final List<AppointmentDTO> listAppointments;

  // const AppointmentEventGetList({@required this.listAppointments});

  // @override
  // // TODO: implement props
  // List<Object> get props => [listAppointments];
  final int patientID;

  const AppointmentEventGetList({@required this.patientID});

  @override
  // TODO: implement props
  List<Object> get props => [patientID];
}
