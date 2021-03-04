import 'package:capstone_home_doctor/features/login/events/account_event.dart';
import 'package:capstone_home_doctor/features/login/repositories/account_repository.dart';
import 'package:capstone_home_doctor/features/login/states/account_state.dart';
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
    if (event is AccountEventCheckLogin) {
      yield AccountStateLoading();
      try {
        //
        final int isLoggedIn = await accountRepository.checkLogin(event.dto);
        if (isLoggedIn != null) {
          //set Shared_Preference here
          await _authenticateHelper.updateAuth(true, isLoggedIn);
          yield AccountStateSuccess(isLoggedIn: isLoggedIn);
        } else {
          yield AccountStateFailure();
        }
      } catch (e) {
        yield AccountStateFailure();
      }
    }
  }
}
