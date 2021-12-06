import 'package:capstone_home_doctor/models/med_ins_by_disease_dto.dart';
import 'package:capstone_home_doctor/models/medical_share_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class MedicalShareState extends Equatable {
  const MedicalShareState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class MedicalShareStateInitial extends MedicalShareState {}

class MedicalShareStateLoading extends MedicalShareState {}

class MedicalShareStateFailure extends MedicalShareState {}

class MedicalShareStateSuccess extends MedicalShareState {
  final List<MedicalShareDTO> listMedicalShare;
  final List<MedInsByDiseaseDTO> listMedicalInsShare;

  const MedicalShareStateSuccess(
      {this.listMedicalShare, this.listMedicalInsShare});

  @override
  // TODO: implement props
  List<Object> get props => [listMedicalShare];
}
