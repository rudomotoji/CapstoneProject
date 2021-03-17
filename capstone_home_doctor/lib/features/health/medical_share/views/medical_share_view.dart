import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_list_bloc.dart';
import 'package:capstone_home_doctor/features/contract/events/contract_list_event.dart';
import 'package:capstone_home_doctor/features/contract/events/doctor_info_event.dart';
import 'package:capstone_home_doctor/features/contract/states/contract_list_state.dart';
import 'package:capstone_home_doctor/features/contract/states/doctor_info_state.dart';
import 'package:capstone_home_doctor/models/contract_inlist_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MedicalShare extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MedicalShare();
  }
}

class _MedicalShare extends State<MedicalShare> with WidgetsBindingObserver {
  final AuthenticateHelper _authenticateHelper = AuthenticateHelper();

  int _contractId;
  int _patientId = 0;
  List<ContractListDTO> _listContracts = List<ContractListDTO>();
  ContractListDTO dropdownValue;
  ContractListBloc _contractListBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _contractListBloc = BlocProvider.of(context);
    _getPatientId();
  }

  @override
  Widget build(BuildContext context) {
    _contractId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HeaderWidget(
              title: 'Chia sẻ thêm y lệnh',
              isMainView: false,
              buttonHeaderType: ButtonHeaderType.BACK_HOME,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _pullRefresh,
                child: (_contractId == null)
                    ? ListView(
                        children: [
                          BlocBuilder<ContractListBloc, ListContractState>(
                            builder: (context, state) {
                              if (state is ListContractStateLoading) {
                                return Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: DefaultTheme.GREY_BUTTON),
                                  child: Center(
                                    child: SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: Image.asset(
                                          'assets/images/loading.gif'),
                                    ),
                                  ),
                                );
                              }
                              if (state is ListContractStateFailure) {
                                print('---ListContractStateFailure---');
                              }
                              if (state is ListContractStateSuccess) {
                                _listContracts = [];
                                for (var contract in state.listContract) {
                                  if (contract.status == 'ACTIVE') {
                                    _listContracts.add(contract);
                                  }
                                }
                                return _selectContract();
                              }
                              return Container();
                            },
                          ),
                          _listShare(),
                        ],
                      )
                    : ListView(
                        children: [
                          _listShare(),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectContract() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        padding: EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
            color: DefaultTheme.GREY_VIEW,
            borderRadius: BorderRadius.circular(6)),
        child: DropdownButton<ContractListDTO>(
          value: dropdownValue,
          items: _listContracts.map((ContractListDTO value) {
            return new DropdownMenuItem<ContractListDTO>(
              value: value,
              child: new Text(
                value.contractCode,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            );
          }).toList(),
          dropdownColor: DefaultTheme.GREY_VIEW,
          elevation: 1,
          hint: Container(
            width: MediaQuery.of(context).size.width - 84,
            child: Text(
              'Chọn hợp đồng để chia sẻ:',
              style: TextStyle(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          underline: Container(
            width: 0,
          ),
          isExpanded: false,
          onChanged: (res) {
            setState(() {
              dropdownValue = res;
            });
          },
        ),
      ),
    );
  }

  Widget _listShare() {
    return Container();
  }

  Future<void> _pullRefresh() async {
    // _doctorInfoBloc.add(DoctorInfoEventGetDoctors());
  }
  _getPatientId() async {
    await _authenticateHelper.getPatientId().then((value) async {
      setState(() {
        _patientId = value;
        if (_patientId != 0 && _contractId == null) {
          _contractListBloc.add(ListContractEventSetPatientId(id: _patientId));
        }
      });
    });
  }
}
