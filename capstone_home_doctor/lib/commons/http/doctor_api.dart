import 'dart:convert';

import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/models/doctor_dto.dart';

class DoctorAPI extends BaseApiClient {
  Future<DoctorDTO> getDoctorByDoctorId(String doctorId) async {
    final String url = '/users/${doctorId}';
    try {
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        DoctorDTO data = DoctorDTO.fromJson(jsonDecode(response.body));
        return data;
      }
      return null;
    } catch (e) {
      print('ERROR AT GET DOCTOR BY DOCTOR_ID $e');
    }
  }
}
