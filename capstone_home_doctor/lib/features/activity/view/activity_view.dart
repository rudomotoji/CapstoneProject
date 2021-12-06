import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/activity/blocs/doctor_list_bloc.dart';
import 'package:capstone_home_doctor/features/activity/event/doctor_list_event.dart';
import 'package:capstone_home_doctor/features/activity/state/doctor_info_state.dart';
import 'package:capstone_home_doctor/models/doctor_list_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/doctor_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final AuthenticateHelper _authenticateHelper = AuthenticateHelper();
final DateValidator _dateValidator = DateValidator();
final DoctorHelper _doctorHelper = DoctorHelper();

class ActivityView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ActivityView();
  }
}

class _ActivityView extends State<ActivityView> with WidgetsBindingObserver {
  int _patientId = 0;
  DoctorListBloc _doctorListBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _doctorListBloc = BlocProvider.of(context);
    _getPatientId();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //
  _getPatientId() async {
    await _authenticateHelper.getPatientId().then((value) {
      _patientId = value;
      if (_patientId != 0) {
        _doctorListBloc
            .add(DoctorListEventGetByPatientId(patientId: _patientId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HeaderWidget(
            title: 'Hoạt động',
            isMainView: true,
            buttonHeaderType: ButtonHeaderType.AVATAR,
          ),
          //
          Padding(
            padding: EdgeInsets.only(top: 5, left: 20, bottom: 15, right: 10),
            child: Text(
                'Xem lại các hoạt động diễn ra giữa bạn và bác sĩ. Đây là danh sách các bác sĩ đã và đang có hợp đồng theo dõi với bạn.'),
          ),

          Expanded(
            child: ListView(
              children: <Widget>[
                //
                BlocBuilder<DoctorListBloc, DoctorListState>(
                    builder: (context, state) {
                  //
                  if (state is DoctorListStateLoading) {
                    return Container(
                      width: 200,
                      height: 200,
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset('assets/images/loading.gif'),
                      ),
                    );
                  }
                  if (state is DoctorListStateFailure) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        child: Center(
                          child: Text('Không thể tải'),
                        ));
                  }
                  if (state is DoctorListStateSuccess) {
                    if (state.list == null) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          height: 500,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Image.asset(
                                      'assets/images/ic-acti-u.png'),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                ),
                                Text('Bạn chưa có hoạt động nào')
                              ],
                            ),
                          ));
                    }
                    // return ListView.builder(
                    //   shrinkWrap: true,
                    //   physics: NeverScrollableScrollPhysics(),
                    //   itemCount: state.list.length,
                    //   itemBuilder: (BuildContext context, int index) {
                    //     return Container(
                    //       child: Text('${state.list[index].doctorName}'),
                    //     );
                    //   },
                    // );
                    //
                    return GridView(
                      padding: EdgeInsets.all(10),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent:
                            MediaQuery.of(context).size.width / 2 - 20,
                        childAspectRatio: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      children:
                          //Category Items
                          state.list.map((dto) => doctorItem(dto)).toList(),
                    );
                  }
                  return Container();
                }),
                //
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget doctorItem(DoctorListDTO dto) {
    return InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          //
          await _doctorHelper.updateDoctor(dto.accountDoctorId);
          Navigator.of(context).pushNamed(RoutesHDr.ACTIVITY_TIME_VIEW);
          print('tapped');
        },
        child: Stack(
          children: <Widget>[
            //
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset('assets/images/avatar-default.jpg'),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 80,
                padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                width: MediaQuery.of(context).size.width / 2 - 15,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(12)),
                  color: DefaultTheme.BLACK.withOpacity(0.8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bác sĩ:\n${dto.doctorName}',
                        style: TextStyle(color: DefaultTheme.WHITE)),
                    Spacer(),
                    Text(
                        'Hợp đồng bắt đầu:\n${_dateValidator.parseToDateView4(dto.dateContractStarted)}',
                        style: TextStyle(color: DefaultTheme.WHITE)),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
