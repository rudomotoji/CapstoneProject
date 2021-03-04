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
  final int isLoggedIn;
  const AccountStateSuccess({@required this.isLoggedIn});

  @override
  // TODO: implement props
  List<Object> get props => [isLoggedIn];
}
