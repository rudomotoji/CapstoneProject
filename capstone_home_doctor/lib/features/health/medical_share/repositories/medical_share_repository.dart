import 'dart:convert';

import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MedicalShareInsRepository extends BaseApiClient {
  final http.Client httpClient;

  MedicalShareInsRepository({@required this.httpClient})
      : assert(httpClient != null);

  Future<bool> shareMoreMedIns(
      int healthRecordId, List<int> listMedicalShare) async {
    String url =
        '/MedicalInstructions/ShareMedicalInstructions?healthRecordId=${healthRecordId}';
    try {
      final response = await postApi(url, null, listMedicalShare);
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('ERROR AT SHARE MEDICAL INS ${e.toString()}');
    }
  }

  Future<List<MedicalInstructionByTypeDTO>> getShareMoreMedIns(
      int contractID) async {
    String url = '/MedicalInstructionShares?contractId=${contractID}';
    try {
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List;
        List<MedicalInstructionByTypeDTO> lists = responseData.map((dto) {
          return MedicalInstructionByTypeDTO.fromJson(dto);
        }).toList();
        return lists;
      } else {
        print('failed');
        return List<MedicalInstructionByTypeDTO>();
      }
    } catch (e) {
      print('ERROR AT GET LIST MEDICAL INS ${e.toString()}');
    }
  }
}
