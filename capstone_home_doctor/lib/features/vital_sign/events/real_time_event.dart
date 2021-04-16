import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class RealtimeVitalSignEvent extends Equatable {
  const RealtimeVitalSignEvent();
}

class RealtimeVitalSignEventGet extends RealtimeVitalSignEvent {
  final String peripheralId;
  const RealtimeVitalSignEventGet({@required this.peripheralId});

  @override
  // TODO: implement props
  List<Object> get props => [peripheralId];
}
