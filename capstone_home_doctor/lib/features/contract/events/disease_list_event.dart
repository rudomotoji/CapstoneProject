import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class DiseaseListEvent extends Equatable {
  const DiseaseListEvent();
}

class DiseaseListEventSetStatus extends DiseaseListEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DiseaseEventGetHealthList extends DiseaseListEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DiseaseEventSetInitial extends DiseaseListEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DiseaseContractGetList extends DiseaseListEvent {
  final int patientId;

  const DiseaseContractGetList({@required this.patientId});

  @override
  // TODO: implement props
  List<Object> get props => [patientId];
}
