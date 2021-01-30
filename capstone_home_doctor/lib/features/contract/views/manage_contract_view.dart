import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_list_bloc.dart';
import 'package:capstone_home_doctor/features/contract/events/list_contract_event.dart';
import 'package:capstone_home_doctor/features/contract/repositories/list_contract_repository.dart';
import 'package:capstone_home_doctor/features/contract/states/list_contract_state.dart';
import 'package:capstone_home_doctor/models/contract_inlist_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageContract extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ManageContract();
  }
}

class _ManageContract extends State<ManageContract> {
  ListContractRepository listContractRepository =
      ListContractRepository(httpClient: http.Client());
  List<ContractListDTO> _listContract;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HeaderWidget(
              title: 'Hợp đồng',
              isMainView: false,
            ),
            Expanded(
              child: BlocProvider(
                create: (context) =>
                    ContractListBloc(listContractAPI: listContractRepository)
                      ..add(ListContractEventSetPatientId(id: 2)),
                child: BlocBuilder<ContractListBloc, ListContractState>(
                    builder: (context, state) {
                  if (state is ListContractStateLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is ListContractStateFailure) {
                    return Center(child: Text('FAILED'));
                  }
                  if (state is ListContractStateSuccess) {
                    if (state.listContract == null) {
                      return Center(child: Text('Empty comments !'));
                    }
                    _listContract = state.listContract;
                    for (var i = 0; i < _listContract.length; i++) {
                      if (_listContract[i].status == 'ACTIVE') {
                        print('CO HOP DONG ACTIVED ROI');
                        //_listActived.add(_listContract[i]);
                      }
                      if (_listContract[i].status == 'PENDING') {
                        print('CO HOP DONG PENDING ROI');
                        //_listPending.add(_listContract[i]);
                      }
                      if (_listContract[i].status == 'FINISHED') {
                        print('CO HOP DONG PENDING ROI');
                        // _listFinished.add(_listContract[i]);
                      }
                    }
                    return ListView.builder(
                      itemCount: state.listContract.length,
                      itemBuilder: (BuildContext buildContext, int index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 40,
                              child: Container(
                                decoration: BoxDecoration(
                                    //borderRadius: BorderRadius.circular(0),
                                    color: DefaultTheme.GREY_BUTTON),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                    ),
                                    Text(
                                        'Ngày bắt đầu ${state.listContract[index].dateStarted.split('T')[0]}'),
                                    Text(
                                        'Ngày kết thúc ${state.listContract[index].dateFinished.split('T')[0]}'),
                                    Text(
                                        'Ngày bắt đầu ${state.listContract[index].status}'),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  return Text('other state');
                }),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
          ],
        ),
      ),
    );
  }

  _contractElement(String createdDate, String endDate, String status) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Ngày bắt đầu ${createdDate}'),
          Text('Ngày kết thúc ${endDate}'),
          Text('Trạng thái ${status}'),
        ],
      ),
    );
  }
}
