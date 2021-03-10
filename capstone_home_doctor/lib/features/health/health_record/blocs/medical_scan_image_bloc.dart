import 'package:capstone_home_doctor/features/health/health_record/events/med_ins_create_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/medical_instruction_repository.dart';
import 'package:capstone_home_doctor/features/health/health_record/states/medical_scan_image_state.dart';
import 'package:capstone_home_doctor/models/image_scanner_dto.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class MedInsScanTextBloc extends Bloc<MedInsCreateEvent, MedInsScanTextState> {
  final MedicalInstructionRepository medicalInstructionRepository;
  MedInsScanTextBloc({this.medicalInstructionRepository})
      : assert(medicalInstructionRepository != null),
        super(MedInsScanTextStateInitial());

  @override
  Stream<MedInsScanTextState> mapEventToState(MedInsCreateEvent event) async* {
    if (event is MedInsGetTextEventSend) {
      yield MedInsScanTextStateLoading();
      try {
        final imageScannerDTO data = await medicalInstructionRepository
            .getTextFromImage(event.imagePath);
        yield MedInsScanTextStateSuccess(data: data);
      } catch (e) {
        yield MedInsScanTextStateFailure();
      }
    }
  }
}
