import 'dart:convert';

import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/models/advertisement_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AdvertisementRepository extends BaseApiClient {
  final http.Client httpClient;

  AdvertisementRepository({@required this.httpClient})
      : assert(httpClient != null);

  Future<List<AdvertisementDTO>> getListAd() async {
    try {
      //
      final response = await rootBundle.loadString('assets/advertisement.json');
      final responseData = json.decode(response) as List;
      List<AdvertisementDTO> list = responseData.map((dto) {
        return AdvertisementDTO.fromJson(dto);
      }).toList();

      return list;
    } catch (e) {
      print('ERROR AT GET AD REPO: $e');
    }
  }
}
