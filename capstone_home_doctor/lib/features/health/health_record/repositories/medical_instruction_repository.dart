import 'dart:io';

import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/commons/utils/teseract_oct.dart';
import 'package:capstone_home_doctor/models/image_scanner_dto.dart';
import 'package:capstone_home_doctor/models/med_ins_by_disease_dto.dart';
import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:capstone_home_doctor/models/medical_instruction_type_dto.dart';
import 'package:capstone_home_doctor/models/medical_type_required_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sentry/sentry.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class MedicalInstructionRepository extends BaseApiClient {
  final http.Client httpClient;

  MedicalInstructionRepository({@required this.httpClient})
      : assert(httpClient != null);

  TesseractOCRUtil _ocrUtil = TesseractOCRUtil();

  Future<List<MedInsByDiseaseDTO>> getMedInsByDisease(
      int patientId, String diseaseId) async {
    final String url =
        '/MedicalInstructions/GetMedicalInstructionToCreateContract?patientId=${patientId}&diseaseId=${diseaseId}';
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
      print('ERROR AT getMedInsByDisease ${e.toString()}');
      return List<MedInsByDiseaseDTO>();
    }
  }

  //GET MEDICAL INSTRUCTION REQUIRED WHEN DISEASE CHOSEN
  Future<List<MedicalTypeRequiredDTO>> getMiRequiredByDisease(
      List<String> diseaseIds) async {
    List<MedicalTypeRequiredDTO> listFiltered = [];
    try {
      //
      final String response =
          await rootBundle.loadString('assets/medicalInstructionRequire.json');
      final reponseData = json.decode(response) as List;
      List<MedicalTypeRequiredDTO> list = reponseData.map((dto) {
        //
        return MedicalTypeRequiredDTO.fromJson(dto);
      }).toList();
      listFiltered.clear();
      for (String diseaseId in diseaseIds) {
        for (MedicalTypeRequiredDTO component in list) {
          for (SuggestionDisease suggestList in component.suggestionDisease) {
            if (suggestList.diseaseId == diseaseId) {
              listFiltered.removeWhere((item) =>
                  item.medicalInstructionRequiredId ==
                  component.medicalInstructionRequiredId);
              listFiltered.add(component);
            }
          }
        }
      }
      return listFiltered;
    } catch (e) {
      print('ERROR AT GET MEDICAL INS TYPE BY DISEAS: $e');
      return listFiltered;
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
      print('ERROR AT getListMedicalInstruction ${e.toString()}');
      return List<MedicalInstructionDTO>();
    }
  }

  //medical instruction type
  Future<List<MedicalInstructionTypeDTO>> getMedicalInstructionType(
      String status) async {
    final String url = '/MedicalInstructrionTypes';
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
      print('ERROR AT getMedicalInstructionType ${e.toString()}');
      return List<MedicalInstructionTypeDTO>();
    }
  }

  //medical instruction type to share
  Future<List<MedicalInstructionTypeDTO>> getMedicalInstructionTypeToShare(
      int patientId) async {
    final String url =
        '/MedicalInstructrionTypes/GetMITypeToShare?patientId=${patientId}';
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
      print('ERROR AT getMedicalInstructionType ${e.toString()}');
    }
  }

  //create medical instruction by multiple part
  Future<bool> createMedicalInstruction(MedicalInstructionDTO dto) async {
    try {
      var uri = Uri.parse(
          'http://45.76.186.233:8000/api/v1/MedicalInstructions/InsertMedicalInstructionOld');
      var request = new http.MultipartRequest('POST', uri);
      request.fields['MedicalInstructionTypeId'] =
          '${dto.medicalInstructionTypeId}';
      request.fields['HealthRecordId'] = '${dto.healthRecordId}';
      request.fields['PatientId'] = '${dto.patientId}';
      request.fields['Description'] = '${dto.description}';
      request.fields['Diagnose'] = '${dto.diagnose}';

      if (dto.diseaseIds == null) {
        print('null');
        request.fields['DiseaseIds'] = '';
      } else {
        print('not null');
        for (String itemDisease in dto.diseaseIds) {
          request.files
              .add(http.MultipartFile.fromString('DiseaseIds', itemDisease));
        }
      }

      for (var imageItem in dto.imageFile) {
        String fileName = imageItem.split("/").last;
        var length =
            await File(imageItem).lengthSync(); //imageFile is your image file
        var stream = File(imageItem).readAsBytes().asStream();

        // multipart that takes file
        var multipartFileSign = new http.MultipartFile('images', stream, length,
            filename: fileName);

        request.files.add(multipartFileSign);
      }
      final response = await request.send();
      if (response.statusCode == 200) return true;
      return false;
    } catch (e) {
      print('createMedicalInstruction: $e');
      return false;
    }
  }

  Future<ImageScannerDTO> getTextFromImage(
      String imagePath, String strCompare) async {
    try {
      String strSymptom = '';
      String title = '';
      double titleCompare = 0;
      if (Platform.isIOS) {
      } else {
        await _ocrUtil.convertImgToString(imagePath).then((value) {
          if (value != null) {
            var newArrData = value.split("\n");
            var str_list = newArrData.where((s) => !s.isEmpty).toList();

            titleCompare = checkTitleMedicalIns(
                str_list.toString().replaceAll(" ", "").toString(),
                strCompare.replaceAll(" ", "").toString().toUpperCase());

            for (var itemString in str_list) {
              if (strSymptom != null && strSymptom != '') {
                if (itemString.contains('-') && itemString.contains('/')) {
                  strSymptom += itemString;
                }
              } else {
                if ((itemString.contains('Triệu') ||
                        itemString.contains('chứng') ||
                        itemString.contains('Chẩn') ||
                        itemString.contains('đoán') ||
                        itemString.contains('kết') ||
                        itemString.contains('luận') ||
                        itemString.contains('KẾT') ||
                        itemString.contains('LUẬN')) &&
                    strSymptom == '') {
                  strSymptom = itemString;
                }
              }
            }
          }
        });
      }
      strSymptom = strSymptom.replaceAll(
          new RegExp(r'[!@#$%^&*().?":{}|<>\`~wzjWZJ©=——,—°";†_¬‡…ÿ›]+'), '');

      return ImageScannerDTO(
          symptom: strSymptom.trim(),
          title: title.trim(),
          titleCompare: titleCompare);
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
      return ImageScannerDTO(symptom: '', title: '', titleCompare: 0);
    }
  }

  double checkTitleMedicalIns(String strImage, String strCompare) {
    double percentCompare = 0;
    try {
      int lengStrCompare = strCompare.length;
      for (var i = 0; i < lengStrCompare; i++) {
        String strImageClone = strImage;
        String titleOfStrImage = '';
        bool flagCheck = false;
        while (!flagCheck) {
          String startStr = strCompare[i];
          int indexOfStartStrInStrImage = strImageClone.indexOf(startStr);
          if (indexOfStartStrInStrImage == -1) {
            flagCheck = true;
          } else {
            if (i != 0 && indexOfStartStrInStrImage >= i) {
              indexOfStartStrInStrImage = indexOfStartStrInStrImage - i;
            }
            if ((indexOfStartStrInStrImage + lengStrCompare) >
                strImage.length) {
              flagCheck = true;
            } else {
              titleOfStrImage = strImageClone.substring(
                  indexOfStartStrInStrImage,
                  indexOfStartStrInStrImage + lengStrCompare);
              var percentComp = strCompare.similarityTo(titleOfStrImage);
              if (percentComp > percentCompare) {
                percentCompare = percentComp;
                print(percentCompare);
              }
              strImageClone =
                  strImageClone.replaceFirst(RegExp(startStr), '', 1);
            }
          }
        }
      }
      return percentCompare;
    } catch (e) {
      print('checkTitleMedicalIns: $e');
      return percentCompare;
    }
  }

  //// lấy chi tiết đơn thuốc
  Future<MedicalInstructionDTO> getMedicalInstructionById(
      int medicalInstructionId) async {
    final String url = '/MedicalInstructions/${medicalInstructionId}';
    try {
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        MedicalInstructionDTO data =
            MedicalInstructionDTO.fromJson(jsonDecode(response.body));
        return data;
      }
      return null;
    } catch (e) {
      print('ERROR AT GET DOCTOR BY DOCTOR_ID API $e');
      return null;
    }
  }

  Future<bool> deleteMedicalInstruction(int medicalInstructionID) async {
    try {
      final String url = '/MedicalInstructions';
      // final response = await getApi(url, null);
      // if (response.statusCode == 200) {
      //   MedicalInstructionDTO data =
      //       MedicalInstructionDTO.fromJson(jsonDecode(response.body));
      //   return data;
      // }
      return false;
    } catch (e) {
      print('deleteMedicalInstruction: $e');
      return false;
    }
  }
}
