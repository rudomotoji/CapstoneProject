import 'package:capstone_home_doctor/features/contract/events/medical_share_event.dart';
import 'package:capstone_home_doctor/features/contract/states/medical_share_state.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/health_record_repository.dart';
import 'package:capstone_home_doctor/features/payment/repositories/payment_repository.dart';
import 'package:capstone_home_doctor/models/med_ins_by_disease_dto.dart';
import 'package:capstone_home_doctor/models/medical_share_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentBloc extends Bloc<MedicalShareEvent, MedicalShareState> {
  final PaymentRepository paymentRepository;
  PaymentBloc({this.paymentRepository})
      : assert(paymentRepository != null),
        super(MedicalShareStateInitial());

  @override
  Stream<MedicalShareState> mapEventToState(MedicalShareEvent event) async* {
    if (event is MedicalShareEventGet) {
      yield MedicalShareStateLoading();
    }
  }
}
