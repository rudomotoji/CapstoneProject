import 'dart:convert';

import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/models/patient_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PatientRepository extends BaseApiClient {
  final http.Client httpClient;
  PatientRepository({@required this.httpClient}) : assert(httpClient != null);
  //
  Future<PatientDTO> getPatientById(int id) async {
    final String url = '/Patients/${id}';
    try {
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        PatientDTO data = PatientDTO.fromJson(jsonDecode(response.body));
        return data;
      }
      return null;
    } catch (e) {
      print('ERROR AT GET DOCTOR BY DOCTOR_ID API $e');
    }
  }
}
