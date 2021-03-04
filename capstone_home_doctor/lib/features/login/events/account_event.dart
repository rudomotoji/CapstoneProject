import 'package:capstone_home_doctor/models/account_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();
}

class AccountEventCheckLogin extends AccountEvent {
  final AccountDTO dto;

  const AccountEventCheckLogin({@required this.dto});

  @override
  // TODO: implement props
  List<Object> get props => [dto];
}
