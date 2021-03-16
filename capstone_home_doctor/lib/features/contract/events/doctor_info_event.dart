import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class DoctorInfoEvent extends Equatable {
  const DoctorInfoEvent();
}

class DoctorInfoEventSetId extends DoctorInfoEvent {
  final int id;

  const DoctorInfoEventSetId({@required this.id}) : assert(id != null);

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class DoctorInfoEventGetDoctors extends DoctorInfoEvent {
  const DoctorInfoEventGetDoctors();

  @override
  // TODO: implement props
  List<Object> get props => [];
}
