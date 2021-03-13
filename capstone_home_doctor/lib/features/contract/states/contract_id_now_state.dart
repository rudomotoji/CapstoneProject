import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ContractIdNowState extends Equatable {
  const ContractIdNowState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ContractIdNowStateInitial extends ContractIdNowState {}

class ContractIdNowStateLoading extends ContractIdNowState {}

class ContractIdNowStateSuccess extends ContractIdNowState {
  //
  final int id;
  const ContractIdNowStateSuccess({@required this.id});

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class ContractIdNowStateFailure extends ContractIdNowState {}
