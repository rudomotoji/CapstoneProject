import 'package:capstone_home_doctor/features/health/health_record/events/med_ins_get_by_id_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/medical_instruction_repository.dart';
import 'package:capstone_home_doctor/features/health/health_record/states/med_ins_get_by_id_state.dart';
import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/cupertino.dart';

class MedicalInstructionDetailBloc
    extends Bloc<MedInsDetailEvent, MedInsDetailState> {
  final MedicalInstructionRepository medicalInstructionRepository;

  MedicalInstructionDetailBloc({@required this.medicalInstructionRepository})
      : assert(medicalInstructionRepository != null),
        super(MedInsDetailStateInitial());

  @override
  Stream<MedInsDetailState> mapEventToState(MedInsDetailEvent event) async* {
    if (event is MedInsDetailEventGetById) {
      yield MedInsDetailStateLoading();
      try {
        //
        final MedicalInstructionDTO dto = await medicalInstructionRepository
            .getMedicalInstructionById(event.id);
        yield MedInsDetailStateSuccess(dto: dto);
      } catch (e) {
        yield MedInsDetailStateFailure();
      }
    }
  }
}
