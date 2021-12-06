import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class RealtimeState extends Equatable {
  const RealtimeState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class RealtimeStateInitial extends RealtimeState {}

class RealtimeStateLoading extends RealtimeState {}

class RealtimeStateFailure extends RealtimeState {}

class RealtimeStateSuccessful extends RealtimeState {
  final int valueKickedOn;
  const RealtimeStateSuccessful({@required this.valueKickedOn});

  @override
  // TODO: implement props
  List<Object> get props => [valueKickedOn];
}
