import 'package:equatable/equatable.dart';

abstract class MedicalShareInsEvent extends Equatable {
  const MedicalShareInsEvent();
}

class MedicalShareInsEventSend extends MedicalShareInsEvent {
  final int healthRecordId;
  final List<int> listMediIns;

  const MedicalShareInsEventSend({this.healthRecordId, this.listMediIns});

  @override
  // TODO: implement props
  List<Object> get props => [healthRecordId, listMediIns];
}

class MedicalShareInsEventInitial extends MedicalShareInsEvent {
  const MedicalShareInsEventInitial();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class MedicalShareInsEventGetMedIns extends MedicalShareInsEvent {
  final int contractID;

  const MedicalShareInsEventGetMedIns({this.contractID});

  @override
  // TODO: implement props
  List<Object> get props => [contractID];
}
