import 'dart:convert';

import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/models/setting_background_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BackgroundRepository extends BaseApiClient {
  final http.Client httpClient;

  BackgroundRepository({@required this.httpClient})
      : assert(httpClient != null);

  //get setting background
  Future<SettingBackgroundDTO> getSettingBackground() async {
    //
    String url = '/DeviceBackgroundSetting';
    try {
      final response = await getApiMockup(url, null);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        List<SettingBackgroundDTO> list = data.map((dto) {
          return SettingBackgroundDTO.fromJson(dto);
        }).toList();
        return list[0];
      }
    } catch (e) {
      print('ERROR AT GET SETTING BACKGROUND ${e}');
    }
  }

  //get default safe border heart rate
  Future<SafeScopeHeartRateDTO> getSafeScopeHeartRate() async {
    String url = '/DefaultScopeHeartRate';
    try {
      final response = await getApiMockup(url, null);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        List<SafeScopeHeartRateDTO> list = data.map((dto) {
          return SafeScopeHeartRateDTO.fromJson(dto);
        }).toList();
        return list[0];
      }
    } catch (e) {
      print('ERROR AT getSafeScopeHeartRate ${e}');
    }
  }

  Future<SummarySettingDTO> getSummarySetting() async {
    String url = '/VitalSignSummary';
    try {
      //
      final response = await getApiMockup(url, null);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        List<SummarySettingDTO> list = data.map((dto) {
          return SummarySettingDTO.fromJson(dto);
        }).toList();
        return list[0];
      }
    } catch (e) {
      print('ERROR AT getSummarySetting: ${e}');
    }
  }
}
