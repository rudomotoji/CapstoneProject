import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ContractIdNowEvent extends Equatable {
  const ContractIdNowEvent();
}

class ContractIdNowEventSetPIdAndDId extends ContractIdNowEvent {
  final int pId;
  final int dId;

  const ContractIdNowEventSetPIdAndDId({@required this.pId, this.dId})
      : assert(pId != null && dId != null);
  @override
  // TODO: implement props
  List<Object> get props => [pId, dId];
}
