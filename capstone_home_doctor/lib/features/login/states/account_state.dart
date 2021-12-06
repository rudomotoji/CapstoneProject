import 'package:capstone_home_doctor/models/account_token_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class AccountState extends Equatable {
  const AccountState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

// first of all
class AccountStateInitial extends AccountState {}

//before navigate screen login or dashboard
class AccountStateLoading extends AccountState {}

//unauthenticate account
class AccountStateUnauthenticate extends AccountState {}

//authenticated account
class AccountStateAuthenticated extends AccountState {}

//CHECK LOGIN
//for check login failed
class AccountStateFailure extends AccountState {
  final String errorMsg;
  const AccountStateFailure({@required this.errorMsg});

  @override
  // TODO: implement props
  List<Object> get props => [errorMsg];
}

//checking login
class AccountStateChecking extends AccountState {}

//for check login successful
class AccountStateSuccess extends AccountState {
  final AccountTokenDTO accountTokenDTO;
  const AccountStateSuccess({@required this.accountTokenDTO});

  @override
  // TODO: implement props
  List<Object> get props => [accountTokenDTO];
}
