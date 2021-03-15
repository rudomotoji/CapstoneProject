import 'dart:convert';

import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/models/appointment_dto.dart';
import 'package:capstone_home_doctor/models/health_record_dto.dart';
import 'package:capstone_home_doctor/models/med_ins_by_disease_dto.dart';
import 'package:capstone_home_doctor/models/medical_share_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AppointmentRepository extends BaseApiClient {
  final http.Client httpClient;

  AppointmentRepository({@required this.httpClient})
      : assert(httpClient != null);

  //lấy lịch hẹn
  Future<AppointmentDTO> getAppointment(int patientID) async {
    final String url = '/';
    try {
      final request = await getApi(url, null);
      if (request.statusCode == 200) {
        AppointmentDTO dto = AppointmentDTO.fromJson(json.decode(request.body));
        return dto;
      }
      return AppointmentDTO();
    } catch (e) {
      print('ERROR AT GET APPOINTMENT API: $e');
    }
  }

  //lấy danh sách lịch hẹn
  Future<List<AppointmentDTO>> getListAppointment(int patientID) async {
    final String url = '/';
    try {
      final request = await getApi(url, null);
      if (request.statusCode == 200) {
        final responseData = json.decode(request.body) as List;
        List<AppointmentDTO> list = responseData.map((dto) {
          return dto.fromJson();
        }).toList();

        return list;
      }
      return [];
    } catch (e) {
      print('ERROR AT GET LIST APPOINTMENT API: $e');
    }
  }
}
