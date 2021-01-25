import 'package:capstone_home_doctor/models/doctor_dto.dart';
import 'package:equatable/equatable.dart';

abstract class DoctorInfoEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DoctorInfoSetIdEvent extends DoctorInfoEvent {
  String id;

  DoctorInfoSetIdEvent({this.id});
}
