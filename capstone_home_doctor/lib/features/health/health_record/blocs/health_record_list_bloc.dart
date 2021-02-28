import 'package:capstone_home_doctor/features/health/health_record/events/hr_list_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/health_record_repository.dart';
import 'package:capstone_home_doctor/features/health/health_record/states/hr_list_state.dart';
import 'package:capstone_home_doctor/models/health_record_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HealthRecordListBloc extends Bloc<HRListEvent, HRListState> {
  final HealthRecordRepository healthRecordRepository;
  HealthRecordListBloc({this.healthRecordRepository})
      : assert(healthRecordRepository != null),
        super(HRListStateInitial());

  @override
  Stream<HRListState> mapEventToState(HRListEvent event) async* {
    //
    if (event is HRListEventSetPersonalHRId) {
      //
      yield HRListStateLoading();
      try {
        //
        final List<HealthRecordDTO> list = await healthRecordRepository
            .getListHealthRecord(event.personalHealthRecordId);
        yield HRListStateSuccess(listHealthRecord: list);
      } catch (e) {
        yield HRListStateFailure();
      }
    }
  }
}
