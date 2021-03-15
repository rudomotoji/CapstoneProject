import 'dart:convert';

import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
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
        // List<HealthRecordDTO> list = responseData.map((dto) {
        //   // return HealthRecordDTO(
        //   //     healthRecordId: dto['healthRecordId'],
        //   //     disease: dto['dicease'],
        //   //     place: dto['place'],
        //   //     description: dto['description'],
        //   //     dateCreated: dto['dateCreated'],
        //   //     contractId: dto['contractId']);
        //   return HealthRecordDTO.fromJson(dto);
        // }).toList();
        // print('LIST IN HR LIST REPO ${list}');
        // return list;
        List<HealthRecordDTO> list = responseData.map((dto) {
          return HealthRecordDTO(
            healthRecordId: dto['healthRecordId'],
            place: dto['place'],
            description: dto['description'],
            dateCreated: dto['dateCreated'],
            contractId: dto['contractId'],
            diseases: dto['diseases'],
          );
        }).toList();
        return list;
      } else {
        return List<HealthRecordDTO>();
      }
    } catch (e) {
      print('ERROR AT GET LIST HEALTH RECORD ${e.toString()}');
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

  //create new healthRecord
  Future<bool> createHealthRecord(HealthRecordDTO dto) async {
    final String url = '/HealthRecords';
    try {
      final request = await postApi(url, null, dto.toJson());
      if (request.statusCode == 201) {
        return true;
      }
      if (request.statusCode == 400) {
        return false;
      }
      return false;
    } catch (e) {
      print('ERROR AT CREATE HEALTH RECORD API: $e');
    }
  }

  //get medicalShare to Create contract
  Future<List<MedicalShareDTO>> getListMedicalShare(
      List<String> diseaseIds, int patientId) async {
    final String url =
        '/MedicalInstructions/GetMedicalInstructionToCreateContract?patientId=${patientId}';
    try {
      //
      final request = await postApi(url, null, diseaseIds);
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
//
}
