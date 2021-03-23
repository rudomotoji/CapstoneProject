import 'package:capstone_home_doctor/features/health/health_record/events/med_ins_create_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/medical_instruction_repository.dart';
import 'package:capstone_home_doctor/features/health/health_record/states/med_ins_create_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class MedInsCreateBloc extends Bloc<MedInsCreateEvent, MedInsCreateState> {
  final MedicalInstructionRepository medicalInstructionRepository;
  MedInsCreateBloc({this.medicalInstructionRepository})
      : assert(medicalInstructionRepository != null),
        super(MedInsCreateStateInitial());

  @override
  Stream<MedInsCreateState> mapEventToState(MedInsCreateEvent event) async* {
    //
    if (event is MedInsCreateEventSend) {
      //
      yield MedInsCreateStateLoading();
      try {
        //
        final bool isCreated = await medicalInstructionRepository
            .createMedicalInstruction(event.dto);
        yield MedInsCreateStateSuccess(isSuccess: isCreated);
      } catch (e) {
        yield MedInsCreateStateFailure();
      }
    }
    if (event is MedInsGetTextEventInitial) {
      yield MedInsCreateStateInitial();
    }
  }
}
