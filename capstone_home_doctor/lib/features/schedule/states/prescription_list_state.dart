import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:capstone_home_doctor/models/prescription_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class PrescriptionListState extends Equatable {
  const PrescriptionListState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class PrescriptionListStateInitial extends PrescriptionListState {}

class PrescriptionListStateLoading extends PrescriptionListState {}

class PrescriptionListStateSuccess extends PrescriptionListState {
  final List<MedicalInstructionDTO> listPrescription;
  const PrescriptionListStateSuccess({@required this.listPrescription});

  @override
  // TODO: implement props
  List<Object> get props => [listPrescription];
}

class PrescriptionListStateFailure extends PrescriptionListState {}
