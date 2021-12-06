import 'package:capstone_home_doctor/features/contract/events/contract_full_event.dart';
import 'package:capstone_home_doctor/features/contract/repositories/contract_repository.dart';
import 'package:capstone_home_doctor/features/contract/states/contract_full_state_dto.dart';
import 'package:capstone_home_doctor/models/contract_full_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContractFullBloc extends Bloc<ContractFullEvent, ContractFullState> {
  //
  final ContractRepository contractRepository;
  ContractFullBloc({this.contractRepository})
      : assert(contractRepository != null),
        super(ContractFullStateInitial());

  @override
  Stream<ContractFullState> mapEventToState(ContractFullEvent event) async* {
    if (event is ContractFullEventSetCId) {
      yield ContractFullStateLoading();
      try {
        //
        final ContractFullDTO dto =
            await contractRepository.getFullContract(event.cId);
        if (dto != null) {
          yield ContractFullStateSuccess(dto: dto);
        } else {
          yield ContractFullStateFailure();
        }
      } catch (e) {
        yield ContractFullStateFailure();
      }
    }
  }
}
