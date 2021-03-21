import 'dart:convert';
import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
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
}
