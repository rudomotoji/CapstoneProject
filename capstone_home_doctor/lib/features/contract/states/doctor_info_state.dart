import 'package:capstone_home_doctor/models/doctor_dto.dart';
import 'package:capstone_home_doctor/models/doctor_tracking_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class DoctorInfoState extends Equatable {
  const DoctorInfoState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DoctorInfoStateInitial extends DoctorInfoState {}

class DoctorInfoStateLoading extends DoctorInfoState {}

class DoctorInfoStateFailure extends DoctorInfoState {}

class DoctorInfoStateSuccess extends DoctorInfoState {
  // final DoctorDTO result;

  final DoctorDTO dto;
  final List<DoctorDTO> listDoctors;
  final List<DoctorTrackingDTO> listDoctorTracking;
  const DoctorInfoStateSuccess(
      {this.dto, this.listDoctors, this.listDoctorTracking});

  @override
  // TODO: implement props
  List<Object> get props => [dto];
}
