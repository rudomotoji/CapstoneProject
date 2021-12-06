import 'package:capstone_home_doctor/features/peripheral/events/peripheral_event.dart';
import 'package:capstone_home_doctor/features/peripheral/repositories/peripheral_repository.dart';
import 'package:capstone_home_doctor/features/peripheral/states/peripheral_state.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PeripheralBloc extends Bloc<PeripheralEvent, PeripheralState> {
  final PeripheralRepository peripheralRepository;
  PeripheralBloc({@required this.peripheralRepository})
      : assert(peripheralRepository != null),
        super(PeripheralStateInitial());

  @override
  Stream<PeripheralState> mapEventToState(PeripheralEvent event) async* {
    //start scan
    if (event is PeripheralEventScan) {
      yield PeripheralStateLoading();
      try {
        final List<ScanResult> listScannedDevice =
            await peripheralRepository.scanBluetoothDevice();
        yield PeripheralStateScanSuccess(list: listScannedDevice);
      } catch (e) {
        yield PeripheralStateFailure();
      }
    }
    //stop scan
    if (event is PeripheralEventStopScan) {
      yield PeripheralStateLoading();
      try {
        //
        yield PeripheralStateStopScan();
      } catch (e) {
        yield PeripheralStateFailure();
      }
    }
    //connect 1st time
    if (event is PeripheralEventConnectFirstTime) {
      yield PeripheralStateLoading();
      try {
        final bool check =
            await peripheralRepository.connectDevice1stTime(event.scanResult);
        yield PeripheralStateConnectSuccess(isConnect: check);
      } catch (e) {
        yield PeripheralStateFailure();
      }
    }
    //disconnect
    if (event is PeripheralEventDisconnect) {
      yield PeripheralStateLoading();
      try {
        //
        yield PeripheralStateDisconnect();
      } catch (e) {
        yield PeripheralStateFailure();
      }
    }
    //find by id
    if (event is PeripheralEventFindById) {
      yield PeripheralStateLoading();
      try {
        final BluetoothDevice device =
            await peripheralRepository.findScanResultById(event.id);
        yield PeripheralStateFindByIdSuccess(device: device);
      } catch (e) {
        yield PeripheralStateFailure();
      }
    }
    //connect in background
    if (event is PeripheralEventConnectBackground) {
      yield PeripheralStateLoading();
      try {
        //
        final bool isConnectBg = await peripheralRepository
            .connectDeviceInBackground(event.peripheralId);
        if (isConnectBg) {
          yield PeripheralStateConnectSuccess(isConnect: isConnectBg);
        } else {}
      } catch (e) {
        print('CATCH BG CONNECTED: ${e}');
        yield PeripheralStateFailure();
      }
    }
  }
}

class BatteryDeviceBloc extends Bloc<PeripheralEvent, PeripheralState> {
  final PeripheralRepository peripheralRepository;
  BatteryDeviceBloc({@required this.peripheralRepository})
      : assert(peripheralRepository != null),
        super(PeripheralStateInitial());

  @override
  Stream<PeripheralState> mapEventToState(PeripheralEvent event) async* {
    if (event is BatteryEventGet) {
      yield PeripheralStateLoading();
      try {
        int battery =
            await peripheralRepository.getBatteryDevice(event.peripheralId);
        print('peripheral id in bloc: ${event.peripheralId}');
        print('into bloc value now is $battery');
        yield BatteryStateSuccess(value: battery);
      } catch (e) {
        print('CATCH BATTERY: ${e}');
        yield PeripheralStateFailure();
      }
    }
  }
}
