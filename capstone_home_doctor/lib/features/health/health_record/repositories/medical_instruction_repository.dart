import 'dart:io';

import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/models/image_scanner_dto.dart';
import 'package:capstone_home_doctor/models/med_ins_by_disease_dto.dart';
import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:capstone_home_doctor/models/medical_instruction_type_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MedicalInstructionRepository extends BaseApiClient {
  final http.Client httpClient;

  MedicalInstructionRepository({@required this.httpClient})
      : assert(httpClient != null);

  Future<List<MedInsByDiseaseDTO>> getMedInsByDisease(
      int patientId, String diseaseId) async {
    final String url =
        '/MedicalInstructions/GetMedicalInstructionToCreateContract?patientId=${patientId}&dieseId=${diseaseId}';
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
      print('ERROR AT GET LIST HEALTH RECORD ${e.toString()}');
    }
  }

  //get list medical instruction by HR_Id
  Future<List<MedicalInstructionDTO>> getListMedicalInstruction(
      int hrId) async {
    final String url =
        '/MedicalInstructions/GetMedicalInstructionsByHRId?healthRecordId=${hrId}';
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
      print('ERROR AT GET LIST HEALTH RECORD ${e.toString()}');
    }
  }

  //medical instruction type
  Future<List<MedicalInstructionTypeDTO>> getMedicalInstructionType(
      String status) async {
    final String url = '/MedicalInstructrionTypes?status=${status}';
    try {
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List;
        List<MedicalInstructionTypeDTO> list = responseData.map((dto) {
          return MedicalInstructionTypeDTO.fromJson(dto);
        }).toList();
        return list;
      } else {
        return List<MedicalInstructionTypeDTO>();
      }
    } catch (e) {
      print('ERROR AT GET LIST HEALTH RECORD ${e.toString()}');
    }
  }

  //create medical instruction by multiple part
  Future<bool> createMedicalInstruction(MedicalInstructionDTO dto) async {
    var uri = Uri.parse(
        'http://45.76.186.233:8000/api/v1/MedicalInstructions/InsertMedicalInstructionOld');
    var request = new http.MultipartRequest('POST', uri);
    request.fields['MedicalInstructionTypeId'] =
        '${dto.medicalInstructionTypeId}';
    request.fields['HealthRecordId'] = '${dto.healthRecordId}';
    request.fields['PatientId'] = '${dto.patientId}';
    request.fields['Description'] = '${dto.description}';
    request.fields['Diagnose'] = '${dto.diagnose}';
    request.fields['DateStarted'] = '${dto.dateStarted}';
    request.fields['DateFinished'] = '${dto.dateFinished}';
    request.files.add(http.MultipartFile(
        'image',
        File(dto.imageFile.path).readAsBytes().asStream(),
        File(dto.imageFile.path).lengthSync(),
        filename: dto.imageFile.path.split("/").last));
    final response = await request.send();
    if (response.statusCode == 200) return true;
    return false;
  }

  //create medical instruction by multiple part
  Future<ImageScannerDTO> getTextFromImage(String imagePath) async {
    ImageScannerDTO dto;
    var uri = Uri.parse('http://0.0.0.0:80/scanMedicalInsurance');
    var request = new http.MultipartRequest('POST', uri);
    try {
      request.files.add(http.MultipartFile(
          'file',
          File(imagePath).readAsBytes().asStream(),
          File(imagePath).lengthSync(),
          filename: imagePath.split("/").last));
      final response = await request.send();
      if (response.statusCode == 200) {
        var responseString = await response.stream.bytesToString();
        return ImageScannerDTO.fromJson(json.decode(responseString));
        // http.Response.fromStream(response).then((res) {
        //   dto = ImageScannerDTO.fromJson(json.decode(res.body));
        //   return dto;
        // });
      }
      return ImageScannerDTO();
    } catch (e) {
      print('ERROR AT getTextIMG repo: ${e}');
    }
  }

  //get medical instruction in create request contract view

}
