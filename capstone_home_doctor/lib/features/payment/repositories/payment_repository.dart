import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentRepository extends BaseApiClient {
  final http.Client httpClient;
  //constructor
  PaymentRepository({@required this.httpClient}) : assert(httpClient != null);

  Future<http.Response> vnpay(int amount, String description) async {
    try {
      String url =
          '/Payments/GetURLPayment?Amount=$amount&OrderDescription=$description&BankCode=NCB';
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to fetch payment');
      }
    } catch (e) {
      print('error payment repo: $e');
      throw Exception('Failed to fetch paymentL $e');
    }
  }
}
