import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class HeartRateEvent extends Equatable {
  const HeartRateEvent();
}

class HeartRateEventGetList extends HeartRateEvent {
  const HeartRateEventGetList();
  @override
  // TODO: implement props
  List<Object> get props => [];
}
