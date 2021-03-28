import 'package:capstone_home_doctor/features/contract/events/medical_share_event.dart';
import 'package:capstone_home_doctor/features/contract/states/medical_share_state.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/health_record_repository.dart';
import 'package:capstone_home_doctor/models/med_ins_by_disease_dto.dart';
import 'package:capstone_home_doctor/models/medical_share_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MedicalShareBloc extends Bloc<MedicalShareEvent, MedicalShareState> {
  final HealthRecordRepository healthRecordRepository;
  MedicalShareBloc({this.healthRecordRepository})
      : assert(healthRecordRepository != null),
        super(MedicalShareStateInitial());

  @override
  Stream<MedicalShareState> mapEventToState(MedicalShareEvent event) async* {
    if (event is MedicalShareEventGet) {
      yield MedicalShareStateLoading();
      try {
        final List<MedicalShareDTO> list =
            await healthRecordRepository.getListMedicalShare(event.diseaseIds,
                event.patientId, event.medicalInstructionType);
        yield MedicalShareStateSuccess(listMedicalShare: list);
      } catch (e) {
        yield MedicalShareStateFailure();
      }
    }

    if (event is MedicalShareEventGetMediIns) {
      yield MedicalShareStateLoading();
      try {
        final List<MedInsByDiseaseDTO> list =
            await healthRecordRepository.getAllMedicalToShare(
                event.patientID, event.contractID, event.healthRecordId);
        yield MedicalShareStateSuccess(listMedicalInsShare: list);
      } catch (e) {
        yield MedicalShareStateFailure();
      }
    }
  }
}
