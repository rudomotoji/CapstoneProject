import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class HRCreateState extends Equatable {
  const HRCreateState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class HRCreateStateInitial extends HRCreateState {}

class HRCreateStateLoading extends HRCreateState {}

class HRCreateStateFailure extends HRCreateState {}

class HRCreateStateSuccess extends HRCreateState {
  final bool isCreateHR;
  const HRCreateStateSuccess({@required this.isCreateHR});

  @override
  // TODO: implement props
  List<Object> get props => [isCreateHR];
}
