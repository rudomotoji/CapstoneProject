import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ListContractEvent extends Equatable {
  const ListContractEvent();
}

class ListContractEventSetPatientId extends ListContractEvent {
  final int id;

  const ListContractEventSetPatientId({@required this.id}) : assert(id != null);
  @override
  // TODO: implement props
  List<Object> get props => [id];
}
