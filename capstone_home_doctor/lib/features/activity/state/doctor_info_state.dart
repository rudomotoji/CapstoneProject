import 'package:capstone_home_doctor/models/doctor_list_dto.dart';
import 'package:equatable/equatable.dart';

abstract class DoctorListState extends Equatable {
  const DoctorListState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DoctorListStateInitial extends DoctorListState {}

class DoctorListStateLoading extends DoctorListState {}

class DoctorListStateSuccess extends DoctorListState {
  final List<DoctorListDTO> list;

  const DoctorListStateSuccess({this.list});

  @override
  // TODO: implement props
  List<Object> get props => [list];
}

class DoctorListStateFailure extends DoctorListState {}
