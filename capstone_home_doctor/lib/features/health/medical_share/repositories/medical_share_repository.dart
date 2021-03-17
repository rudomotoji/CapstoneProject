import 'dart:convert';

import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MedicalShareInsRepository extends BaseApiClient {
  final http.Client httpClient;

  MedicalShareInsRepository({@required this.httpClient})
      : assert(httpClient != null);

  Future<bool> shareMoreMedIns(
      int contractID, List<int> listMedicalShare) async {
    String url = 'MedicalInstructionShares?contractId=${contractID}';
    try {
      final response = await postApi(url, null, listMedicalShare);
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('ERROR AT GET LIST HEALTH RECORD ${e.toString()}');
    }
  }
}
