import 'package:capstone_home_doctor/features/health/health_record/events/med_ins_list_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/medical_instruction_repository.dart';
import 'package:capstone_home_doctor/features/health/health_record/states/med_ins_list_state.dart';
import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MedicalInstructionListBloc
    extends Bloc<MedicalInstructionListEvent, MedicalInstructionListState> {
  final MedicalInstructionRepository medicalInstructionRepository;
  MedicalInstructionListBloc({this.medicalInstructionRepository})
      : assert(medicalInstructionRepository != null),
        super(MedicalInstructionListStateInitial());

  @override
  Stream<MedicalInstructionListState> mapEventToState(
      MedicalInstructionListEvent event) async* {
    //
    if (event is MedicalInstructionListEventGetList) {
      yield MedicalInstructionListStateLoading();
      try {
        //
        final List<MedicalInstructionDTO> list =
            await medicalInstructionRepository
                .getListMedicalInstruction(event.hrId);
        yield MedicalInstructionListStateSuccess(listMedIns: list);
      } catch (e) {
        yield MedicalInstructionListStateFailed();
      }
    }
  }
}
