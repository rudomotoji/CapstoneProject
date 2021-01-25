import 'package:capstone_home_doctor/commons/http/doctor_api.dart';
import 'package:capstone_home_doctor/features/contract/doctor_info_event.dart';
import 'package:capstone_home_doctor/features/contract/doctor_info_state.dart';
import 'package:capstone_home_doctor/models/doctor_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorInfoBloc extends Bloc<DoctorInfoEvent, DoctorInfoState> {
  DoctorAPI doctorAPI;
  String id;
  DoctorInfoBloc({this.id}) : super(DoctorInfoStateInitial());
  @override
  Stream<DoctorInfoState> mapEventToState(DoctorInfoEvent event) async* {
    if (event is DoctorInfoSetIdEvent) {
      try {
        print('${id}');
        if (id == null) {
          yield DoctorInfoStateFailure();
        }
        if (state is DoctorInfoStateInitial) {
          DoctorDTO dto = await doctorAPI.getDoctorByDoctorId(id);
          yield DoctorInfoStateSuccess(dto: dto);
        } else if (state is DoctorInfoStateSuccess) {
          print('GO INTO BLOC and state is ${state.toString()}');
          DoctorDTO dto = await doctorAPI.getDoctorByDoctorId(id);
          print('dto-fullname INTO bloc now ${dto.fullName}');
          yield DoctorInfoStateSuccess(dto: dto);
        }
      } catch (e) {
        yield DoctorInfoStateFailure();
      }
    }
  }
}
