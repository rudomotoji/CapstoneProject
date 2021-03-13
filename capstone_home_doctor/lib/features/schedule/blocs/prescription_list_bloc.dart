import 'package:capstone_home_doctor/features/schedule/events/prescription_list_event.dart';
import 'package:capstone_home_doctor/features/schedule/repositories/prescription_repository.dart';
import 'package:capstone_home_doctor/features/schedule/states/prescription_list_state.dart';
import 'package:capstone_home_doctor/models/prescription_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrescriptionListBloc
    extends Bloc<PrescriptionListEvent, PrescriptionListState> {
  final PrescriptionRepository prescriptionRepository;
  PrescriptionListBloc({this.prescriptionRepository})
      : assert(prescriptionRepository != null),
        super(PrescriptionListStateInitial());

  @override
  Stream<PrescriptionListState> mapEventToState(
      PrescriptionListEvent event) async* {
    if (event is PrescriptionListEventsetPatientId) {
      yield PrescriptionListStateLoading();
      try {
        final List<PrescriptionDTO> list =
            await prescriptionRepository.getListPrecription(event.patientId);
        yield PrescriptionListStateSuccess(listPrescription: list);
      } catch (e) {
        yield PrescriptionListStateFailure();
      }
    }
  }
}
