import 'package:capstone_home_doctor/features/login/events/account_event.dart';
import 'package:capstone_home_doctor/features/login/repositories/account_repository.dart';
import 'package:capstone_home_doctor/features/login/states/account_state.dart';
import 'package:capstone_home_doctor/models/account_token_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final AuthenticateHelper _authenticateHelper = AuthenticateHelper();

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  //
  final AccountRepository accountRepository;
  AccountBloc({this.accountRepository})
      : assert(accountRepository != null),
        super(AccountStateInitial());

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    if (event is AccountEventStartLogin) {}
    if (event is AccountEventCheckLogin) {
      yield AccountStateLoading();
      try {
        //
        final AccountTokenDTO accountTokenDTO =
            await accountRepository.checkLogin(event.dto);
        if (accountTokenDTO != null) {
          //set Shared_Preference here
          await _authenticateHelper.updateAuth(
              true,
              int.tryParse(accountTokenDTO.patientId),
              int.tryParse(accountTokenDTO.accountId));
          yield AccountStateSuccess(accountTokenDTO: accountTokenDTO);
        } else {
          yield AccountStateFailure();
        }
      } catch (e) {
        yield AccountStateFailure();
      }
    }
  }
}
