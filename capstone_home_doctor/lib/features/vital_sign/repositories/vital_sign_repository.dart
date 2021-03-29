import 'dart:convert';
import 'dart:typed_data';

import 'package:capstone_home_doctor/commons/constants/peripheral_services.dart';
import 'package:capstone_home_doctor/features/peripheral/repositories/peripheral_repository.dart';
import 'package:capstone_home_doctor/models/vital_sign_schedule_dto.dart';
import 'package:capstone_home_doctor/services/vital_sign_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:http/http.dart' as http;
import 'package:capstone_home_doctor/commons/http/base_api_client.dart';

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

  //get battery device
  Future<ByteData> getBatteryDevice(String peripheralId) async {
    try {
      ByteData batteryValue;
      BluetoothDevice device =
          await peripheralRepository.findScanResultById(peripheralId);
      device.disconnect();
      await device.connect();
      BluetoothCharacteristic _characteristic;
      List<BluetoothService> services = await discoverServices(device);
      services.forEach((service) {
        for (BluetoothCharacteristic ch in service.characteristics) {
          if (ch.uuid == PeripheralCharacteristics.BATTERY_INFORMATION) {
            _characteristic = ch;
          }
        }
      });
      await _characteristic.setNotifyValue(true);
      print('bluetooth Battery_ch set notify ${_characteristic.isNotifying}');
      _characteristic.value.listen((value) {
        if (value.isNotEmpty) {
          var manifactureData = Uint8List.fromList(value);
          var batteryData = ByteData.sublistView(manifactureData, 14, 15);

          print('Battery percent now at ${DateTime.now()} is: ${batteryData}');

          batteryValue = batteryData;
        } else {
          print('Cannot get battery percentage');
        }
      });
      return batteryValue;
    } catch (e) {
      print('Error at get battery device: ${e}');
    }
  }

  //get heart rate characteristic
  Future<int> getHeartRateValueFromDevice(String peripheralId) async {
    try {
      int heartRateValue = 0;
      BluetoothDevice device =
          await peripheralRepository.findScanResultById(peripheralId);
      device.disconnect();
      await device.connect();
      BluetoothCharacteristic _characteristic;
      List<BluetoothService> services = await discoverServices(device);
      services.forEach((service) {
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
        } else {
          print('Empty heart rate');
        }
      });
      return heartRateValue;
    } catch (e) {
      print('error at getHeartRateValueFromDevice ${e}');
    }
  }

  //get heart rate value
  // Future<int> getHeartRateValueFromDevice(String peripheralId) async {
  //   print('go into get heart rate from device func');
  //   BluetoothDevice device =
  //       await peripheralRepository.findScanResultById(peripheralId);

  //   print('device when get heart rate is ${device.name}');
  //   BluetoothCharacteristic characteristic =
  //       await getHeartRateCharacteristic(device);
  //   int heartRateValue = 0;
  //   await characteristic.setNotifyValue(true);
  //   print(
  //       'bluetooth HeartRate_Characteristic set notify ${characteristic.isNotifying}');
  //   await characteristic.value.listen((value) {
  //     if (value.isNotEmpty) {
  //       print('Heart rate recently at ${DateTime.now()} is ${value[1]}');
  //       heartRateValue = value[1];
  //     } else {
  //       print('Empty heart rate');
  //     }
  //   });
  //   return heartRateValue;
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
        return list[0];
      }
      return VitalSignScheduleDTO();
    } catch (e) {
      print('Error at get vital sign schedule ${e}');
    }
  }
}
