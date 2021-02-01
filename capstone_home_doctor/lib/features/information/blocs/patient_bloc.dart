import 'package:capstone_home_doctor/features/information/events/patient_event.dart';
import 'package:capstone_home_doctor/features/information/repositories/patient_repository.dart';
import 'package:capstone_home_doctor/features/information/states/patient_state.dart';
import 'package:capstone_home_doctor/models/patient_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final PatientRepository patientRepository;
//
  PatientBloc({@required this.patientRepository})
      : assert(patientRepository != null),
        super(PatientStateInitial());
  //
  @override
  Stream<PatientState> mapEventToState(PatientEvent event) async* {
    if (event is PatientEventSetId) {
      yield PatientStateLoading();
      try {
        final PatientDTO dto = await patientRepository.getPatientById(event.id);
        yield PatientStateSuccess(dto: dto);
      } catch (e) {
        yield PatientStateFailure();
      }
    }
  }
}
