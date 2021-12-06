import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class HRListEvent extends Equatable {
  const HRListEvent();
}

class HRListEventSetPersonalHRId extends HRListEvent {
  final int personalHealthRecordId;

  const HRListEventSetPersonalHRId({@required this.personalHealthRecordId})
      : assert(personalHealthRecordId != null);

  @override
  // TODO: implement props
  List<Object> get props => [personalHealthRecordId];
}

//
