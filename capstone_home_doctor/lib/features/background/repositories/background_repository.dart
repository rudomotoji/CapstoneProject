import 'dart:convert';

import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/models/date_request_dto.dart';
import 'package:capstone_home_doctor/models/setting_background_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class BackgroundRepository extends BaseApiClient {
  final http.Client httpClient;

  BackgroundRepository({@required this.httpClient})
      : assert(httpClient != null);

  //get setting background
  // Future<SettingBackgroundDTO> getSettingBackground() async {
  //   //
  //   String url = '/DeviceBackgroundSetting';
  //   try {
  //     final response = await getApiMockup(url, null);
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body) as List;
  //       List<SettingBackgroundDTO> list = data.map((dto) {
  //         return SettingBackgroundDTO.fromJson(dto);
  //       }).toList();
  //       return list[0];
  //     }
  //   } catch (e) {
  //     print('ERROR AT GET SETTING BACKGROUND ${e}');
  //   }
  // }

  ///////
  Future<SettingBackgroundDTO> getSettingBackground() async {
    //

    try {
      final String response =
          await rootBundle.loadString('assets/bluetooth.json');
      final reponseData = json.decode(response);
      SettingBackgroundDTO dto = SettingBackgroundDTO.fromJson(reponseData);
      return dto;
    } catch (e) {
      print('ERROR AT GET MEDICAL INS TYPE BY DISEAS: $e');
    }
  }

  //get default safe border heart rate
  // Future<SafeScopeHeartRateDTO> getSafeScopeHeartRate() async {
  //   String url = '/DefaultScopeHeartRate';
  //   try {
  //     final response = await getApiMockup(url, null);
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body) as List;
  //       List<SafeScopeHeartRateDTO> list = data.map((dto) {
  //         return SafeScopeHeartRateDTO.fromJson(dto);
  //       }).toList();
  //       return list[0];
  //     }
  //   } catch (e) {
  //     print('ERROR AT getSafeScopeHeartRate ${e}');
  //   }
  // }
  //
  // ////
  Future<SafeScopeHeartRateDTO> getSafeScopeHeartRate() async {
    try {
      final String response =
          await rootBundle.loadString('assets/defaultScope.json');
      final reponseData = json.decode(response);
      SafeScopeHeartRateDTO dto = SafeScopeHeartRateDTO.fromJson(reponseData);
      return dto;
    } catch (e) {
      print('ERROR AT getSafeScopeHeartRate ${e}');
    }
  }

  // Future<SummarySettingDTO> getSummarySetting() async {
  //   String url = '/VitalSignSummary';
  //   try {
  //     //
  //     final response = await getApiMockup(url, null);
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body) as List;
  //       List<SummarySettingDTO> list = data.map((dto) {
  //         return SummarySettingDTO.fromJson(dto);
  //       }).toList();
  //       return list[0];
  //     }
  //   } catch (e) {
  //     print('ERROR AT getSummarySetting: ${e}');
  //   }
  // }
  //
  //

  Future<SummarySettingDTO> getSummarySetting() async {
    try {
      final String response =
          await rootBundle.loadString('assets/summary.json');
      final reponseData = json.decode(response);
      SummarySettingDTO dto = SummarySettingDTO.fromJson(reponseData);
      return dto;
    } catch (e) {
      print('ERROR AT getSummarySetting: ${e}');
    }
  }

  //get default date after request contract
  // Future<DateRequestDTO> getDateRequest() async {
  //   String url = '/DateContractRecommend';
  //   try {
  //     //
  //     final response = await getApiMockup(url, null);
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body) as List;
  //       List<DateRequestDTO> list = data.map((dto) {
  //         //
  //         return DateRequestDTO.fromJson(dto);
  //       }).toList();
  //       return list[0];
  //     }
  //   } catch (e) {
  //     print('ERRROR AT get Date Request: $e');
  //   }
  // }
  //
  //
  //
  //
  Future<DateRequestDTO> getDateRequest() async {
    String url = '/DateContractRecommend';
    try {
      final String response =
          await rootBundle.loadString('assets/dateRequest.json');
      final reponseData = json.decode(response);
      DateRequestDTO dto = DateRequestDTO.fromJson(reponseData);
      return dto;
    } catch (e) {
      print('ERRROR AT get Date Request: $e');
    }
  }
}
