import 'package:capstone_home_doctor/features/health/health_record/events/med_ins_type_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/medical_instruction_repository.dart';
import 'package:capstone_home_doctor/features/health/health_record/states/med_ins_type_list_state.dart';
import 'package:capstone_home_doctor/models/medical_instruction_type_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MedInsTypeListBloc extends Bloc<MedInsTypeEvent, MedInsTypeState> {
  final MedicalInstructionRepository medicalInstructionRepository;
  MedInsTypeListBloc({this.medicalInstructionRepository})
      : assert(medicalInstructionRepository != null),
        super(MedInsTypeStateInitial());

  @override
  Stream<MedInsTypeState> mapEventToState(MedInsTypeEvent event) async* {
    //
    if (event is MedInsTypeEventGetList) {
      //
      yield MedInsTypeStateLoading();
      try {
        //
        final List<MedicalInstructionTypeDTO> list =
            await medicalInstructionRepository
                .getMedicalInstructionType(event.status);
        yield MedInsTypeStateSuccess(listMedInsType: list);
      } catch (e) {
        yield MedInsTypeStateFailure();
      }
    }
  }
}
