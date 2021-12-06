import 'package:capstone_home_doctor/features/contract/events/contract_id_now_event.dart';
import 'package:capstone_home_doctor/features/contract/repositories/contract_repository.dart';
import 'package:capstone_home_doctor/features/contract/states/contract_id_now_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContractIdNowBloc extends Bloc<ContractIdNowEvent, ContractIdNowState> {
  //
  final ContractRepository contractRepository;
  ContractIdNowBloc({this.contractRepository})
      : assert(contractRepository != null),
        super(ContractIdNowStateInitial());

  @override
  Stream<ContractIdNowState> mapEventToState(ContractIdNowEvent event) async* {
    if (event is ContractIdNowEventSetPIdAndDId) {
      yield ContractIdNowStateLoading();
      try {
        //
        final int id =
            await contractRepository.getIdContractNow(event.dId, event.pId);
        if (id != null) {
          yield ContractIdNowStateSuccess(id: id);
        } else {
          yield ContractIdNowStateFailure();
        }
      } catch (e) {
        yield ContractIdNowStateFailure();
      }
    }
  }
}
