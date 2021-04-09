import 'dart:convert';
import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/models/activity_dto.dart';
import 'package:capstone_home_doctor/models/notification_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotificationRepository extends BaseApiClient {
  final http.Client httpClient;
  NotificationRepository({@required this.httpClient})
      : assert(httpClient != null);

  //get list notification
  Future<List<NotificationDTO>> getListNotification(int accountId) async {
    final String url = '/Notifications?accountId=${accountId}';
    try {
      //
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List;
        List<NotificationDTO> list = responseData.map((dto) {
          return NotificationDTO.fromJson(dto);
        }).toList();
        return list;
      } else {
        return List<NotificationDTO>();
      }
    } catch (e) {
      print('ERROR AT GET LIST NOTIFICATION REPOSITORY ${e}');
    }
  }

  //get list timeline
  Future<ActivityDTO> getListTimeline(
      int patientAccountId, int doctorAccountId, String dateTime) async {
    final String url =
        '/Notifications/GetTimeLinePatient?accountPatientId=${patientAccountId}&accountDoctorID=${doctorAccountId}&dateTime=${dateTime}';
    try {
      //
      final response = await getApi(url, null);

      if (response.statusCode == 200) {
        ActivityDTO dto = ActivityDTO.fromJson(jsonDecode(response.body));
        return dto;
      }
    } catch (e) {
      print('ERROR AT GET LIST TIMELINE: ${e}');
    }
  }

  //update status notification
  Future<bool> updateStatusNotification(int notificationId) async {
    final String url = '/Notifications?notiId=${notificationId}';
    try {
      //
      final request = await putApi(url, null, notificationId);
      print('update noti status ${request.statusCode}');
      if (request.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('ERROR AT UPDATE STATUS NOTIFICATION REPOSITORY ${e}');
    }
  }

  //push notification
  Future<bool> pushNotification(NotificationPushDTO notiPushDTO) async {
    final String url =
        '/Notifications?deviceType=${notiPushDTO.deviceType}&notificationType=${notiPushDTO.notificationType}&senderAccountId=${notiPushDTO.senderAccountId}&recipientAccountId=${notiPushDTO.recipientAccountId}';
    try {
      final request = await postApi(url, null, notiPushDTO.toJson());
      if (request.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('ERROR AT PUSH NOTIFICATION ${e}');
    }
  }

  //change personal health record status
  Future<bool> changePersonalStatus(int patientId, String status) async {
    final String url =
        '/PersonalHealthReocrds/UpdatePersonalStatus?patientId=${patientId}&status=${status}';
    try {
      final request = await putApi(url, null, null);
      // print('request status code is ${request.body}');
      if (request.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('ERROR AT changePersonalStatus ${e}');
    }
  }
}
