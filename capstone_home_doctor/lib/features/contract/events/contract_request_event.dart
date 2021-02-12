import 'package:capstone_home_doctor/models/req_contract_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class RequestContractEvent extends Equatable {
  const RequestContractEvent();
}

class RequestContractEventSend extends RequestContractEvent {
  final RequestContractDTO dto;

  const RequestContractEventSend({@required this.dto}) : assert(dto != null);
  @override
  // TODO: implement props
  List<Object> get props => [dto];
}
