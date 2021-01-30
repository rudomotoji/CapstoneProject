import 'package:capstone_home_doctor/features/contract/events/list_contract_event.dart';
import 'package:capstone_home_doctor/features/contract/repositories/list_contract_repository.dart';
import 'package:capstone_home_doctor/features/contract/states/list_contract_state.dart';
import 'package:capstone_home_doctor/models/contract_inlist_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContractListBloc extends Bloc<ListContractEvent, ListContractState> {
  final ListContractRepository listContractAPI;
  ContractListBloc({@required this.listContractAPI})
      : assert(listContractAPI != null),
        super(ListContractStateInitial());

  @override
  Stream<ListContractState> mapEventToState(ListContractEvent event) async* {
    if (event is ListContractEventSetPatientId) {
      yield ListContractStateLoading();
      try {
        final List<ContractListDTO> list =
            await listContractAPI.getListContract(event.id);
        yield ListContractStateSuccess(listContract: list);
      } catch (e) {
        yield ListContractStateFailure();
      }
    }
  }
}
