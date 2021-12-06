import 'package:equatable/equatable.dart';

abstract class DoctorListEvent extends Equatable {
  const DoctorListEvent();
}

class DoctorListEventGetByPatientId extends DoctorListEvent {
  final int patientId;

  const DoctorListEventGetByPatientId({this.patientId});

  @override
  // TODO: implement props
  List<Object> get props => [patientId];
}
