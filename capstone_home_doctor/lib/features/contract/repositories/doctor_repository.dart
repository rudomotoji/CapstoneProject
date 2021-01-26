import 'dart:convert';

import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/models/doctor_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//remove extends BaseApiClient
class DoctorRepository extends BaseApiClient {
  final http.Client httpClient;
  //constructor
  DoctorRepository({@required this.httpClient}) : assert(httpClient != null);
  //
  Future<DoctorDTO> getDoctorByDoctorId(String id) async {
    final String url = '/users/${id}';
    try {
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        DoctorDTO data = DoctorDTO.fromJson(jsonDecode(response.body));
        return data;
      }
      return null;
    } catch (e) {
      print('ERROR AT GET DOCTOR BY DOCTOR_ID API $e');
    }
  }
}
