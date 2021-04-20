import 'package:equatable/equatable.dart';

abstract class AppointmentDetailEvent extends Equatable {
  const AppointmentDetailEvent();
}

class AppointmentGetDetailEvent extends AppointmentDetailEvent {
  final int appointmentId;

  const AppointmentGetDetailEvent({this.appointmentId})
      : assert(appointmentId != null);

  @override
  // TODO: implement props
  List<Object> get props => [appointmentId];
}
