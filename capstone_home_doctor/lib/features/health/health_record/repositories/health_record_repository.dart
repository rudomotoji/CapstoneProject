import 'dart:convert';

import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/models/health_record_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HealthRecordRepository extends BaseApiClient {
  final http.Client httpClient;

  HealthRecordRepository({@required this.httpClient})
      : assert(httpClient != null);

  //get list healthRecord
  Future<List<HealthRecordDTO>> getListHealthRecord(int patientId) async {
    String url = '/HealthRecords?patientId=${patientId}';
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
          return HealthRecordDTO.fromJson(dto);
        }).toList();
        return list;
      } else {
        return List<HealthRecordDTO>();
      }
    } catch (e) {
      print('ERROR AT GET LIST HEALTH RECORD ${e.toString()}');
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
//
}
