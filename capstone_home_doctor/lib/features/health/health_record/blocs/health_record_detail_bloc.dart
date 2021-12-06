import 'package:capstone_home_doctor/features/health/health_record/events/hr_detail_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/health_record_repository.dart';
import 'package:capstone_home_doctor/features/health/health_record/states/hr_detail_state.dart';
import 'package:capstone_home_doctor/models/health_record_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HealthRecordDetailBloc
    extends Bloc<HealthRecordEvent, HealthRecordDetailState> {
  //
  final HealthRecordRepository healthRecordRepository;
  HealthRecordDetailBloc({this.healthRecordRepository})
      : assert(healthRecordRepository != null),
        super(HealthRecordDetailStateInitial());

  @override
  Stream<HealthRecordDetailState> mapEventToState(
      HealthRecordEvent event) async* {
    if (event is HealthRecordEventGetById) {
      yield HealthRecordDetailStateLoading();
      try {
        final HealthRecordDTO dto =
            await healthRecordRepository.getHealthRecordById(event.id);
        yield HealthRecordDetailStateSuccess(healthRecordDTO: dto);
      } catch (e) {
        HealthRecordDetailStateFailure();
      }
    }
    if (event is HealthRecordEventInitial) {
      yield HealthRecordDetailStateInitial();
    }
  }
}
