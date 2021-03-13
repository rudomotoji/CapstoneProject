import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class MedInsDetailState extends Equatable {
  const MedInsDetailState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class MedInsDetailStateInitial extends MedInsDetailState {}

class MedInsDetailStateFailure extends MedInsDetailState {}

class MedInsDetailStateLoading extends MedInsDetailState {}

class MedInsDetailStateSuccess extends MedInsDetailState {
  final MedicalInstructionDTO dto;

  const MedInsDetailStateSuccess({@required this.dto});

  @override
  // TODO: implement props
  List<Object> get props => [dto];
}
