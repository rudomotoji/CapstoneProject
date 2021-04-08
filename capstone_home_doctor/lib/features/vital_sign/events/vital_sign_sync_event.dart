import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class VitalSignSyncEvent extends Equatable {
  const VitalSignSyncEvent();
}

class VitalSignSyncEventGetByDate extends VitalSignSyncEvent {
  final int patientId;
  final String date;

  const VitalSignSyncEventGetByDate(
      {@required this.patientId, @required this.date});

  @override
  // TODO: implement props
  List<Object> get props => [patientId, date];
}
