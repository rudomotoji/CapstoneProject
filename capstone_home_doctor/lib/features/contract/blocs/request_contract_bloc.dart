import 'package:capstone_home_doctor/features/contract/events/request_contract_event.dart';
import 'package:capstone_home_doctor/features/contract/repositories/request_contract_repository.dart';
import 'package:capstone_home_doctor/features/contract/states/request_contract_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestContractBloc
    extends Bloc<RequestContractEvent, RequestContractState> {
  final RequestContractRepository requestContractAPI;
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
            await requestContractAPI.makeRequestContract(event.dto);
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
