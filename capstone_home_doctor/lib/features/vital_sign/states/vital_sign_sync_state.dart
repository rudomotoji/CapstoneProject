import 'package:capstone_home_doctor/models/vital_sign_sync_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class VitalSignSyncState extends Equatable {
  const VitalSignSyncState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class VitalSignSyncStateInitial extends VitalSignSyncState {}

class VitalSignSyncStateLoading extends VitalSignSyncState {}

class VitalSignSyncStateFailure extends VitalSignSyncState {}

class VitalSignSyncStateSuccess extends VitalSignSyncState {
  final VitalSignSyncDTO dto;

  const VitalSignSyncStateSuccess({@required this.dto});

  @override
  // TODO: implement props
  List<Object> get props => [dto];
}
