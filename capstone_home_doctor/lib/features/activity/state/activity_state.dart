import 'package:capstone_home_doctor/models/time_activity_dto.dart';
import 'package:equatable/equatable.dart';

abstract class ActivityState extends Equatable {
  const ActivityState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ActivityStateInitial extends ActivityState {}

class ActivityStateLoading extends ActivityState {}

class ActivityStateSuccess extends ActivityState {
  final List<TimeActDTO> list;

  const ActivityStateSuccess({this.list});

  @override
  // TODO: implement props
  List<Object> get props => [list];
}

class ActivityStateFailure extends ActivityState {}
