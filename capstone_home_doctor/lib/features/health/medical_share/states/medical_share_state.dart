import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class MedicalShareInsState extends Equatable {
  const MedicalShareInsState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class MedicalShareInsStateInitial extends MedicalShareInsState {}

class MedicalShareInsStateLoading extends MedicalShareInsState {}

class MedicalShareInsStateFailure extends MedicalShareInsState {}

class MedicalShareInsStateSuccess extends MedicalShareInsState {
  final bool isShared;
  const MedicalShareInsStateSuccess({@required this.isShared});

  @override
  // TODO: implement props
  List<Object> get props => [isShared];
}

class MedicalShareInsGetStateSuccess extends MedicalShareInsState {
  final List<MedicalInstructionByTypeDTO> listMedIns;
  const MedicalShareInsGetStateSuccess({this.listMedIns});

  @override
  // TODO: implement props
  List<Object> get props => [];
}
