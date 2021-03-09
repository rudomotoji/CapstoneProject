import 'package:capstone_home_doctor/models/account_token_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class AccountState extends Equatable {
  const AccountState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AccountStateInitial extends AccountState {}

class AccountStateLoading extends AccountState {}

class AccountStateFailure extends AccountState {}

class AccountStateSuccess extends AccountState {
  final AccountTokenDTO accountTokenDTO;
  const AccountStateSuccess({@required this.accountTokenDTO});

  @override
  // TODO: implement props
  List<Object> get props => [accountTokenDTO];
}
