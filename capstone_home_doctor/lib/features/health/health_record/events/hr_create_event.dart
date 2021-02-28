import 'package:capstone_home_doctor/models/health_record_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class HRCreateEvent extends Equatable {
  const HRCreateEvent();
}

class HRCreateEventSend extends HRCreateEvent {
  final HealthRecordDTO dto;

  const HRCreateEventSend({@required this.dto});

  @override
  // TODO: implement props
  List<Object> get props => [dto];
}
