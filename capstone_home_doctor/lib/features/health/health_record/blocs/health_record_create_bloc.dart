import 'package:capstone_home_doctor/features/health/health_record/events/hr_create_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/health_record_repository.dart';
import 'package:capstone_home_doctor/features/health/health_record/states/hr_create_state.dart';
import 'package:capstone_home_doctor/services/health_record_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HealthRecordCreateBloc extends Bloc<HRCreateEvent, HRCreateState> {
  //
  final HealthRecordRepository healthRecordRepository;
  HealthRecordCreateBloc({this.healthRecordRepository})
      : assert(healthRecordRepository != null),
        super(HRCreateStateInitial());

  final HealthRecordHelper hrHelper = HealthRecordHelper();

  @override
  Stream<HRCreateState> mapEventToState(HRCreateEvent event) async* {
    if (event is HRCreateEventSend) {
      yield HRCreateStateLoading();
      try {
        final int healthRecordID =
            await healthRecordRepository.createHealthRecord(event.dto);
        if (healthRecordID != null) {
          yield HRCreateStateSuccess(isCreateHR: true);
          hrHelper.setHRResponse(healthRecordID);
        } else {
          yield HRCreateStateFailure();
          hrHelper.setHRResponse(0);
        }
      } catch (e) {
        yield HRCreateStateFailure();
      }
    }
    if (event is HRCreateEventInitial) {
      yield HRCreateStateInitial();
    }
  }
}
