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
    String errorMsg = '';
    if (event is AccountEventStartScreen) {
      AuthenticateHelper _authenticateHelper = AuthenticateHelper();
      yield AccountStateLoading();
      try {
        //
        _authenticateHelper.isAuthenticated().then((value) async* {
          if (value == true) {
            //
            yield AccountStateAuthenticated();
          } else {
            //
            yield AccountStateUnauthenticate();
          }
        });
      } catch (e) {
        print('ERROR AT NAVIGATOR AUTHENTICATE: ${e}');
        yield AccountStateUnauthenticate();
      }
    }
    //
    // if (event is AccountEventCheckingFailed) {}
    // //
    if (event is AccountEventCheckLogin) {
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
          errorMsg = 'Vui lòng nhập đủ tên đăng nhập và mật khẩu.';
          yield AccountStateFailure(errorMsg: errorMsg);
        }
      } catch (e) {
        errorMsg = 'Vui lòng kiểm tra kết nối mạng.';
        print('ERROR AT EVENT CHECK LOGIN: ${e}');
        yield AccountStateFailure(errorMsg: errorMsg);
      }
    }
  }
}
