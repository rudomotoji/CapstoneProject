import 'dart:io';

import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/commons/utils/teseract_oct.dart';
import 'package:capstone_home_doctor/models/image_scanner_dto.dart';
import 'package:capstone_home_doctor/models/med_ins_by_disease_dto.dart';
import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:capstone_home_doctor/models/medical_instruction_type_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sentry/sentry.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class MedicalInstructionRepository extends BaseApiClient {
  final http.Client httpClient;

  MedicalInstructionRepository({@required this.httpClient})
      : assert(httpClient != null);

  // TesseractOCRUtil _ocrUtil = TesseractOCRUtil();

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
      print('ERROR AT getMedicalInstructionType ${e.toString()}');
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
    // request.fields['DateStarted'] = '${dto.dateStarted}';
    // request.fields['DateFinished'] = '${dto.dateFinished}';
    request.files.add(http.MultipartFile(
        'image',
        File(dto.imageFile.path).readAsBytes().asStream(),
        File(dto.imageFile.path).lengthSync(),
        filename: dto.imageFile.path.split("/").last));
    final response = await request.send();
    if (response.statusCode == 200) return true;
    return false;
  }

  // Future<ImageScannerDTO> getTextFromImage(String imagePath) async {
  //   try {
  //     String strSymptom = '';
  //     String title = '';
  //     await _ocrUtil.convertImgToString(imagePath).then((value) {
  //       if (value != null) {
  //         var newArrData = value.split("\n");
  //         var str_list = newArrData.where((s) => !s.isEmpty).toList();

  //         for (var itemString in str_list) {
  //           if (itemString.contains('PHIẾU') ||
  //               itemString.contains('BỆNH ÁN') ||
  //               itemString.contains('XÉT NGHIỆM')) {
  //             title = itemString;
  //           }
  //           if (strSymptom != null && strSymptom != '') {
  //             if (itemString.contains('-') && itemString.contains('/')) {
  //               strSymptom += itemString;
  //             }
  //           } else {
  //             if ((itemString.contains('Triệu') ||
  //                     itemString.contains('chứng') ||
  //                     itemString.contains('Chẩn') ||
  //                     itemString.contains('đoán')) &&
  //                 strSymptom == '') {
  //               strSymptom = itemString;
  //             }
  //           }
  //         }
  //       }
  //     });

  //     // var arr = strSymptom.split(':');
  //     // if (arr.length > 1) {
  //     //   strSymptom = arr[1];
  //     // }

  //     return ImageScannerDTO(symptom: strSymptom.trim(), title: title.trim());
  //   } catch (exception, stackTrace) {
  //     await Sentry.captureException(
  //       exception,
  //       stackTrace: stackTrace,
  //     );
  //     return ImageScannerDTO(symptom: '', title: '');
  //   }
  //   // catch (e) {
  //   //   print('ERROR AT getTextIMG repo: ${e}');
  //   //   // return ImageScannerDTO(symptom: '', title: '');
  //   // }
  // }

  //create medical instruction by multiple part
  Future<ImageScannerDTO> getTextFromImage(String imagePath) async {
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
        dynamic dto = json.decode(responseString);

        var newArrData = dto['data'].split("\n");
        var str_list = newArrData.where((s) => !s.isEmpty).toList();

        String strSymptom = "";
        String title = "";

        for (var itemString in str_list) {
          if (itemString.contains('PHIẾU')) {
            title += itemString;
          } else if (itemString.contains('BỆNH ÁN')) {
            title = itemString;
          }
          if (title != "") {
            if (strSymptom.contains('Triệu')) {
              if (itemString.contains(' - ')) {
                strSymptom += itemString;
              } else if (itemString.contains('(')) {
                strSymptom += itemString;
              }
            }
            if (itemString.contains('Triệu ')) {
              strSymptom += itemString;
            }
          }
        }

        return ImageScannerDTO(symptom: strSymptom.trim(), title: title.trim());
      }
      return ImageScannerDTO();
    } catch (e) {
      print('ERROR AT getTextIMG repo: ${e}');
      return ImageScannerDTO(symptom: '', title: '');
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
    }
  }

  // Future<ImageScannerDTO> recogniseText(String imageFile) async {
  //   if (imageFile == null) {
  //     return null;
  //   } else {
  //     final visionImage = FirebaseVisionImage.fromFilePath(imageFile);
  //     final textRecognizer = FirebaseVision.instance.textRecognizer();
  //     try {
  //       final visionText = await textRecognizer.processImage(visionImage);
  //       await textRecognizer.close();

  //       final text = extractText(visionText);
  //       // return text.isEmpty ? 'No text found in the image' : text;
  //       String strSymptom = "";
  //       String title = "";

  //       var newArrData = text.split("\n");
  //       var str_list = newArrData.where((s) => !s.isEmpty).toList();

  //       for (var itemString in str_list) {
  //         if (itemString.contains('PHIẾU') ||
  //             itemString.contains('BỆNH ÁN') ||
  //             itemString.contains('XÉT NGHIỆM')) {
  //           title = itemString;
  //         }
  //         if (strSymptom != null && strSymptom != '') {
  //           if (itemString.contains('-') && itemString.contains('/')) {
  //             strSymptom += itemString;
  //           }
  //         } else {
  //           if (itemString.contains('Triệu') ||
  //               itemString.contains('chứng') ||
  //               itemString.contains('Chẩn') ||
  //               itemString.contains('đoán')) {
  //             strSymptom = itemString;
  //           }
  //         }
  //       }
  //       return ImageScannerDTO(symptom: strSymptom.trim(), title: title.trim());
  //     } catch (error) {
  //       return null;
  //     }
  //   }
  // }

  // static extractText(VisionText visionText) {
  //   String text = '';

  //   for (TextBlock block in visionText.blocks) {
  //     for (TextLine line in block.lines) {
  //       for (TextElement word in line.elements) {
  //         text = text + word.text + ' ';
  //       }
  //       text = text + '\n';
  //     }
  //   }

  //   return text;
  // }
}
