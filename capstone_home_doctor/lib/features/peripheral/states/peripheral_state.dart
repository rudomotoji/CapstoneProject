import 'package:equatable/equatable.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/cupertino.dart';

abstract class PeripheralState extends Equatable {
  const PeripheralState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class PeripheralStateInitial extends PeripheralState {}

class PeripheralStateLoading extends PeripheralState {}

class PeripheralStateFailure extends PeripheralState {}

//success scann return list ScannResult
class PeripheralStateScanSuccess extends PeripheralState {
  final List<ScanResult> list;

  const PeripheralStateScanSuccess({@required this.list});

  @override
  // TODO: implement props
  List<Object> get props => [list];
}

//success connect device
class PeripheralStateConnectSuccess extends PeripheralState {
  final bool isConnect;

  const PeripheralStateConnectSuccess({@required this.isConnect});

  @override
  // TODO: implement props
  List<Object> get props => [isConnect];
}

//findDeviceByPeripheralId
class PeripheralStateFindByIdSuccess extends PeripheralState {
  final BluetoothDevice device;

  const PeripheralStateFindByIdSuccess({@required this.device});

  @override
  // TODO: implement props
  List<Object> get props => [device];
}

//stop scan
class PeripheralStateStopScan extends PeripheralState {}

//disconnect
class PeripheralStateDisconnect extends PeripheralState {}
