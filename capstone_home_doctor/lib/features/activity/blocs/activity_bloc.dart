import 'package:capstone_home_doctor/features/activity/event/activity_event.dart';
import 'package:capstone_home_doctor/features/activity/repository/activity_repository.dart';
import 'package:capstone_home_doctor/features/activity/state/activity_state.dart';
import 'package:capstone_home_doctor/models/time_activity_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final ActivityRepository activityRepository;

  ActivityBloc({@required this.activityRepository})
      : assert(activityRepository != null),
        super(ActivityStateInitial());

  @override
  Stream<ActivityState> mapEventToState(ActivityEvent event) async* {
    // TODO: implement mapEventToState
    if (event is ActivityGetTimeEvent) {
      yield ActivityStateLoading();
      try {
        //
        final List<TimeActDTO> list = await activityRepository.getListTimeAct(
            event.patientAccountId, event.doctorAccountId);

        yield ActivityStateSuccess(list: list);
      } catch (e) {
        yield ActivityStateFailure();
      }
    }
  }
}
