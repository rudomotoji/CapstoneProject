import 'dart:convert';

import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/models/req_contract_dto.dart';

class ContractAPI extends BaseApiClient {
  // Future<AccountLogin> login(Account account) async {
  //   try {
  //     final response = await postApi("api/Account/login", account.toJson());
  //     if (response.statusCode == 200) {
  //       final accountLogin = AccountLogin.fromJson(jsonDecode(response.body));
  //       return accountLogin;
  //     } else
  //       return null;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  Future<void> makeRequestAPI(Map<String, String> dtoJson) async {
    final String url = 'api/v1/contracts/request';
    try {
      final request = await postApi(url, null, dtoJson);
    } catch (e) {
      print('ERROR AT MAKE REQUEST API: $e');
    }
  }
}
