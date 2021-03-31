import 'package:capstone_home_doctor/commons/constants/peripheral_services.dart';
import 'package:capstone_home_doctor/services/peripheral_helper.dart';
import 'package:flutter_blue/flutter_blue.dart';

final PeripheralHelper _peripheralHelper = PeripheralHelper();

class PeripheralRepository {
  final flutterBlue = FlutterBlue.instance;
  PeripheralRepository();

  //scan bluetooth device
  Future<List<ScanResult>> scanBluetoothDevice() async {
    List<ScanResult> listScanned = [];
    //
    await flutterBlue.startScan(timeout: Duration(seconds: 5));
    flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        //
        listScanned.add(r);
      }
    });
    return listScanned;
  }

  //stop scan device
  Future<void> stopScanning() async {
    flutterBlue.stopScan();
  }

  //disconnect device
  Future<void> disconnectDevice(BluetoothDevice device) async {
    device.disconnect();
  }

  //connect device first time
  Future<bool> connectDevice1stTime(ScanResult scanResult) async {
    BluetoothDevice device = scanResult.device;
    await device.connect();
    await _peripheralHelper.updatePeripheralChecking(
        true, device.id.toString());
    return true;
  }

  //find device by id
  Future<BluetoothDevice> findScanResultById(String peripheralId) async {
    BluetoothDevice result;
    List<BluetoothDevice> listConnected = await flutterBlue.connectedDevices;
    for (BluetoothDevice deviceCheck in listConnected) {
      if (peripheralId == deviceCheck.id.toString()) {
        //
        result = deviceCheck;
      }
    }
    return result;
  }

  //check peripheral keep connect or not
  Future<bool> checkPeripheralKeepConnect(BluetoothDevice device) async {
    //
    bool check = false;
    List<BluetoothDevice> listConnected = await flutterBlue.connectedDevices;
    for (BluetoothDevice deviceCheck in listConnected) {
      if (device.id == deviceCheck.id) {
        check = true;
      }
    }
    return check;
  }

  //connect device in background
  Future<bool> connectDeviceInBackground(String peripheralId) async {
    bool check = false;
    await FlutterBlue.instance.startScan(timeout: Duration(seconds: 5));
    print('Scanning to connect in background');
    FlutterBlue.instance.scanResults.listen((results) async {
      for (ScanResult r in results) {
        if (check == true) {
          break;
        }
        if (r.device.id.toString() == peripheralId) {
          await connectDevice1stTime(r);
          stopScanning();
          print('Re-connect peripheral device successful');
          check = true;
          return check;
        } else {
          await _peripheralHelper.updatePeripheralChecking(false, peripheralId);
          check = false;
        }
      }
    });
    return check;
  }

  //...

  //discover services
  Future<List<BluetoothService>> discoverServices(
      BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    return services;
  }

  //get battery device
  Future<int> getBatteryDevice(String peripheralId) async {
    try {
      BluetoothDevice device = await findScanResultById(peripheralId);
      // device.disconnect();
      // await device.connect();
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
      int batteryValue = 0;
      print('bluetooth Battery_ch set notify ${_characteristic.isNotifying}');
      await _characteristic.value.listen((value) async {
        if (value.isNotEmpty) {
          batteryValue = value[1];

          print('battery value into function get ${batteryValue}');
          return batteryValue;
        } else {
          print('Cannot get battery percentage');
        }
      });
      return batteryValue;
    } catch (e) {
      print('Error at get battery device: ${e}');
    }
  }
}
