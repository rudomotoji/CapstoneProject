import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';

abstract class PeripheralEvent extends Equatable {
  const PeripheralEvent();
}

class PeripheralEventScan extends PeripheralEvent {
  const PeripheralEventScan();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

//event connect 1st time
class PeripheralEventConnectFirstTime extends PeripheralEvent {
  final ScanResult scanResult;

  const PeripheralEventConnectFirstTime({@required this.scanResult});
  @override
  // TODO: implement props
  List<Object> get props => [scanResult];
}

//event connect in background
class PeripheralEventConnectBackground extends PeripheralEvent {
  final String peripheralId;

  const PeripheralEventConnectBackground({@required this.peripheralId});

  @override
  // TODO: implement props
  List<Object> get props => [peripheralId];
}

//event get services value
//

//event stop scan
class PeripheralEventStopScan extends PeripheralEvent {
  const PeripheralEventStopScan();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

//event find by id
class PeripheralEventFindById extends PeripheralEvent {
  final String id;

  const PeripheralEventFindById({@required this.id});

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

//event disconnect Device
class PeripheralEventDisconnect extends PeripheralEvent {
  final BluetoothDevice device;

  const PeripheralEventDisconnect({@required this.device});

  @override
  // TODO: implement props
  List<Object> get props => [device];
}
