import 'package:capstone_home_doctor/models/appointment_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class AppointmentDetailState extends Equatable {
  const AppointmentDetailState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AppointmentDetailStateInitial extends AppointmentDetailState {}

class AppointmentDetailStateLoading extends AppointmentDetailState {}

class AppointmentDetailStateSuccess extends AppointmentDetailState {
  final AppointmentDetailDTO dto;
  const AppointmentDetailStateSuccess({@required this.dto});

  @override
  // TODO: implement props
  List<Object> get props => [dto];
}

class AppointmentDetailStateFailure extends AppointmentDetailState {}
