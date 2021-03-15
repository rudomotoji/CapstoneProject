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
  const MedicalShareStateSuccess({@required this.listMedicalShare});

  @override
  // TODO: implement props
  List<Object> get props => [listMedicalShare];
}
