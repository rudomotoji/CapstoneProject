import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class MedicalInstructionListEvent extends Equatable {
  const MedicalInstructionListEvent();
}

class MedicalInstructionListEventGetList extends MedicalInstructionListEvent {
  final int hrId;
  const MedicalInstructionListEventGetList({@required this.hrId})
      : assert(hrId != null);

  @override
  // TODO: implement props
  List<Object> get props => [hrId];
}
