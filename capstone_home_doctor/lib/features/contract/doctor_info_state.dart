import 'package:capstone_home_doctor/models/doctor_dto.dart';
import 'package:equatable/equatable.dart';

abstract class DoctorInfoState extends Equatable {
  const DoctorInfoState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DoctorInfoStateInitial extends DoctorInfoState {}

class DoctorInfoStateFailure extends DoctorInfoState {}

class DoctorInfoStateSuccess extends DoctorInfoState {
  // final DoctorDTO result;

  final DoctorDTO dto;
  const DoctorInfoStateSuccess({this.dto});

  @override
  // TODO: implement props
  List<Object> get props => [dto];
}
