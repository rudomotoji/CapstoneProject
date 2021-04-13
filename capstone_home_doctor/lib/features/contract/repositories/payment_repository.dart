import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentRepository extends BaseApiClient {
  final http.Client httpClient;
  //constructor
  PaymentRepository({@required this.httpClient}) : assert(httpClient != null);

  Future<http.Response> vnpay(String contract) async {
    // final response = await http.post(
    //     EnvHelper.getApiURL(
    //         EnvHelper.host, EnvHelper.port, PaymentApi.vnpayUrl(orderInfo)),
    //     headers: {
    //       'accept': 'aplication/json',
    //     });
    // if (response.statusCode == 200) {
    //   return response;
    // } else {
    //   throw Exception('Failed to fetch payment');
    // }
    //
    try {
      String url = 'api/v1/payment?contract=${contract}';
      final response = await postApi(url, null, null);
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to fetch payment');
      }
    } catch (e) {
      print('error payment repo: $e');
    }
  }
}
