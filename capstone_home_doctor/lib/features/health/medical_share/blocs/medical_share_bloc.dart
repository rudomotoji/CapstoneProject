import 'package:capstone_home_doctor/features/health/medical_share/events/medical_Share_event.dart';
import 'package:capstone_home_doctor/features/health/medical_share/repositories/medical_share_repository.dart';
import 'package:capstone_home_doctor/features/health/medical_share/states/medical_share_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MedicalShareInsBloc
    extends Bloc<MedicalShareInsEvent, MedicalShareInsState> {
  final MedicalShareInsRepository medicalShareInsRepository;
  MedicalShareInsBloc({this.medicalShareInsRepository})
      : super(MedicalShareInsStateInitial());

  @override
  Stream<MedicalShareInsState> mapEventToState(
      MedicalShareInsEvent event) async* {
    if (event is MedicalShareInsEventSend) {
      yield MedicalShareInsStateLoading();
      try {
        final bool isShared = await medicalShareInsRepository.shareMoreMedIns(
            event.contractID, event.listMediIns);
        if (isShared) {
          yield MedicalShareInsStateSuccess(isShared: isShared);
        } else {
          yield MedicalShareInsStateFailure();
        }
      } catch (e) {
        yield MedicalShareInsStateFailure();
      }
    }
  }
}
