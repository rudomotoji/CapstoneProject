import 'package:capstone_home_doctor/features/contract/events/disease_list_event.dart';
import 'package:capstone_home_doctor/features/contract/repositories/disease_repository.dart';
import 'package:capstone_home_doctor/features/contract/states/disease_list_state.dart';
import 'package:capstone_home_doctor/models/disease_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiseaseListBloc extends Bloc<DiseaseListEvent, DiseaseListState> {
  final DiseaseRepository diseaseRepository;
  DiseaseListBloc({this.diseaseRepository})
      : assert(diseaseRepository != null),
        super(DiseaseListStateInitial());

  @override
  Stream<DiseaseListState> mapEventToState(DiseaseListEvent event) async* {
    if (event is DiseaseListEventSetStatus) {
      yield DiseaseListStateLoading();
      try {
        final List<DiseaseDTO> list = await diseaseRepository.getListDisease();
        yield DiseaseListStateSuccess(listDisease: list);
      } catch (e) {
        yield DiseaseListStateFailure();
      }
    }
    if (event is DiseaseEventGetHealthList) {
      yield DiseaseListStateLoading();
      try {
        final List<DiseaseDTO> list =
            await diseaseRepository.getHeartDiseases();
        yield DiseaseHeartListStateSuccess(listDisease: list);
      } catch (e) {
        yield DiseaseListStateFailure();
      }
    }
    if (event is DiseaseContractGetList) {
      yield DiseaseListStateLoading();
      try {
        //
        final List<DiseaseContractDTO> list =
            await diseaseRepository.getListDiseaseContract(event.patientId);
        yield DiseaseContractStateSuccess(listDiseaseContract: list);
      } catch (e) {
        yield DiseaseListStateFailure();
      }
    }
  }
}
