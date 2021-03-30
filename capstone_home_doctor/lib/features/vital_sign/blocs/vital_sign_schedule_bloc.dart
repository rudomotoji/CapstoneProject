import 'package:capstone_home_doctor/features/vital_sign/events/vital_schedule_event.dart';
import 'package:capstone_home_doctor/features/vital_sign/repositories/vital_sign_repository.dart';
import 'package:capstone_home_doctor/features/vital_sign/states/vital_schedule_state.dart';
import 'package:capstone_home_doctor/models/vital_sign_schedule_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VitalScheduleBloc extends Bloc<VitalScheduleEvent, VitalScheduleState> {
  final VitalSignServerRepository vitalSignServerRepository;
  VitalScheduleBloc({@required this.vitalSignServerRepository})
      : assert(vitalSignServerRepository != null),
        super(VitalScheduleStateInitial());

  @override
  Stream<VitalScheduleState> mapEventToState(VitalScheduleEvent event) async* {
    if (event is VitalScheduleEventGet) {
      yield VitalScheduleStateLoading();
      try {
        final VitalSignScheduleDTO dto = await vitalSignServerRepository
            .getVitalSignSchedule(event.patientId);
        yield VitalScheduleStateSuccess(dto: dto);
      } catch (e) {
        yield VitalScheduleStateFailure();
      }
    }
  }
}
