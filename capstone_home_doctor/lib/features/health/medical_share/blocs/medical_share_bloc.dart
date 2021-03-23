import 'package:capstone_home_doctor/features/health/medical_share/events/medical_Share_event.dart';
import 'package:capstone_home_doctor/features/health/medical_share/repositories/medical_share_repository.dart';
import 'package:capstone_home_doctor/features/health/medical_share/states/medical_share_state.dart';
import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:capstone_home_doctor/services/medical_share_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final MedicalShareHelper _medicalShareHelper = MedicalShareHelper();

class MedicalShareInsBloc
    extends Bloc<MedicalShareInsEvent, MedicalShareInsState> {
  final MedicalShareInsRepository medicalShareInsRepository;
  MedicalShareInsBloc({@required this.medicalShareInsRepository})
      : assert(medicalShareInsRepository != null),
        super(MedicalShareInsStateInitial());

  @override
  Stream<MedicalShareInsState> mapEventToState(
      MedicalShareInsEvent event) async* {
    if (event is MedicalShareInsEventSend) {
      yield MedicalShareInsStateLoading();
      try {
        final bool isShared = await medicalShareInsRepository.shareMoreMedIns(
            event.contractID, event.listMediIns);
        if (isShared) {
          await _medicalShareHelper.updateMedicalShareChecking(isShared);
          yield MedicalShareInsStateSuccess(isShared: isShared);
        } else {
          yield MedicalShareInsStateFailure();
        }
      } catch (e) {
        yield MedicalShareInsStateFailure();
      }
    }
    if (event is MedicalShareInsEventInitial) {
      yield MedicalShareInsStateInitial();
    }
    if (event is MedicalShareInsEventGetMedIns) {
      yield MedicalShareInsStateLoading();
      try {
        List<MedicalInstructionByTypeDTO> listMedIns =
            await medicalShareInsRepository
                .getShareMoreMedIns(event.contractID);
        yield MedicalShareInsGetStateSuccess(listMedIns: listMedIns);
      } catch (e) {
        yield MedicalShareInsStateFailure();
      }
    }
  }
}
