import 'dart:convert';

import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/features/health/health_record/views/update_health_record.dart';
import 'package:capstone_home_doctor/models/health_record_dto.dart';
import 'package:capstone_home_doctor/models/med_ins_by_disease_dto.dart';
import 'package:capstone_home_doctor/models/medical_share_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HealthRecordRepository extends BaseApiClient {
  final http.Client httpClient;

  HealthRecordRepository({@required this.httpClient})
      : assert(httpClient != null);

  //get list healthRecord
  Future<List<HealthRecordDTO>> getListHealthRecord(int patientId) async {
    String url =
        '/HealthRecords/GetHealthRecordByPatientId?patientId=${patientId}';
    try {
      //
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List;
        List<HealthRecordDTO> list = responseData.map((dto) {
          return HealthRecordDTO.fromJson(dto);
        }).toList();
        return list;
      } else {
        return List<HealthRecordDTO>();
      }
    } catch (e) {
      print('ERROR AT getListHealthRecord ${e.toString()}');
    }
  }

  //get healthRecord by id
  Future<HealthRecordDTO> getHealthRecordById(int healthRecordId) async {
    String url = '/HealthRecords?healthRecordId=${healthRecordId}';
    try {
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        HealthRecordDTO data =
            HealthRecordDTO.fromJson(jsonDecode(response.body));
        return data;
      }
    } catch (e) {
      print('ERROR AT GET HEALTH RECORD DETAIL ${e}');
    }
  }

//update health record
  Future<bool> updateHealthRecord(HealthRecordDTO dto) async {
    String url = '/HealthRecords/${dto.healthRecordId}';
    try {
      final response = await putApi(url, null, dto.toJsonUpdate());
      if (response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('ERROR AT GET HEALTH RECORD DETAIL ${e}');
      return false;
    }
  }

  //create new healthRecord
  Future<int> createHealthRecord(HealthRecordDTO dto) async {
    final String url = '/HealthRecords';
    try {
      final request = await postApi(url, null, dto.toJson());
      if (request.statusCode == 201) {
        return int.parse(request.body);
      }
      return null;
    } catch (e) {
      print('ERROR AT CREATE HEALTH RECORD API: $e');
      return null;
    }
  }

  //get medicalShare to Create contract
  Future<List<MedicalShareDTO>> getListMedicalShare(
      int patientId, int medicalInstructionType, String diseaseId) async {
    // final String url =
    //     '/MedicalInstructions/GetMedicalInstructionToCreateContract?patientId=${patientId}&medicalInstructionType=${medicalInstructionType}';
    final String url =
        '/MedicalInstructions/GetMedicalInstructionToCreateContract?patientId=${patientId}&diseaseId=${diseaseId}&medicalInstructionType=${medicalInstructionType}';
    try {
      //
      final request = await postApi(url, null, null);
      // print('${request.request}');
      // print('${request.body}');
      if (request.statusCode == 200) {
        final responseData = json.decode(request.body) as List;
        List<MedicalShareDTO> list = responseData.map((dto) {
          return MedicalShareDTO.fromJson(dto);
        }).toList();
        return list;
      } else {
        return null;
      }
    } catch (e) {
      print('ERROR AT getListMedicalShare: ${e}');
    }
  }

  //lấy danh sách medical instruction để share
  Future<List<MedInsByDiseaseDTO>> getAllMedicalToShare(
      int patientID, int healthRecordId) async {
    final String url =
        '/MedicalInstructions/GetMedicalInstructionsToShare?patientId=${patientID}&healthRecordId=${healthRecordId}';
    try {
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List;
        List<MedInsByDiseaseDTO> list = responseData.map((dto) {
          return MedInsByDiseaseDTO.fromJson(dto);
        }).toList();
        return list;
      } else {
        return List<MedInsByDiseaseDTO>();
      }
    } catch (e) {
      print('ERROR AT getAllMedicalToShare ${e.toString()}');
    }
  }
//
}
