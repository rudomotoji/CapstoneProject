import 'package:capstone_home_doctor/models/appointment_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AppointmentStateInitial extends AppointmentState {}

class AppointmentStateLoading extends AppointmentState {}

class AppointmentStateFailure extends AppointmentState {}

class AppointmentStateSuccess extends AppointmentState {
  final AppointmentDTO appointmentDTO;
  final List<AppointmentDTO> listAppointments;
  const AppointmentStateSuccess({this.appointmentDTO, this.listAppointments});

  @override
  // TODO: implement props
  List<Object> get props => [appointmentDTO, listAppointments];
}
