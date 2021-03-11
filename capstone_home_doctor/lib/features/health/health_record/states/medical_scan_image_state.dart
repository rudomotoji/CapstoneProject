import 'package:capstone_home_doctor/models/image_scanner_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class MedInsScanTextState extends Equatable {
  //
  const MedInsScanTextState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class MedInsScanTextStateInitial extends MedInsScanTextState {}

class MedInsScanTextStateLoading extends MedInsScanTextState {}

class MedInsScanTextStateSuccess extends MedInsScanTextState {
  final ImageScannerDTO data;
  const MedInsScanTextStateSuccess({@required this.data});

  @override
  List<Object> get props => [data];
}

class MedInsScanTextStateFailure extends MedInsScanTextState {}
