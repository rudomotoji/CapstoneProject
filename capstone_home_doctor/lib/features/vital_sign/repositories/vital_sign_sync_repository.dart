import 'dart:convert';

import 'package:capstone_home_doctor/models/vital_sign_sync_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:capstone_home_doctor/commons/http/base_api_client.dart';

class VitalSignSyncRepository extends BaseApiClient {
  final http.Client httpClient;
  //
  VitalSignSyncRepository({@required this.httpClient})
      : assert(httpClient != null);
  //
  Future<VitalSignSyncDTO> getVitalSignByDate(
      int patientId, String dateTime) async {
    //
    String url =
        '/VitalSigns/GetVitalSignValueByPatientId?patientId=${patientId}&dateTime=${dateTime}';
    try {
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        VitalSignSyncDTO dto =
            VitalSignSyncDTO.fromJson(jsonDecode(response.body));
        return dto;
      } else {
        return VitalSignSyncDTO();
      }
    } catch (e) {
      print('ERROR at getVitalSignByDate: $e');
    }
  }
}
