import 'package:capstone_home_doctor/features/schedule/events/appnt_event.dart';
import 'package:capstone_home_doctor/features/schedule/repositories/appointment_repository.dart';
import 'package:capstone_home_doctor/features/schedule/states/appnt_state.dart';
import 'package:capstone_home_doctor/models/appointment_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointDetailmentBloc
    extends Bloc<AppointmentDetailEvent, AppointmentDetailState> {
  final AppointmentRepository appointmentRepository;
  AppointDetailmentBloc({this.appointmentRepository})
      : assert(appointmentRepository != null),
        super(AppointmentDetailStateInitial());

  @override
  Stream<AppointmentDetailState> mapEventToState(
      AppointmentDetailEvent event) async* {
    if (event is AppointmentGetDetailEvent) {
      yield AppointmentDetailStateLoading();
      try {
        final AppointmentDetailDTO dto = await appointmentRepository
            .getAppointmentByAId(event.appointmentId);
        yield AppointmentDetailStateSuccess(dto: dto);
      } catch (e) {
        yield AppointmentDetailStateFailure();
      }
    }
  }
}
