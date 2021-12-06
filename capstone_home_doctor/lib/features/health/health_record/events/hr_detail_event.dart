import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class HealthRecordEvent extends Equatable {
  const HealthRecordEvent();
}

class HealthRecordEventGetById extends HealthRecordEvent {
  final int id;

  const HealthRecordEventGetById({@required this.id});

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class HealthRecordEventInitial extends HealthRecordEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
