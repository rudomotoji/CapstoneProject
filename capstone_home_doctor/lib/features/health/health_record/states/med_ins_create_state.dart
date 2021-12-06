import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class MedInsCreateState extends Equatable {
  //
  const MedInsCreateState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class MedInsCreateStateInitial extends MedInsCreateState {}

class MedInsCreateStateLoading extends MedInsCreateState {}

class MedInsCreateStateSuccess extends MedInsCreateState {
  final bool isSuccess;
  const MedInsCreateStateSuccess({@required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class MedInsCreateStateFailure extends MedInsCreateState {}
