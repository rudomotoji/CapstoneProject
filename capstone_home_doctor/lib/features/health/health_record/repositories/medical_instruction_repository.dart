import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MedicalInstructionRepository extends BaseApiClient {
  final http.Client httpClient;

  MedicalInstructionRepository({@required this.httpClient})
      : assert(httpClient != null);

  Future<List<MedicalInstructionByTypeDTO>> getListMedInsWithType(
      int patientId) async {
    final String url =
        '/MedicalInstructions/GetMedicalInstructionToCreateContract?patientId=${patientId}';
    try {
      final response = await getApi(url, null);
      print('${response.body}');
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List;
        List<MedicalInstructionByTypeDTO> list = responseData.map((dto) {
          return MedicalInstructionByTypeDTO.fromJson(dto);
        }).toList();
        return list;
      } else {
        return List<MedicalInstructionByTypeDTO>();
      }
    } catch (e) {
      print('ERROR AT GET LIST HEALTH RECORD ${e.toString()}');
    }
  }
}
