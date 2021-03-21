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

class AppointmentStateSuccess extends AppointmentState {
  final List<AppointmentDTO> listAppointment;
  const AppointmentStateSuccess({@required this.listAppointment});

  @override
  // TODO: implement props
  List<Object> get props => [listAppointment];
}

class AppointmentStateFailure extends AppointmentState {}
