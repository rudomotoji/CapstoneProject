import 'dart:convert';

import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/models/disease_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DiseaseRepository extends BaseApiClient {
  final http.Client httpClient;
  DiseaseRepository({@required this.httpClient}) : assert(httpClient != null);

  //get list disease
  Future<List<DiseaseContractDTO>> getListDisease() async {
    final String url = '/Diseases/GetDiseases';
    try {
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List;
        List<DiseaseContractDTO> list = responseData.map((dto) {
          // return DiseaseContractDTO.fromJson(dto);
          var newDTO = DiseaseContractDTO.fromJson(dto);
          for (var item in newDTO.diseaseLevelThrees) {
            item.strDiseaseID =
                '${item.diseaseLevelThreeId} - ${item.diseaseLevelThreeName}';
          }

          return newDTO;
        }).toList();
        return list;
      } else {
        return List<DiseaseContractDTO>();
      }
    } catch (e) {
      print('ERROR AT GET LIST DISEASE $e');
    }
  }

  //get list disease about heart
  Future<List<DiseaseContractDTO>> getHeartDiseases() async {
    final String url = '/Diseases/GetHeartDiseases';
    try {
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List;
        List<DiseaseContractDTO> list = responseData.map((dto) {
          return DiseaseContractDTO.fromJson(dto);
        }).toList();
        return list;
      } else {
        return List<DiseaseContractDTO>();
      }
    } catch (e) {
      print('ERROR AT GET LIST DISEASE $e');
    }
  }

  //get list disease lv2 and lv3
  Future<List<DiseaseContractDTO>> getListDiseaseContract(int patientId) async {
    final String url =
        '/Diseases/GetDiseasesToCreateContract?patientId=${patientId}';
    try {
      //
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List;
        List<DiseaseContractDTO> list = responseData.map((dto) {
          //
          return DiseaseContractDTO.fromJson(dto);
        }).toList();
        return list;
      } else {
        return List<DiseaseContractDTO>();
      }
    } catch (e) {
      print('ERROR AT getListDiseaseContract ${e}');
    }
  }
}
