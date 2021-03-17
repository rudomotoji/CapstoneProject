import 'package:capstone_home_doctor/models/account_dto.dart';
import 'package:capstone_home_doctor/models/token_device_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class TokenDeviceEvent extends Equatable {
  const TokenDeviceEvent();
}

class TokenDeviceEventUpdate extends TokenDeviceEvent {
  final TokenDeviceDTO dto;

  TokenDeviceEventUpdate({@required this.dto}) : assert(dto != null);

  @override
  // TODO: implement props
  List<Object> get props => [dto];
}
