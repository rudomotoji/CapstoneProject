import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class MedInsDetailEvent extends Equatable {
  const MedInsDetailEvent();
}

class MedInsDetailEventGetById extends MedInsDetailEvent {
  final int id;
  const MedInsDetailEventGetById({@required this.id}) : assert(id != null);

  @override
  // TODO: implement props
  List<Object> get props => [id];
}
