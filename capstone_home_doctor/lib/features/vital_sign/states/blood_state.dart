import 'package:capstone_home_doctor/models/vital_sign_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class BloodState extends Equatable {
  const BloodState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class BloodPressureStateInitial extends BloodState {}

class BloodPressureStateLoading extends BloodState {}

class BloodPressureStateFailure extends BloodState {}

class BloodPressureStateGetListSuccess extends BloodState {
  final List<VitalSignDTO> list;
  const BloodPressureStateGetListSuccess({@required this.list});

  @override
  // TODO: implement props
  List<Object> get props => [list];
}
