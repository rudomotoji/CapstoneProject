import 'package:capstone_home_doctor/models/patient_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class PatientState extends Equatable {
  const PatientState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class PatientStateInitial extends PatientState {}

class PatientStateLoading extends PatientState {}

class PatientStateFailure extends PatientState {}

class PatientStateSuccess extends PatientState {
  // final DoctorDTO result;

  final PatientDTO dto;
  const PatientStateSuccess({@required this.dto});

  @override
  // TODO: implement props
  List<Object> get props => [dto];
}
