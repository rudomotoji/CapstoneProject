import 'package:capstone_home_doctor/features/contract/events/contract_request_event.dart';
import 'package:capstone_home_doctor/features/contract/repositories/contract_repository.dart';
import 'package:capstone_home_doctor/features/contract/states/contract_request_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestContractBloc
    extends Bloc<RequestContractEvent, RequestContractState> {
  final ContractRepository requestContractAPI;
  RequestContractBloc({@required this.requestContractAPI})
      : assert(requestContractAPI != null),
        super(RequestContractStateInitial());

  @override
  Stream<RequestContractState> mapEventToState(
      RequestContractEvent event) async* {
    if (event is RequestContractEventSend) {
      yield RequestContractStateLoading();
      try {
        final bool isRequested =
            await requestContractAPI.createRequestContract(event.dto);
        if (isRequested) {
          yield RequestContractStateSuccess(isRequested: isRequested);
        } else {
          yield RequestContractStateFailure();
        }
      } catch (e) {
        yield RequestContractStateFailure();
      }
    }
  }
}
