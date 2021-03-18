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
