import 'package:capstone_home_doctor/models/medical_instruction_type_dto.dart';
import 'package:capstone_home_doctor/models/medical_type_required_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class MedInsTypeState extends Equatable {
  //
  const MedInsTypeState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class MedInsTypeStateInitial extends MedInsTypeState {}

class MedInsTypeStateLoading extends MedInsTypeState {}

class MedInsTypeStateSuccess extends MedInsTypeState {
  final List<MedicalInstructionTypeDTO> listMedInsType;
  const MedInsTypeStateSuccess({@required this.listMedInsType});

  @override
  List<Object> get props => [listMedInsType];
}

class MedInsTypeStateFailure extends MedInsTypeState {}

class MedInsTypeRequiredStateSuccess extends MedInsTypeState {
  final List<MedicalTypeRequiredDTO> list;
  const MedInsTypeRequiredStateSuccess({@required this.list});

  @override
  List<Object> get props => [list];
}
