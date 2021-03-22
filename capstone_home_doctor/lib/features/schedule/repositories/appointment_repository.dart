import 'dart:convert';
import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/models/appointment_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AppointmentRepository extends BaseApiClient {
  final http.Client httpClient;

  AppointmentRepository({@required this.httpClient})
      : assert(httpClient != null);
  //get list prescription
  Future<List<AppointmentDTO>> getAppointment(
      int patientId, String date) async {
    String url =
        '/Appointments/GetAppointmentForMonth?accountId=${patientId}&month=${date}';
    try {
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List;
        List<AppointmentDTO> list = responseData.map((dto) {
          return AppointmentDTO.fromJson(dto);
        }).toList();
        return list;
      } else {
        return List<AppointmentDTO>();
      }
    } catch (e) {
      print('ERROR AT GET APPOINTMENT ${e.toString()}');
    }
  }

  Future<bool> cancelAppointment(int appointmentId, String reasonCancel) async {
    String url =
        '/Appointments/CancelAppointment?appointmentId=${appointmentId}&reasonCancel=${reasonCancel}';
    try {
      final response = await putApi(url, null, null);
      if (response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('ERROR AT CANCEL APPOINTMENT ${e.toString()}');
    }
  }
}
