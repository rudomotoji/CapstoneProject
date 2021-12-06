import 'package:capstone_home_doctor/features/health/health_record/events/med_ins_list_with_type_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/medical_instruction_repository.dart';
import 'package:capstone_home_doctor/features/health/health_record/states/med_ins_with_type_state.dart';
import 'package:capstone_home_doctor/models/med_ins_by_disease_dto.dart';
import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MedInsWithTypeListBloc
    extends Bloc<MedInsWithTypeEvent, MedInsWithTypeState> {
  final MedicalInstructionRepository medicalInstructionRepository;
  MedInsWithTypeListBloc({this.medicalInstructionRepository})
      : assert(medicalInstructionRepository != null),
        super(MedInsWithTypeStateInitial());

  @override
  Stream<MedInsWithTypeState> mapEventToState(
      MedInsWithTypeEvent event) async* {
    //
    if (event is MedInsWithTypeEventGetList) {
      //
      yield MedInsWithTypeStateLoading();
      try {
        //
        final List<MedInsByDiseaseDTO> list = await medicalInstructionRepository
            .getMedInsByDisease(event.patientId, event.diseaseId);
        yield MedInsWithTypeStateSuccess(listMedInsWithType: list);
      } catch (e) {
        yield MedInsWithTypeStateFailure();
      }
    }

    // if (event is MedInsWithTypeSetChecking) {
    //   for (var item
    //       in event.listMedical[event.indexMedical].medicalInstructions) {
    //     if (event.itemID == item.medicalInstructionId) {
    //       item.check = event.isCheck;
    //       break;
    //     }
    //   }
    //   yield MedInsWithTypeStateSuccess(listMedInsWithType: event.listMedical);
    // }
  }
}
