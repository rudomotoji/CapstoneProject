import 'package:capstone_home_doctor/features/vital_sign/events/vital_sign_sync_event.dart';
import 'package:capstone_home_doctor/features/vital_sign/repositories/vital_sign_sync_repository.dart';
import 'package:capstone_home_doctor/features/vital_sign/states/vital_sign_sync_state.dart';
import 'package:capstone_home_doctor/models/vital_sign_sync_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VitalSignSyncBloc extends Bloc<VitalSignSyncEvent, VitalSignSyncState> {
  final VitalSignSyncRepository vitalSignSyncRepository;
  VitalSignSyncBloc({@required this.vitalSignSyncRepository})
      : assert(vitalSignSyncRepository != null),
        super(VitalSignSyncStateInitial());

  @override
  Stream<VitalSignSyncState> mapEventToState(VitalSignSyncEvent event) async* {
    if (event is VitalSignSyncEventGetByDate) {
      yield VitalSignSyncStateLoading();
      try {
        final VitalSignSyncDTO dto = await vitalSignSyncRepository
            .getVitalSignByDate(event.patientId, event.date);
        yield VitalSignSyncStateSuccess(dto: dto);
      } catch (e) {
        yield VitalSignSyncStateFailure();
      }
    }
  }
}
