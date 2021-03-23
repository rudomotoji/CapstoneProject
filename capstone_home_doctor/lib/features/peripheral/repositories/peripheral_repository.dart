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
        if (r.device.id.toString() == peripheralId) {
          await connectDevice1stTime(r);
          print('Re-connect peripheral device successful');
          check = true;
        } else {
          await _peripheralHelper.updatePeripheralChecking(false, peripheralId);
          print('LOST CONNECT PERIPHERAL DEVICE');
          check = false;
        }
      }
    });
    return check;
  }

  //discover services in device

  //get battery

  //read heart rate

  //...

}
