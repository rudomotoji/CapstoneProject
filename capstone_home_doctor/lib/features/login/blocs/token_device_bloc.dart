import 'package:capstone_home_doctor/features/login/events/token_device_event.dart';
import 'package:capstone_home_doctor/features/login/repositories/account_repository.dart';

import 'package:capstone_home_doctor/features/login/states/token_device_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class TokenDeviceBloc extends Bloc<TokenDeviceEvent, TokenDeviceState> {
  //
  final AccountRepository accountRepository;
  TokenDeviceBloc({this.accountRepository})
      : assert(accountRepository != null),
        super(TokenDeviceStateInitial());

  @override
  Stream<TokenDeviceState> mapEventToState(TokenDeviceEvent event) async* {
    if (event is TokenDeviceEventUpdate) {
      yield TokenDeviceStateLoading();
      try {
        //
        final bool isUpdatedToken =
            await accountRepository.sendTokenDevice(event.dto);
        if (isUpdatedToken) {
          yield TokenDeviceStateSuccess(isUpdateToken: isUpdatedToken);
        } else {
          yield TokenDeviceStateFailure();
        }
      } catch (e) {
        yield TokenDeviceStateFailure();
      }
    }
  }
}
