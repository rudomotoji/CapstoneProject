import 'dart:convert';
import 'dart:typed_data';

import 'package:capstone_home_doctor/commons/constants/peripheral_services.dart';
import 'package:capstone_home_doctor/features/peripheral/repositories/peripheral_repository.dart';
import 'package:capstone_home_doctor/models/vital_sign_detail_dto.dart';
import 'package:capstone_home_doctor/models/vital_sign_push_dto.dart';
import 'package:capstone_home_doctor/models/vital_sign_schedule_dto.dart';
import 'package:capstone_home_doctor/services/peripheral_helper.dart';
import 'package:capstone_home_doctor/services/vital_sign_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:capstone_home_doctor/services/noti_helper.dart';
import 'package:capstone_home_doctor/services/notifications_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:capstone_home_doctor/commons/http/base_api_client.dart';

final PeripheralHelper _peripheralHelper = PeripheralHelper();

class VitalSignRepository {
  final flutterBlue = FlutterBlue.instance;
  final PeripheralRepository peripheralRepository = PeripheralRepository();
  final VitalSignHelper vitalSignHelper = VitalSignHelper();
  VitalSignRepository();

  //discover services
  Future<List<BluetoothService>> discoverServices(
      BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    return services;
  }

  //get heart rate characteristic
  Future<int> getHeartRateValueFromDevice(String peripheralId) async {
    int heartRateValue = 0;
    BluetoothDevice device =
        await peripheralRepository.findScanResultById(peripheralId);
    try {
      device.disconnect();
      await device.connect();
      BluetoothCharacteristic _characteristic;
      List<BluetoothService> services = await discoverServices(device);
      services.forEach((service) {
        /////////////
        if (service.uuid == PeripheralServices.SERVICE_HEART_RATE) {
          var characteristics = service.characteristics;
          for (BluetoothCharacteristic ch in characteristics) {
            if (ch.uuid == PeripheralCharacteristics.HEART_RATE_MEASUREMENT) {
              _characteristic = ch;
            }
          }
        }
      });
      await _characteristic.setNotifyValue(true);
      print(
          'bluetooth HeartRate_Characteristic set notify ${_characteristic.isNotifying}');
      _characteristic.value.listen((value) async {
        if (value.isNotEmpty) {
          print('Heart rate recently at ${DateTime.now()} is ${value[1]}');
          heartRateValue = value[1];
          await vitalSignHelper.updateHeartValue(value[1]);
          ReceiveNotification notiData = ReceiveNotification(
              id: 0, title: "reload heart rate", body: "", payload: "");
          HeartRefreshBloc.instance.newNotification(notiData);
          //
          return value[1];
        } else {
          // heartRateValue = 0;
          // await vitalSignHelper.updateHeartValue(0);
          ReceiveNotification notiData = ReceiveNotification(
              id: 0, title: "reload heart rate", body: "", payload: "");
          HeartRefreshBloc.instance.newNotification(notiData);
          print('Empty heart rate');
        }
      });
      return heartRateValue;
    } catch (e) {
      await vitalSignHelper.updateHeartValue(0);
      print('error at getHeartRateValueFromDevice ${e}');
      if (e.toString().contains(
          'PlatformException(already_connected, connection with device already exists, null, null)')) {
        device.disconnect();
        await device.connect();
        await _peripheralHelper.updatePeripheralChecking(
            true, device.id.toString());
        await getHeartRateValueFromDevice(peripheralId);
      }
      if (e.toString().contains(
          'Unhandled Exception: Exception: Another scan is already in progress')) {
        stopScanning();
        device.disconnect();
        await device.connect();
        await _peripheralHelper.updatePeripheralChecking(
            true, device.id.toString());
        await getHeartRateValueFromDevice(peripheralId);
      }
      if (e.toString().contains('could not find callback wrapper')) {
        stopScanning();
        Future.delayed(const Duration(seconds: 2), () async {
          //
          await getHeartRateValueFromDevice(peripheralId);
        });
      }
    }
  }

  //stop scan device
  Future<void> stopScanning() async {
    flutterBlue.stopScan();
  }
}

class VitalSignServerRepository extends BaseApiClient {
  final http.Client httpClient;
  //constructor
  VitalSignServerRepository({@required this.httpClient})
      : assert(httpClient != null);

  //get vital sign schedule
  Future<VitalSignScheduleDTO> getVitalSignSchedule(int patientId) async {
    String url = '/VitalSigns?patientId=${patientId}&status=active';
    try {
      //
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        List<VitalSignScheduleDTO> list = data.map((dto) {
          return VitalSignScheduleDTO.fromJson(dto);
        }).toList();
        return list.last;
      }
      return VitalSignScheduleDTO();
    } catch (e) {
      print('Error at get vital sign schedule ${e}');
    }
  }

  //push vital sign đi
  Future<bool> pushVitalSign(VitalSignPushDTO dto) async {
    String url = '/VitalSigns';
    try {
      //
      final response = await putApi(url, null, dto.toJson());
      print('response ${response.body}');
      if (response.statusCode == 204) {
        print('PUSH SUCCESSFUL VALUE VITAL SIGN INTO SERVER');
        return true;
      } else {
        print('PUSH FAIL VALUE  VITAL SIGN INTO SERVER');
        return false;
      }
    } catch (e) {
      print('error at push vital sign: ${e}');
    }
  }

  Future<VitalSignDetailDTO> getVitalSign(
      int patientId, int medicalInstructionId) async {
    String url =
        '/VitalSigns/GetVitalSignValueByMIId?medicalInstructionId=$medicalInstructionId&patientId=$patientId';

    try {
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        VitalSignDetailDTO dto =
            VitalSignDetailDTO.fromJson(jsonDecode(response.body));
        return dto;
      }
      return VitalSignDetailDTO();
    } catch (e) {
      print('Error at get vital sign ${e}');
      return VitalSignDetailDTO();
    }
  }
}
