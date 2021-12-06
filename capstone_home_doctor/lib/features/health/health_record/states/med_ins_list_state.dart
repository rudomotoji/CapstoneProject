import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class MedicalInstructionListState extends Equatable {
  const MedicalInstructionListState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class MedicalInstructionListStateInitial extends MedicalInstructionListState {}

class MedicalInstructionListStateLoading extends MedicalInstructionListState {}

class MedicalInstructionListStateSuccess extends MedicalInstructionListState {
  final List<MedicalInstructionDTO> listMedIns;
  const MedicalInstructionListStateSuccess({@required this.listMedIns});

  @override
  // TODO: implement props
  List<Object> get props => [listMedIns];
}

class MedicalInstructionListStateFailed extends MedicalInstructionListState {}
