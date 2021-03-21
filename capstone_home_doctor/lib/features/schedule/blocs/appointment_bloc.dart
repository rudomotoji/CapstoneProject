import 'package:capstone_home_doctor/features/schedule/events/appointment_event.dart';
import 'package:capstone_home_doctor/features/schedule/repositories/appointment_repository.dart';
import 'package:capstone_home_doctor/features/schedule/states/appointment_state.dart';
import 'package:capstone_home_doctor/models/appointment_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final AppointmentRepository appointmentRepository;
  AppointmentBloc({this.appointmentRepository})
      : assert(appointmentRepository != null),
        super(AppointmentStateInitial());

  @override
  Stream<AppointmentState> mapEventToState(AppointmentEvent event) async* {
    if (event is AppointmentGetListEvent) {
      yield AppointmentStateLoading();
      try {
        final List<AppointmentDTO> list = await appointmentRepository
            .getAppointment(event.patientId, event.date);
        yield AppointmentStateSuccess(listAppointment: list);
      } catch (e) {
        yield AppointmentStateFailure();
      }
    }
  }
}
