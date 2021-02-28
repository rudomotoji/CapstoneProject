import 'package:capstone_home_doctor/models/health_record_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class HRListState extends Equatable {
  //
  const HRListState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class HRListStateInitial extends HRListState {}

class HRListStateLoading extends HRListState {}

class HRListStateSuccess extends HRListState {
  final List<HealthRecordDTO> listHealthRecord;
  const HRListStateSuccess({@required this.listHealthRecord});

  @override
  List<Object> get props => [listHealthRecord];
}

class HRListStateFailure extends HRListState {}
