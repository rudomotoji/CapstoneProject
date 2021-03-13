import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ContractFullEvent extends Equatable {
  const ContractFullEvent();
}

class ContractFullEventSetCId extends ContractFullEvent {
  final int cId;

  const ContractFullEventSetCId({@required this.cId}) : assert(cId != null);
  @override
  // TODO: implement props
  List<Object> get props => [cId];
}
