import 'dart:async';
import 'dart:convert';

import 'package:capstone_home_doctor/commons/constants/peripheral_services.dart';
import 'package:capstone_home_doctor/features/peripheral/repositories/peripheral_repository.dart';
import 'package:capstone_home_doctor/features/vital_sign/blocs/real_time_vt_bloc.dart';
import 'package:capstone_home_doctor/models/vital_sign_detail_dto.dart';
import 'package:capstone_home_doctor/models/vital_sign_push_dto.dart';
import 'package:capstone_home_doctor/models/vital_sign_schedule_dto.dart';
import 'package:capstone_home_doctor/services/peripheral_helper.dart';
import 'package:capstone_home_doctor/services/vital_sign_helper.dart';
import 'package:flutter/material.dart';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:capstone_home_doctor/services/noti_helper.dart';
import 'package:capstone_home_doctor/services/notifications_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:capstone_home_doctor/commons/http/base_api_client.dart';

final PeripheralHelper _peripheralHelper = PeripheralHelper();
//final RealTimeHeartRateBloc _realTimeHeartRateBloc = RealTimeHeartRateBloc();

class VitalSignRepository {
  final flutterBlue = FlutterBlue.instance;
  final PeripheralRepository peripheralRepository = PeripheralRepository();
  final VitalSignHelper vitalSignHelper = VitalSignHelper();
  VitalSignRepository();

  RealTimeHeartRateBloc realtimeBloc = new RealTimeHeartRateBloc();

  //discover services
  // Future<List<BluetoothService>> discoverServices(
  //     BluetoothDevice device) async {
  //   try {
  //     List<BluetoothService> services = await device.discoverServices();
  //     return services;
  //   } catch (e) {
  //     if (e.toString().contains('could not find callback wrapper')) {
  //       await flutterBlue.stopScan();
  //       Future.delayed(const Duration(seconds: 2), () async {
  //         //
  //         await discoverServices(device);
  //       });
  //     }
  //   }
  // }

  //kick Heart Rate Control Point on.
  Future<void> kickHRCOn(String peripheralId) async {
    try {
      List<BluetoothService> listService = [];

      await flutterBlue.stopScan();
      await peripheralRepository
          .findScanResultById(peripheralId)
          .then((device) async {
        await device.disconnect();
        await device.connect();
        await peripheralRepository.discoverServices(device).then((list) async {
          listService = list;
          // for (BluetoothService service in list) {
          //   for (BluetoothCharacteristic ch in service.characteristics) {
          //     if (ch.uuid ==
          //         PeripheralCharacteristics.HEART_RATE_CONTROL_POINT) {
          //       print('WRITE HR CONTROL POINT');
          //       await ch
          //           .write(PeripheralCommand.START_HEART_RATE_MORNITORING)
          //           .then((value) async {
          //         // print('VALUE WHEN WRITTING 2A39 NOW: $value');
          //       });
          //     }
          //   }
          // }
          BluetoothService heartRateService = listService
              .where(
                  (item) => item.uuid == PeripheralServices.SERVICE_HEART_RATE)
              .toList()
              .first;
          for (BluetoothCharacteristic ch in heartRateService.characteristics) {
            BluetoothCharacteristic heartRateControlPoint = heartRateService
                .characteristics
                .where((item) =>
                    item.uuid ==
                    PeripheralCharacteristics.HEART_RATE_CONTROL_POINT)
                .toList()
                .first;
            BluetoothCharacteristic heartRateMeasurement = heartRateService
                .characteristics
                .where((item) =>
                    item.uuid ==
                    PeripheralCharacteristics.HEART_RATE_MEASUREMENT)
                .toList()
                .first;
            await heartRateControlPoint
                .write(PeripheralCommand.START_HEART_RATE_MORNITORING)
                .then((_) async {
              await heartRateMeasurement.setNotifyValue(true);

              await heartRateMeasurement.value.listen((heartRateValue) async {
                if (heartRateValue.isNotEmpty) {
                  //real time heart rate showing
                  await realtimeHeartRateBloc.realtimeHrSink
                      .add(heartRateValue[1]);
                  // ReceiveNotification notiData = ReceiveNotification(
                  //     id: 0,
                  //     title: "realtime heart rate",
                  //     body: "${heartRateValue[1]}",
                  //     payload: "");
                  // HeartRealTimeBloc.instance.newNotification(notiData);

                  print(
                      'Heart rate on control point recently at ${DateTime.now()} is ${heartRateValue[1]}');
                } else {
                  // print('Empty heart rate');
                }
              });
            });
          }
        });
      });

      // BluetoothCharacteristic _characteristicHR;
      // BluetoothCharacteristic _characteristicHRC;
      // List<BluetoothService> services = await discoverServices(device);
      // services.forEach((service) async {
      //   /////////////

      //   for (BluetoothCharacteristic ch in service.characteristics) {
      //     if (ch.uuid == PeripheralCharacteristics.HEART_RATE_CONTROL_POINT) {
      //       _characteristicHRC = ch;
      //       await _characteristicHRC.setNotifyValue(true);
      //       print(
      //           'Bluetooth chars heart rate control point set notifying: ${_characteristicHRC.isNotifying}');
      //       await _characteristicHRC
      //           .write(PeripheralCommand.START_HEART_RATE_MORNITORING)
      //           .then((value) async {
      //         print('WHEN HR CONTROL POINT KICK ON: ${value.toString()}');
      //       });
      //     }
      //   }
      // });

    } catch (e) {
      if (e.toString().contains(
          'PlatformException(already_connected, connection with device already exists, null, null)')) {
        await flutterBlue.stopScan();
        BluetoothDevice device =
            await peripheralRepository.findScanResultById(peripheralId);
        await device.disconnect();
        await device.connect();
        // await _peripheralHelper.updatePeripheralChecking(
        //     true, device.id.toString());
        await kickHRCOn(peripheralId);
      }
      if (e.toString().contains(
          'Unhandled Exception: Exception: Another scan is already in progress')) {
        await flutterBlue.stopScan();
        await flutterBlue.stopScan();
        BluetoothDevice device =
            await peripheralRepository.findScanResultById(peripheralId);
        await device.disconnect();
        await device.connect();
        // await _peripheralHelper.updatePeripheralChecking(
        //     true, device.id.toString());
        await kickHRCOn(peripheralId);
      }
      if (e.toString().contains('could not find callback wrapper')) {
        await flutterBlue.stopScan();
        Future.delayed(const Duration(seconds: 2), () async {
          //
          await kickHRCOn(peripheralId);
        });
      }
    }
  }

  // get heart rate characteristic
  Future<int> getHeartRateValueFromDevice(String peripheralId) async {
    int heartRateValue = 0;
    try {
      await flutterBlue.stopScan();
      BluetoothDevice device =
          await peripheralRepository.findScanResultById(peripheralId);
      await device.disconnect();
      await device.connect();
      BluetoothCharacteristic _characteristic;
      List<BluetoothService> services = await device.discoverServices();
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
          await realtimeHeartRateBloc.realtimeHrSink.add(value[1]);
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
      //  await vitalSignHelper.updateHeartValue(0);
      //await flutterBlue.stopScan();
      print('error at getHeartRateValueFromDevice ${e}');
      if (e.toString().contains(
          'PlatformException(already_connected, connection with device already exists, null, null)')) {
        await flutterBlue.stopScan();
        BluetoothDevice device =
            await peripheralRepository.findScanResultById(peripheralId);
        await device.disconnect();
        await device.connect();
        await _peripheralHelper.updatePeripheralChecking(
            true, device.id.toString());
        await getHeartRateValueFromDevice(peripheralId);
      }
      if (e.toString().contains(
          'Unhandled Exception: Exception: Another scan is already in progress')) {
        await flutterBlue.stopScan();
        BluetoothDevice device =
            await peripheralRepository.findScanResultById(peripheralId);

        await device.disconnect();
        await device.connect();
        await _peripheralHelper.updatePeripheralChecking(
            true, device.id.toString());
        await getHeartRateValueFromDevice(peripheralId);
      }
      if (e.toString().contains('could not find callback wrapper')) {
        await flutterBlue.stopScan();
        await getHeartRateValueFromDevice(peripheralId);
      }
    }
  }

  //stop scan device
  // Future<void> stopScanning() async {
  //   flutterBlue.stopScan();
  // }
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
