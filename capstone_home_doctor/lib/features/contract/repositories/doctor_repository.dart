import 'dart:convert';

import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/models/doctor_dto.dart';
import 'package:capstone_home_doctor/models/doctor_list_dto.dart';
import 'package:capstone_home_doctor/models/doctor_tracking_dto.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//remove extends BaseApiClient
class DoctorRepository extends BaseApiClient {
  final http.Client httpClient;
  //constructor
  DoctorRepository({@required this.httpClient}) : assert(httpClient != null);
  //
  Future<DoctorDTO> getDoctorByDoctorId(int id) async {
    final String url = '/Doctors/${id}';
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

  Future<List<DoctorDTO>> getListDoctor() async {
    final String url = '/Doctors';
    try {
      final request = await getApi(url, null);
      if (request.statusCode == 200) {
        List<DoctorDTO> lists = [];
        var response = jsonDecode(request.body);
        response.map((dto) {
          lists.add(DoctorDTO.fromJson(dto));
        });
        return lists;
      }
      return null;
    } catch (e) {
      print('ERROR AT GET DOCTOR BY DOCTOR_ID API $e');
    }
  }

  Future<List<DoctorListDTO>> getListDoctorByPatient(int patientId) async {
    final String url =
        '/Doctors/GetDoctorTrackingByPatientId?patientId=${patientId}';
    try {
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List;
        List<DoctorListDTO> list = responseData.map((dto) {
          return DoctorListDTO.fromJson(dto);
        }).toList();
        return list;
      }
    } catch (e) {
      print('ERROR AT GET DOCTOR BY PATIENT $e');
    }
  }

  Future<List<DoctorTrackingDTO>> getDoctorTrackingList(int patientId) async {
    final String url =
        '/Doctors/GetDoctorTrackingByPatientId?patientId=$patientId';
    try {
      //
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        List<DoctorTrackingDTO> list = data.map((dto) {
          return DoctorTrackingDTO.fromJson(dto);
        }).toList();
        return list;
      }
    } catch (e) {
      print('ERROR AT GET DOCTOR TRACKING LIST: $e');
    }
  }
}
