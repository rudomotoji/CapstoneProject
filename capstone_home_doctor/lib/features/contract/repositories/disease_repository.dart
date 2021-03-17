import 'dart:convert';

import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/models/disease_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DiseaseRepository extends BaseApiClient {
  final http.Client httpClient;
  DiseaseRepository({@required this.httpClient}) : assert(httpClient != null);

  //get list disease
  Future<List<DiseaseDTO>> getListDisease() async {
    final String url = '/Diseases';
    try {
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List;
        List<DiseaseDTO> list = responseData.map((dto) {
          return DiseaseDTO.fromJson(dto);
        }).toList();
        return list;
      } else {
        return List<DiseaseDTO>();
      }
    } catch (e) {
      print('ERROR AT GET LIST DISEASE $e');
    }
  }

  //get list disease about heart
  Future<List<DiseaseHeartDTO>> getHeartDiseases() async {
    final String url = '/Diseases/GetHeartDiseases';
    try {
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List;
        List<DiseaseHeartDTO> list = responseData.map((dto) {
          return DiseaseHeartDTO(
            diseaseId: dto['diseaseId'],
            name: dto['nameDisease'],
          );
        }).toList();
        return list;
      } else {
        return List<DiseaseHeartDTO>();
      }
    } catch (e) {
      print('ERROR AT GET LIST DISEASE $e');
    }
  }
}
