import 'package:equatable/equatable.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();
}

class ActivityGetTimeEvent extends ActivityEvent {
  final int patientAccountId;
  final int doctorAccountId;

  const ActivityGetTimeEvent({this.patientAccountId, this.doctorAccountId});

  @override
  // TODO: implement props
  List<Object> get props => [patientAccountId, doctorAccountId];
}
