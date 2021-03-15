import 'package:capstone_home_doctor/features/health/health_record/events/hr_create_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/health_record_repository.dart';
import 'package:capstone_home_doctor/features/health/health_record/states/hr_create_state.dart';
import 'package:capstone_home_doctor/features/medicine/events/appointment_event.dart';
import 'package:capstone_home_doctor/features/medicine/repositories/appoinement_repository.dart';
import 'package:capstone_home_doctor/features/medicine/states/appointment_state.dart';
import 'package:capstone_home_doctor/models/appointment_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final AppointmentRepository appointmentRepository;
  AppointmentBloc({this.appointmentRepository})
      : assert(appointmentRepository != null),
        super(AppointmentStateInitial());

  @override
  Stream<AppointmentState> mapEventToState(AppointmentEvent event) async* {
    if (event is AppointmentEventGetList) {
      yield AppointmentStateLoading();
      try {
        //
        final List<AppointmentDTO> listAppointments =
            await appointmentRepository.getListAppointment(event.patientID);
        yield AppointmentStateSuccess(listAppointments: listAppointments);
      } catch (e) {
        yield AppointmentStateFailure();
      }
    }
  }
}
