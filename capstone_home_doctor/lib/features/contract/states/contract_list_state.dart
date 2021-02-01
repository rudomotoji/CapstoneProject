import 'package:capstone_home_doctor/models/contract_inlist_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ListContractState extends Equatable {
  const ListContractState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ListContractStateInitial extends ListContractState {}

class ListContractStateLoading extends ListContractState {}

class ListContractStateSuccess extends ListContractState {
  final List<ContractListDTO> listContract;
  const ListContractStateSuccess({@required this.listContract});

  @override
  // TODO: implement props
  List<Object> get props => [listContract];
}

class ListContractStateFailure extends ListContractState {}
