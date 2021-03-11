import 'package:capstone_home_doctor/models/med_ins_by_disease_dto.dart';
import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class MedInsWithTypeState extends Equatable {
  //
  const MedInsWithTypeState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class MedInsWithTypeStateInitial extends MedInsWithTypeState {}

class MedInsWithTypeStateLoading extends MedInsWithTypeState {}

class MedInsWithTypeStateSuccess extends MedInsWithTypeState {
  final List<MedInsByDiseaseDTO> listMedInsWithType;
  const MedInsWithTypeStateSuccess({@required this.listMedInsWithType});

  @override
  List<Object> get props => [listMedInsWithType];
}

class MedInsWithTypeStateFailure extends MedInsWithTypeState {}
