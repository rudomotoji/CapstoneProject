import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class DiseaseListEvent extends Equatable {
  const DiseaseListEvent();
}

class DiseaseListEventSetStatus extends DiseaseListEvent {
  final String status;

  const DiseaseListEventSetStatus({@required this.status})
      : assert(status != null);

  @override
  // TODO: implement props
  List<Object> get props => [status];
}

class DiseaseEventGetHealthList extends DiseaseListEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
