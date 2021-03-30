import 'package:capstone_home_doctor/models/vital_sign_schedule_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class VitalScheduleState extends Equatable {
  const VitalScheduleState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class VitalScheduleStateInitial extends VitalScheduleState {}

class VitalScheduleStateLoading extends VitalScheduleState {}

class VitalScheduleStateSuccess extends VitalScheduleState {
  final VitalSignScheduleDTO dto;

  const VitalScheduleStateSuccess({@required this.dto});

  @override
  // TODO: implement props
  List<Object> get props => [dto];
}

class VitalScheduleStateFailure extends VitalScheduleState {}
