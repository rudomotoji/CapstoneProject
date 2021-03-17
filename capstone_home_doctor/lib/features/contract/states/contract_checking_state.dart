import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class CheckingContractState extends Equatable {
  const CheckingContractState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CheckingContractStateInitial extends CheckingContractState {}

class CheckingContractStateLoading extends CheckingContractState {}

class CheckingContractStateFailure extends CheckingContractState {}

class CheckingContractStateSuccess extends CheckingContractState {
  final bool isRequested;
  const CheckingContractStateSuccess({@required this.isRequested});
  @override
  // TODO: implement props
  List<Object> get props => [isRequested];
}
