import 'package:capstone_home_doctor/models/contract_update_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ContractUpdateState extends Equatable {
  const ContractUpdateState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ContractUpdateStateInitial extends ContractUpdateState {}

class ContractUpdateStateFailure extends ContractUpdateState {}

class ContractUpdateStateSuccess extends ContractUpdateState {
  final bool isUpdated;
  const ContractUpdateStateSuccess({@required this.isUpdated});

  @override
  // TODO: implement props
  List<Object> get props => [isUpdated];
}

class ContractUpdateStateLoading extends ContractUpdateState {}
