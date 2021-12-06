import 'package:capstone_home_doctor/models/contract_update_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ContractUpdateEvent extends Equatable {
  const ContractUpdateEvent();
}

class ContractUpdateEventUpdate extends ContractUpdateEvent {
  final ContractUpdateDTO dto;
  final String urlRespone;
  final int contractId;

  const ContractUpdateEventUpdate({this.dto, this.urlRespone, this.contractId});

  @override
  // TODO: implement props
  List<Object> get props => [dto, urlRespone, contractId];
}
