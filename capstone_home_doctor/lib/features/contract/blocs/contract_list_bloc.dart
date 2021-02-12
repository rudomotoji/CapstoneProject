import 'package:capstone_home_doctor/features/contract/events/contract_list_event.dart';
import 'package:capstone_home_doctor/features/contract/repositories/contract_repository.dart';
import 'package:capstone_home_doctor/features/contract/states/contract_list_state.dart';

import 'package:capstone_home_doctor/models/contract_inlist_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContractListBloc extends Bloc<ListContractEvent, ListContractState> {
  final ContractRepository contractAPI;
  ContractListBloc({@required this.contractAPI})
      : assert(contractAPI != null),
        super(ListContractStateInitial());

  @override
  Stream<ListContractState> mapEventToState(ListContractEvent event) async* {
    if (event is ListContractEventSetPatientId) {
      yield ListContractStateLoading();
      try {
        final List<ContractListDTO> list =
            await contractAPI.getListContract(event.id);
        yield ListContractStateSuccess(listContract: list);
      } catch (e) {
        yield ListContractStateFailure();
      }
    }
  }
}
