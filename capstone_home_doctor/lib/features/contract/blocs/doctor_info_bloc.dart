import 'package:capstone_home_doctor/features/contract/events/doctor_info_event.dart';
import 'package:capstone_home_doctor/features/contract/repositories/doctor_repository.dart';
import 'package:capstone_home_doctor/features/contract/states/doctor_info_state.dart';

import 'package:capstone_home_doctor/models/doctor_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/cupertino.dart';

class DoctorInfoBloc extends Bloc<DoctorInfoEvent, DoctorInfoState> {
  final DoctorRepository doctorAPI;
//
  DoctorInfoBloc({@required this.doctorAPI})
      : assert(doctorAPI != null),
        super(DoctorInfoStateInitial());
  //
  @override
  Stream<DoctorInfoState> mapEventToState(DoctorInfoEvent event) async* {
    if (event is DoctorInfoEventSetId) {
      yield DoctorInfoStateLoading();
      try {
        final DoctorDTO dto = await doctorAPI.getDoctorByDoctorId(event.id);
        yield DoctorInfoStateSuccess(dto: dto);
      } catch (e) {
        yield DoctorInfoStateFailure();
      }
    }
    if (event is DoctorInfoEventGetDoctors) {
      yield DoctorInfoStateLoading();
      try {
        final List<DoctorDTO> lists = await doctorAPI.getListDoctor();
        if (lists.length > 0) {
          yield DoctorInfoStateSuccess(listDoctors: lists);
        } else {
          yield DoctorInfoStateFailure();
        }
      } catch (e) {
        yield DoctorInfoStateFailure();
      }
    }
  }
}
