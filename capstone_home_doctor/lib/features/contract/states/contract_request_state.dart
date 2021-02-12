import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class RequestContractState extends Equatable {
  const RequestContractState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class RequestContractStateInitial extends RequestContractState {}

class RequestContractStateLoading extends RequestContractState {}

class RequestContractStateFailure extends RequestContractState {}

class RequestContractStateSuccess extends RequestContractState {
  final bool isRequested;
  const RequestContractStateSuccess({@required this.isRequested});
  @override
  // TODO: implement props
  List<Object> get props => [isRequested];
}
