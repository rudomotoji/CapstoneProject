import 'package:capstone_home_doctor/models/vital_sign_detail_dto.dart';
import 'package:capstone_home_doctor/models/vital_sign_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class VitalSignState extends Equatable {
  const VitalSignState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class VitalSignStateInitial extends VitalSignState {}

class VitalSignStateLoading extends VitalSignState {}

class VitalSignDangerStateLoading extends VitalSignState {}

//success getHR
class VitalSignStateSuccess extends VitalSignState {
  final int valueFromDevice;
  const VitalSignStateSuccess({@required this.valueFromDevice});

  @override
  // TODO: implement props
  List<Object> get props => [valueFromDevice];
}

class VitalSignStateFailure extends VitalSignState {}

class VitalSignDangerStateFailure extends VitalSignState {}

//success Insert
class VitalSignStateInsertSuccess extends VitalSignState {}

class VitalSignStateGetListSuccess extends VitalSignState {
  final List<VitalSignDTO> list;
  const VitalSignStateGetListSuccess({@required this.list});

  @override
  // TODO: implement props
  List<Object> get props => [list];
}

class VitalSignDeleteSuccess extends VitalSignState {}

class VitalSignGetListDangerousSuccess extends VitalSignState {
  final List<VitalSignDTO> list;
  const VitalSignGetListDangerousSuccess({@required this.list});

  @override
  // TODO: implement props
  List<Object> get props => [list];
}

class VitalSignGetDetailSuccess extends VitalSignState {
  final VitalSignDetailDTO vitalSignDetailDTO;
  const VitalSignGetDetailSuccess({@required this.vitalSignDetailDTO});

  @override
  // TODO: implement props
  List<Object> get props => [vitalSignDetailDTO];
}
