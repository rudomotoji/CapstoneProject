import 'package:capstone_home_doctor/features/activity/event/doctor_list_event.dart';
import 'package:capstone_home_doctor/features/activity/state/doctor_info_state.dart';
import 'package:capstone_home_doctor/features/contract/repositories/doctor_repository.dart';
import 'package:capstone_home_doctor/models/doctor_list_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/cupertino.dart';

class DoctorListBloc extends Bloc<DoctorListEvent, DoctorListState> {
  final DoctorRepository doctorrepository;

  DoctorListBloc({@required this.doctorrepository})
      : assert(doctorrepository != null),
        super(DoctorListStateInitial());

  @override
  Stream<DoctorListState> mapEventToState(DoctorListEvent event) async* {
    // TODO: implement mapEventToState
    if (event is DoctorListEventGetByPatientId) {
      yield DoctorListStateLoading();
      try {
        //
        final List<DoctorListDTO> list =
            await doctorrepository.getListDoctorByPatient(event.patientId);
        yield DoctorListStateSuccess(list: list);
      } catch (e) {
        yield DoctorListStateFailure();
      }
    }
  }
}
