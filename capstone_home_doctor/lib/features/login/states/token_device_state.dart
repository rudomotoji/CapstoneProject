import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class TokenDeviceState extends Equatable {
  const TokenDeviceState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class TokenDeviceStateInitial extends TokenDeviceState {}

class TokenDeviceStateLoading extends TokenDeviceState {}

class TokenDeviceStateFailure extends TokenDeviceState {}

class TokenDeviceStateSuccess extends TokenDeviceState {
  final bool isUpdateToken;
  const TokenDeviceStateSuccess({@required this.isUpdateToken});

  @override
  // TODO: implement props
  List<Object> get props => [isUpdateToken];
}
