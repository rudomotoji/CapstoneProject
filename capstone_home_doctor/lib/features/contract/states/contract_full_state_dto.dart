import 'package:capstone_home_doctor/models/contract_full_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ContractFullState extends Equatable {
  const ContractFullState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ContractFullStateInitial extends ContractFullState {}

class ContractFullStateLoading extends ContractFullState {}

class ContractFullStateSuccess extends ContractFullState {
  //
  final ContractFullDTO dto;
  const ContractFullStateSuccess({@required this.dto});

  @override
  // TODO: implement props
  List<Object> get props => [dto];
}

class ContractFullStateFailure extends ContractFullState {}
