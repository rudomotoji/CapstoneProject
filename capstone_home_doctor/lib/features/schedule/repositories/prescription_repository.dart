import 'dart:convert';
import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:capstone_home_doctor/models/prescription_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PrescriptionRepository extends BaseApiClient {
  final http.Client httpClient;

  PrescriptionRepository({@required this.httpClient})
      : assert(httpClient != null);
  //get list prescription
  Future<List<MedicalInstructionDTO>> getListPrecription(int patientId) async {
    String url =
        '/MedicalInstructions/GetPrescriptionByPatientId?patientId=${patientId}';
    try {
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List;
        List<MedicalInstructionDTO> list = responseData.map((dto) {
          return MedicalInstructionDTO.fromJson(dto);
        }).toList();
        return list;
      } else {
        return List<MedicalInstructionDTO>();
      }
    } catch (e) {
      print('ERROR AT GET LIST PRESCRIPTION  ${e.toString()}');
    }
  }
}
