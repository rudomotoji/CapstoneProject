import 'package:capstone_home_doctor/features/contract/events/contract_checking_event.dart';
import 'package:capstone_home_doctor/features/contract/repositories/contract_repository.dart';
import 'package:capstone_home_doctor/features/contract/states/contract_checking_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckingContractBloc
    extends Bloc<CheckingContractEvent, CheckingContractState> {
  final ContractRepository requestContractAPI;
  CheckingContractBloc({@required this.requestContractAPI})
      : assert(requestContractAPI != null),
        super(CheckingContractStateInitial());

  @override
  Stream<CheckingContractState> mapEventToState(
      CheckingContractEvent event) async* {
    if (event is CheckingtContractEventSend) {
      yield CheckingContractStateLoading();
      try {
        final bool isRequested = await requestContractAPI.checkContractToCreate(
            event.doctorId, event.patientId);
        if (isRequested) {
          yield CheckingContractStateSuccess(isRequested: isRequested);
        } else {
          yield CheckingContractStateFailure();
        }
      } catch (e) {
        yield CheckingContractStateFailure();
      }
    }
  }
}
