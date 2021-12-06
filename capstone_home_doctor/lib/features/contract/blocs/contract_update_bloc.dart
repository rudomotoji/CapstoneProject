import 'package:capstone_home_doctor/features/contract/events/contract_update_event.dart';
import 'package:capstone_home_doctor/features/contract/repositories/contract_repository.dart';
import 'package:capstone_home_doctor/features/contract/states/contract_update_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContractUpdateBloc
    extends Bloc<ContractUpdateEvent, ContractUpdateState> {
  final ContractRepository contractRepository;
  ContractUpdateBloc({this.contractRepository})
      : assert(contractRepository != null),
        super(ContractUpdateStateInitial());

  @override
  Stream<ContractUpdateState> mapEventToState(
      ContractUpdateEvent event) async* {
    if (event is ContractUpdateEventUpdate) {
      yield ContractUpdateStateLoading();
      try {
        //
        bool isUpdated = false;

        if (event.dto == null) {
          isUpdated = await contractRepository.changeStatusContract(
              event.urlRespone, event.contractId);
        } else {
          isUpdated = await contractRepository.cancelContract(event.dto);
        }
        // await contractRepository.changeStatusContract(event.dto);
        if (isUpdated) {
          yield ContractUpdateStateSuccess(isUpdated: isUpdated);
        } else {
          //
          yield ContractUpdateStateFailure();
        }
      } catch (e) {
        yield ContractUpdateStateFailure();
      }
    }
  }
}
