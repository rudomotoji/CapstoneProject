import 'package:capstone_home_doctor/models/heart_rate_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class HeartRateState extends Equatable {
  const HeartRateState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class HeartRateStateStateInitial extends HeartRateState {}

class HeartRateStateLoading extends HeartRateState {}

class HeartRateStateSuccess extends HeartRateState {
  final List<HeartRateDTO> listHeartRate;
  const HeartRateStateSuccess({@required this.listHeartRate});

  @override
  // TODO: implement props
  List<Object> get props => [listHeartRate];
}

class HeartRateStateFailure extends HeartRateState {}
