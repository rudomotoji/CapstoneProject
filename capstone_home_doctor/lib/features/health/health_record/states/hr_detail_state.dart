import 'package:capstone_home_doctor/models/health_record_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class HealthRecordDetailState extends Equatable {
  const HealthRecordDetailState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class HealthRecordDetailStateInitial extends HealthRecordDetailState {}

class HealthRecordDetailStateLoading extends HealthRecordDetailState {}

class HealthRecordDetailStateFailure extends HealthRecordDetailState {}

class HealthRecordDetailStateSuccess extends HealthRecordDetailState {
  final HealthRecordDTO healthRecordDTO;
  const HealthRecordDetailStateSuccess({@required this.healthRecordDTO});

  @override
  // TODO: implement props
  List<Object> get props => [healthRecordDTO];
}
