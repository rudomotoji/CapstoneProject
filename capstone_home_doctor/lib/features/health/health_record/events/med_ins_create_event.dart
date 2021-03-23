import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class MedInsCreateEvent extends Equatable {
  const MedInsCreateEvent();
}

class MedInsCreateEventSend extends MedInsCreateEvent {
  final MedicalInstructionDTO dto;

  const MedInsCreateEventSend({@required this.dto});

  @override
  // TODO: implement props
  List<Object> get props => [dto];
}

class MedInsGetTextEventSend extends MedInsCreateEvent {
  final String imagePath;

  const MedInsGetTextEventSend({@required this.imagePath});

  @override
  // TODO: implement props
  List<Object> get props => [imagePath];
}

class MedInsGetTextEventInitial extends MedInsCreateEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
