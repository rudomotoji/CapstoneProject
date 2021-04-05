import 'dart:convert';

import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/models/time_activity_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ActivityRepository extends BaseApiClient {
  final http.Client httpClient;

  ActivityRepository({@required this.httpClient}) : assert(httpClient != null);
  //
  //
  Future<List<TimeActDTO>> getListTimeAct(
      int pAccountId, int dAccountId) async {
    //
    final String url =
        '/Notifications/GetDateTimeHaveNotification?accountPatientId=${pAccountId}&accountDoctorID=${dAccountId}';
    try {
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        //
        final responseData = json.decode(response.body) as List;
        List<TimeActDTO> list = responseData.map((dto) {
          return TimeActDTO.fromJson(dto);
        }).toList();
        return list;
      }
    } catch (e) {
      print('ERROR AT  getListTimeAct $e');
    }
  }
}
