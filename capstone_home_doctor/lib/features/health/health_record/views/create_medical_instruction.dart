import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/utils/img_util.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/multiple_select_tag/multi_select_chip_display.dart';
import 'package:capstone_home_doctor/commons/widgets/multiple_select_tag/multi_select_item.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:capstone_home_doctor/features/contract/blocs/disease_list_bloc.dart';
import 'package:capstone_home_doctor/features/contract/events/disease_list_event.dart';
import 'package:capstone_home_doctor/features/contract/states/disease_list_state.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/med_ins_create_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/med_ins_type_list_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/events/med_ins_create_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/events/med_ins_type_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/medical_instruction_repository.dart';
import 'package:capstone_home_doctor/features/health/health_record/states/med_ins_type_list_state.dart';
import 'package:capstone_home_doctor/models/disease_dto.dart';
import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:capstone_home_doctor/models/medical_instruction_type_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/health_record_helper.dart';
import 'package:capstone_home_doctor/services/medical_instruction_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:expandable_group/expandable_group_widget.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
// import 'package:diff_image/diff_image.dart';
// import 'package:image/image.dart' as imgs;
import 'package:flutter_rounded_date_picker/rounded_picker.dart';

class CreateMedicalInstructionView extends StatefulWidget {
  @override
  _CreateMedicalInstructionViewState createState() =>
      _CreateMedicalInstructionViewState();
}

class _CreateMedicalInstructionViewState
    extends State<CreateMedicalInstructionView> with WidgetsBindingObserver {
  int _medInsTypeId;
  int _hrId = 0;
  int _patientId = 0;
  String _selectedHRType = '';
  MedicalInstructionTypeDTO selectType;
  String strDiseaseDraft = '';
  PickedFile _imgFile;
  String _note = '';
  double titleCompare;

  // String _imgString = '';
  // String nowDate = '${DateTime.now()}';
  String dateCreate;
  List<MedicalInstructionTypeDTO> _listMedInsType = [];
  double percenntCompare = 100;
  var f = NumberFormat("###.0#", "en_US");
  var _diseaseIDController = TextEditingController();
  //
  List<String> listImage = [];
  // List<String> listImage64Bit = [];

//triệu chứng bệnh đối với các bệnh scrope
  List<Disease> listDisease = [];
  List<Disease> listDiseaseSelected = [];
  List<String> _diseaseIds = [];
  List<String> _diseaseViews = [];
  DateValidator _dateValidator = DateValidator();

  var _dianoseController = TextEditingController();
  MedicalInstructionHelper _medicalInstructionHelper =
      MedicalInstructionHelper();
  final picker = ImagePicker();
  HealthRecordHelper _healthRecordHelper = HealthRecordHelper();
  AuthenticateHelper _authenticateHelper = AuthenticateHelper();
  MedicalInstructionRepository _medicalInstructionRepository =
      MedicalInstructionRepository(httpClient: http.Client());

  MedInsCreateBloc _medInsCreateBloc;
  // MedInsScanTextBloc _medicalScanText;
  MedInsTypeListBloc _medInsTypeListBloc;

  // List<String> _diseaseIds = [];
  List<DiseaseLeverThrees> _listLv3Selected = [];
  //
  DiseaseListBloc _diseaseListBloc;

  //list disease
  List<DiseaseContractDTO> _listDiseaseForHeart = [];
  List<DiseaseContractDTO> _listDiseaseForHeartForSearch = [];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _medInsCreateBloc = BlocProvider.of(context);
    // _medicalScanText = BlocProvider.of(context);
    _medInsTypeListBloc = BlocProvider.of(context);
    _diseaseListBloc = BlocProvider.of(context);
    _diseaseListBloc.add(DiseaseListEventSetStatus());
    getDataFromJSONFile();
    _getPatientId();
    getHRId();
  }

  Future<void> getDataFromJSONFile() async {
    final String response = await rootBundle.loadString('assets/global.json');

    if (response.contains('percentCompare')) {
      final data = await json.decode(response);
      setState(() {
        percenntCompare = data["percentCompare"];
      });
    }

    var arguments = ModalRoute.of(context).settings.arguments;
    if (arguments != null) {
      listDisease.clear();
      listDiseaseSelected.clear();
      for (var item in arguments) {
        Disease dto =
            Disease(diseaseId: item.diseaseId, diseaseName: item.diseaseName);
        listDisease.add(dto);
        // listDiseaseSelected.add(dto);
      }
      // setState(() {
      //   _diseaseIds = listDisease.map((e) => e.diseaseId).toList();
      // });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _medInsCreateBloc.add(MedInsGetTextEventInitial());
    _diseaseListBloc.add(DiseaseEventSetInitial());
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HeaderWidget(
              title: 'Thêm y lệnh',
              isMainView: false,
              buttonHeaderType: ButtonHeaderType.BACK_HOME,
            ),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        (_selectedHRType == '')
                            ? Container()
                            : Container(
                                margin: EdgeInsets.only(top: 20, bottom: 10),
                                child: Text(
                                  'Loại phiếu',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                        Container(
                          margin: (_selectedHRType == '')
                              ? EdgeInsets.only(top: 20)
                              : null,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: DefaultTheme.GREY_VIEW,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                              ),

                              BlocBuilder<MedInsTypeListBloc, MedInsTypeState>(
                                builder: (context, state) {
                                  if (state is MedInsTypeStateLoading) {
                                    return Container(
                                      width: 40,
                                      height: 40,
                                      child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Image.asset(
                                            'assets/images/loading.gif'),
                                      ),
                                    );
                                  }
                                  if (state is MedInsTypeStateFailure) {
                                    return Container(
                                      width: 30,
                                      child: Text('Lỗi'),
                                    );
                                  }
                                  if (state is MedInsTypeStateSuccess) {
                                    _listMedInsType = state.listMedInsType;
                                    return Container(
                                      width: MediaQuery.of(context).size.width -
                                          80,
                                      child: DropdownButton<
                                          MedicalInstructionTypeDTO>(
                                        items: _listMedInsType.map(
                                            (MedicalInstructionTypeDTO value) {
                                          return new DropdownMenuItem<
                                              MedicalInstructionTypeDTO>(
                                            value: value,
                                            child: new Text(value.name),
                                          );
                                        }).toList(),
                                        hint: Text(
                                          (_selectedHRType == '')
                                              ? 'Chọn loại phiếu'
                                              : '${_selectedHRType}',
                                          style: TextStyle(
                                            color: DefaultTheme.BLUE_REFERENCE,
                                            // fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        icon: SizedBox(
                                          width: 15,
                                          height: 15,
                                          child: Image.asset(
                                              'assets/images/ic-dropdown.png'),
                                        ),
                                        underline: Container(
                                          width: 0,
                                        ),
                                        isExpanded: true,
                                        onChanged: (_) {
                                          setState(() {
                                            titleCompare = null;
                                            // _imgString = '';
                                            _imgFile = null;
                                            listImage = [];
                                            // listImage64Bit = [];
                                            _dianoseController.text = '';
                                            _medInsTypeId =
                                                _.medicalInstructionTypeId;
                                            _selectedHRType = _.name;
                                            selectType = _;
                                            print('${_selectedHRType}');
                                          });
                                        },
                                      ),
                                    );
                                    //
                                  }
                                  return Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Center(child: Text('Lỗi')));
                                },
                              ),

                              //
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                              )
                            ],
                          ),
                        ),
                        _selectBoxDissease(),

                        ///

                        // InkWell(
                        //   onTap: () async {
                        //     DateTime curentDateNow = new DateTime.now();
                        //     DateTime newDateTime = await showRoundedDatePicker(
                        //         context: context,
                        //         initialDate: DateTime(DateTime.now().year),
                        //         firstDate: DateTime(DateTime.now().year),
                        //         lastDate: DateTime(DateTime.now().year),
                        //         borderRadius: 16,
                        //         theme: ThemeData.dark());
                        //     if (newDateTime != null) {
                        //       // setState(() => widget.birthday = newDateTime);
                        //       // widget.dateOfBirth = newDateTime.toString();
                        //       print(newDateTime.toString());
                        //       setState(() {
                        //         dateCreate = newDateTime.toString();
                        //       });
                        //     }
                        //   },
                        //   child: Container(
                        //     margin: EdgeInsets.only(bottom: 10),
                        //     padding: EdgeInsets.only(
                        //         left: 10, right: 20, bottom: 10, top: 10),
                        //     decoration: BoxDecoration(
                        //       color: DefaultTheme.GREY_VIEW,
                        //       borderRadius: BorderRadius.circular(5),
                        //     ),
                        //     child: Row(
                        //       children: [
                        //         SizedBox(
                        //           width: 20,
                        //           height: 20,
                        //           child: Image.asset(
                        //               'assets/images/ic-calendar.png'),
                        //         ),
                        //         Padding(
                        //           padding: EdgeInsets.only(left: 20),
                        //         ),
                        //         Text(
                        //             (dateCreate == null)
                        //                 ? 'Ngày khám'
                        //                 : '${_dateValidator.convertDateCreate(dateCreate, 'dd/MM/yyyy', 'yyyy-MM-dd')}',
                        //             style: TextStyle(color: DefaultTheme.BLACK))
                        //       ],
                        //     ),
                        //   ),
                        // ),

                        ///

                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                        ),
                        (_selectedHRType == '')
                            ? Container()
                            : Container(
                                padding: EdgeInsets.only(bottom: 10, top: 15),
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    Text(
                                      'Hình ảnh đính kèm',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        (listImage.length <= 0) ? Container() : checktitle(),
                        (_selectedHRType == '')
                            ? Container()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: DefaultTheme.TRANSPARENT,
                                        border: Border.all(
                                          color: DefaultTheme.GREY_TOP_TAB_BAR,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                          child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: Image.asset(
                                            'assets/images/ic-create-dark.png'),
                                      )),
                                    ),
                                    onTap: () async {
                                      if (_selectedHRType != '') {
                                        _showNewPicker();

                                        //  _showPicker(context);
                                      } else {
                                        setState(() {
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  child: BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                        sigmaX: 25, sigmaY: 25),
                                                    child: Container(
                                                      width: 200,
                                                      height: 200,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: DefaultTheme
                                                              .WHITE
                                                              .withOpacity(
                                                                  0.8)),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            width: 100,
                                                            height: 100,
                                                            child: Image.asset(
                                                                'assets/images/ic-failed.png'),
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              'Hãy chọn loại phiếu trước',
                                                              style: TextStyle(
                                                                  color: DefaultTheme
                                                                      .GREY_TEXT,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .none),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                          Future.delayed(
                                              const Duration(seconds: 2), () {
                                            Navigator.of(context).pop();
                                          });
                                        });
                                      }
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                  ),
                                  (titleCompare != null)
                                      ? Text(
                                          '${f.format(titleCompare * 100)} %')
                                      : Container(),
                                ],
                              ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                        ),
                        (listImage.length <= 0)
                            ? Container()
                            : Container(
                                width: MediaQuery.of(context).size.width - 10,
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3),
                                  itemCount: listImage.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Stack(
                                        children: [
                                          Container(
                                            // borderRadius:
                                            //     BorderRadius.circular(10),
                                            child: SizedBox(
                                              width: 120,
                                              height: 120,
                                              child: Image.file(
                                                File(listImage[index]),
                                                fit: BoxFit.fill,
                                              ),
                                              // child: ImageUltility
                                              //     .imageFromBase64String(
                                              //         listImage64Bit[index])
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  listImage.removeAt(index);
                                                  // listImage64Bit
                                                  //     .removeAt(index);

                                                  if (listImage.length == 0) {
                                                    titleCompare = null;
                                                    _dianoseController.text =
                                                        strDiseaseDraft;
                                                  }
                                                });
                                              },
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                child: Image.asset(
                                                    'assets/images/ic-close.png'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),

                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Column(
                            children: [
                              Text('Kết luận'),
                              Container(
                                height: 200,
                                child: TextFieldHDr(
                                  controller: _dianoseController,
                                  placeHolder: 'Nhập tên bệnh lý',
                                  style: TFStyle.TEXT_AREA,
                                  keyboardAction: TextInputAction.done,
                                  onChange: (value) {
                                    setState(() {
                                      strDiseaseDraft = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding:
                              EdgeInsets.only(bottom: 5, left: 20, top: 10),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          height: 80,
                          child: TextFieldHDr(
                              placeHolder: 'Mô tả thêm các vấn đề khác',
                              style: TFStyle.TEXT_AREA,
                              keyboardAction: TextInputAction.done,
                              onChange: (text) {
                                setState(() {
                                  _note = text;
                                });
                              }),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 40),
                        ),

                        ///
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // (_dianoseController.text == '' ||
            //         listImage.length <= 0 ||
            //         (_diseaseIds.length <= 0 &&
            //             selectType.status.contains('SCOPE')))
            //     ? Container()
            //     :
            Positioned(
              child: Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: ButtonHDr(
                  width: MediaQuery.of(context).size.width - 40,
                  style: BtnStyle.BUTTON_BLACK,
                  label: 'Thêm',
                  onTap: () async {
                    print('---disease Ids when submit: $_diseaseIds');
                    if (selectType == null) {
                      alertError('Hãy chọn loại bệnh lý');
                    } else if (listImage.length <= 0
                        //  ||
                        //     listImage64Bit.length <= 0
                        ) {
                      alertError('Hãy thêm hình ảnh của y lệnh');
                    }
                    // else if (_dianoseController.text == '' ||
                    //     _dianoseController.text.isEmpty ||
                    //     _dianoseController.text == null) {
                    //   alertError('Vui lòng điền thêm chẩn đoán bệnh');
                    // }
                    else if (_diseaseIds.length <= 0 &&
                        selectType.status.contains('SCOPE')) {
                      alertError('Vui lòng chọn thêm triệu chứng của bệnh');
                    } else if (_patientId != 0) {
                      MedicalInstructionDTO medInsDTO;

                      if (selectType.status.contains('SCOPE')) {
                        if (
                            // _diseaseIds.length == listDisease.length ||
                            _diseaseIds.length <= 0) {
                          medInsDTO = MedicalInstructionDTO(
                            medicalInstructionTypeId: _medInsTypeId,
                            healthRecordId: _hrId,
                            patientId: _patientId,
                            description: _note,
                            diagnose: _dianoseController.text,
                            diseaseIds: null,
                            imageFile: listImage,
                          );
                        } else {
                          medInsDTO = MedicalInstructionDTO(
                            medicalInstructionTypeId: _medInsTypeId,
                            healthRecordId: _hrId,
                            patientId: _patientId,
                            description: _note,
                            diagnose: _dianoseController.text,
                            diseaseIds: _diseaseIds,
                            imageFile: listImage,
                          );
                        }
                      } else {
                        medInsDTO = MedicalInstructionDTO(
                          medicalInstructionTypeId: _medInsTypeId,
                          healthRecordId: _hrId,
                          patientId: _patientId,
                          description: _note,
                          diagnose: _dianoseController.text,
                          diseaseIds: null,
                          imageFile: listImage,
                        );
                      }

                      setState(() {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                                  child: Container(
                                    width: 300,
                                    height: 300,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: DefaultTheme.WHITE
                                            .withOpacity(0.8)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          height: 200,
                                          child: Image.asset(
                                              'assets/images/loading.gif'),
                                        ),
                                        Text(
                                          'Vui lòng chờ trong giây lát chúng tôi đang tạo y lệnh cho bạn',
                                          style: TextStyle(
                                              color: DefaultTheme.GREY_TEXT,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              decoration: TextDecoration.none),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      });

                      if (titleCompare < percenntCompare) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Text(
                                "Cảnh báo",
                                style: TextStyle(
                                    color: DefaultTheme.RED_TEXT, fontSize: 18),
                              ),
                              content: new Text(
                                  "Bạn đã chắc chắn thông tin bạn thêm vào là chính xác"),
                              actions: <Widget>[
                                new FlatButton(
                                  child: new Text("Không"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                ),
                                new FlatButton(
                                  child: new Text("Đúng"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _createMedIns(medInsDTO);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        _createMedIns(medInsDTO);
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _createMedIns(medInsDTO) async {
    await _medicalInstructionRepository
        .createMedicalInstruction(medInsDTO)
        .then((res) {
      Navigator.of(context).pop();
      setState(() {
        if (res) {
          // showDialog(
          //   barrierDismissible: false,
          //   context: context,
          //   builder: (BuildContext context) {
          //     return Center(
          //       child: ClipRRect(
          //         borderRadius: BorderRadius.all(Radius.circular(5)),
          //         child: BackdropFilter(
          //           filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          //           child: Container(
          //             width: 200,
          //             height: 200,
          //             decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(10),
          //                 color: DefaultTheme.WHITE.withOpacity(0.8)),
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               crossAxisAlignment: CrossAxisAlignment.center,
          //               children: [
          //                 SizedBox(
          //                   width: 100,
          //                   height: 100,
          //                   child: Image.asset('assets/images/ic-checked.png'),
          //                 ),
          //                 Text(
          //                   'Tạo thành công',
          //                   style: TextStyle(
          //                       color: DefaultTheme.GREY_TEXT,
          //                       fontSize: 15,
          //                       fontWeight: FontWeight.w400,
          //                       decoration: TextDecoration.none),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     );
          //   },
          // );
          // Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
          // Navigator.of(context).pop();
          // });
        } else {
          alertError('Không thể tạo bệnh án, vui lòng tạo lại');
        }
      });
    });

    // Future.delayed(
    //   Duration(seconds: 3),
    //   () {
    //     _medicalInstructionHelper.getMedicalInsCreate().then(
    //       (value) {

    //       },
    //     );
    //   },
    // );
  }

  alertError(String title) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: DefaultTheme.WHITE.withOpacity(0.8)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset('assets/images/ic-failed.png'),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        title,
                        style: TextStyle(
                            color: DefaultTheme.GREY_TEXT,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  _selectBoxDissease() {
    if (selectType == null) {
      return Container();
    } else if (selectType.status.contains('SCOPE')) {
      return Container(
        width: MediaQuery.of(context).size.width,
        // padding: EdgeInsets.only(left: 20, right: 20),

        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
        child: Column(
          children: [
            (listDiseaseSelected.length == 0 || listDiseaseSelected == null)
                ? Container()
                : Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 20, bottom: 5),
                    child: Text('Bệnh lý',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
            (listDiseaseSelected.length == 0 || listDiseaseSelected == null)
                ? Container()
                : Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                        'Chọn bệnh lý chính xác được ghi trên phiếu y lệnh.',
                        style: TextStyle(
                            color: DefaultTheme.GREY_TEXT,
                            fontSize: 15,
                            fontWeight: FontWeight.w400)),
                  ),
            _buildSelectedDisease(),
            InkWell(
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            width: 1, color: DefaultTheme.GREY_TOP_TAB_BAR)),
                    height: 45,
                    width: MediaQuery.of(context).size.width - 40,
                    margin: EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              Image.asset('assets/images/ic-add-disease.png'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                        ),
                        Text(
                          'Thêm bệnh lý',
                          style: TextStyle(
                            color: DefaultTheme.BLACK,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: () {
                _getListDisease();
              },
            ),

            //
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  _buildSelectedDisease() {
    return (_diseaseViews.length == 0 || _diseaseViews == null)
        ? Container()
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            //
            itemCount: _diseaseViews.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 5),
                padding:
                    EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 5),
                decoration: BoxDecoration(
                  color: DefaultTheme.GREY_VIEW,
                  borderRadius: BorderRadius.circular(6),
                ),
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          child: Text('${_diseaseViews[index].split(':')[0]}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: DefaultTheme.BLUE_DARK,
                                fontSize: 15,
                              )),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 130,
                          child: Text('${_diseaseViews[index].split(':')[1]}',
                              style: TextStyle(fontSize: 15)),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            // _listLv3IdSelected.removeAt(index);
                            // _listLv3Selected.removeAt(index);

                            _diseaseIds.removeWhere((item) =>
                                item == _diseaseViews[index].split(':')[0]);
                            _listLv3Selected.removeWhere((item) =>
                                item.diseaseLevelThreeId ==
                                _diseaseViews[index].split(':')[0]);
                            _diseaseViews.removeAt(index);
                          });
                        },
                        child: SizedBox(
                          width: 15,
                          height: 15,
                          child: Image.asset('assets/images/ic-close.png'),
                        ),
                      ),
                    )
                  ],
                ),
              );
            });
  }

  _getListDisease() {
    int _tabIndex = 0;
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: DefaultTheme.TRANSPARENT,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.95,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.05),
                    color: DefaultTheme.TRANSPARENT,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.9,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15)),
                        color: DefaultTheme.GREY_VIEW,
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 30),
                            ),
                            Expanded(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Danh sách bệnh lý',
                                        style: TextStyle(
                                            color: DefaultTheme.BLACK,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 20),
                                          height: 35,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: [
                                              //
                                              InkWell(
                                                onTap: () {
                                                  setModalState(() {
                                                    _tabIndex = 0;
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                    left: 15,
                                                    right: 15,
                                                  ),
                                                  decoration: (_tabIndex == 0)
                                                      ? BoxDecoration(
                                                          color: DefaultTheme
                                                              .GREY_TOP_TAB_BAR,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                        )
                                                      : BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color: DefaultTheme
                                                                  .GREY_TOP_TAB_BAR),
                                                          color: DefaultTheme
                                                              .WHITE,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                        ),
                                                  child: Center(
                                                    child: Text('Trong hồ sơ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                (_tabIndex == 0)
                                                                    ? FontWeight
                                                                        .w500
                                                                    : FontWeight
                                                                        .normal,
                                                            color: DefaultTheme
                                                                .BLACK,
                                                            fontSize:
                                                                (_tabIndex == 0)
                                                                    ? 17
                                                                    : 16),
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10)),
                                              InkWell(
                                                onTap: () {
                                                  setModalState(() {
                                                    _tabIndex = 1;
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                    left: 15,
                                                    right: 15,
                                                  ),
                                                  decoration: (_tabIndex == 1)
                                                      ? BoxDecoration(
                                                          color: DefaultTheme
                                                              .GREY_TOP_TAB_BAR,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                        )
                                                      : BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color: DefaultTheme
                                                                  .GREY_TOP_TAB_BAR),
                                                          color: DefaultTheme
                                                              .WHITE,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                        ),
                                                  child: Center(
                                                    child: Text('Khác',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                (_tabIndex == 1)
                                                                    ? FontWeight
                                                                        .w500
                                                                    : FontWeight
                                                                        .normal,
                                                            color: DefaultTheme
                                                                .BLACK,
                                                            fontSize:
                                                                (_tabIndex == 1)
                                                                    ? 17
                                                                    : 16),
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                      Expanded(
                                          child: (_tabIndex == 0)
                                              ? ListView.builder(
                                                  itemCount: listDisease.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    bool checkTemp = false;
                                                    var e = listDisease[index];

                                                    if (_diseaseIds.contains(
                                                        e.diseaseId)) {
                                                      checkTemp = true;
                                                    }
                                                    return ListTile(
                                                      title: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width -
                                                                    100,
                                                                child: Text(
                                                                  '${e.diseaseId} - ${e.diseaseName}',
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 3,
                                                                  style: TextStyle(
                                                                      color: DefaultTheme
                                                                          .BLUE_REFERENCE,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                child:
                                                                    Container(
                                                                  width: 20,
                                                                  height: 20,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                                  child:
                                                                      Checkbox(
                                                                    materialTapTargetSize:
                                                                        MaterialTapTargetSize
                                                                            .padded,
                                                                    checkColor:
                                                                        DefaultTheme
                                                                            .GRADIENT_1,
                                                                    activeColor:
                                                                        DefaultTheme
                                                                            .GREY_VIEW,
                                                                    hoverColor:
                                                                        DefaultTheme
                                                                            .GREY_VIEW,
                                                                    value:
                                                                        checkTemp,
                                                                    onChanged:
                                                                        (_) {
                                                                      setModalState(
                                                                        () {
                                                                          checkTemp =
                                                                              !checkTemp;

                                                                          setState(
                                                                            () {
                                                                              if (checkTemp) {
                                                                                _diseaseIds.removeWhere((item) => item == e.diseaseId);
                                                                                _diseaseViews.removeWhere((item) => item.split(':')[0] == e.diseaseId);
                                                                                // _diseaseIds
                                                                                //     .clear();
                                                                                _diseaseIds.add(e.diseaseId);
                                                                                _diseaseViews.add(e.diseaseId + ':' + e.diseaseName);

                                                                                // listDiseaseSelected.removeWhere((item) =>
                                                                                //     item.diseaseId ==
                                                                                //     e.diseaseId);
                                                                                //
                                                                                // listDiseaseSelected
                                                                                //     .clear();
                                                                                listDiseaseSelected.add(e);
                                                                              } else {
                                                                                _diseaseIds.removeWhere((item) => item == e.diseaseId);
                                                                                _diseaseViews.removeWhere((item) => item.split(':')[0] == e.diseaseId);
                                                                                listDiseaseSelected.removeWhere((item) => item.diseaseId == e.diseaseId);
                                                                              }
                                                                            },
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                )
                                              : Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.5,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: BlocBuilder<
                                                          DiseaseListBloc,
                                                          DiseaseListState>(
                                                      builder:
                                                          (context, state) {
                                                    if (state
                                                        is DiseaseListStateLoading) {
                                                      return Container(
                                                        margin: EdgeInsets.only(
                                                            left: 20,
                                                            right: 20),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            color: DefaultTheme
                                                                .GREY_BUTTON),
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
                                                    if (state
                                                        is DiseaseListStateFailure) {
                                                      return Container(
                                                        margin: EdgeInsets.only(
                                                            left: 20,
                                                            right: 20,
                                                            bottom: 10,
                                                            top: 10),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color: DefaultTheme
                                                                .GREY_BUTTON),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 10,
                                                                  bottom: 10,
                                                                  left: 20,
                                                                  right: 20),
                                                          child: Text(
                                                              'Không có dữ liệu',
                                                              style: TextStyle(
                                                                color: DefaultTheme
                                                                    .GREY_TEXT,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              )),
                                                        ),
                                                      );
                                                    }
                                                    if (state
                                                        is DiseaseListStateSuccess) {
                                                      // if (state.listDisease != null) {
                                                      //   _listDisease = [];
                                                      //   for (var item in state.listDisease) {
                                                      //     String alpha = item.diseaseId[0];
                                                      //     String strDisID = '';
                                                      //     var listDiseasesID = item.diseaseId.split('-');
                                                      //     int num1 = int.parse(listDiseasesID[0].substring(1));
                                                      //     int num2 = int.parse(listDiseasesID[1].substring(1));
                                                      //     for (var num = num1; num <= num2; num++) {
                                                      //       strDisID += '$alpha$num';
                                                      //     }
                                                      //     item.strDiseaseID = strDisID;
                                                      //     _listDisease.add(item);
                                                      //   }

                                                      //   // _listDisease = state.listDisease;
                                                      // }
                                                      // return _selectBoxInsOtherDissease();
                                                      if (state.listDisease !=
                                                          null) {
                                                        _listDiseaseForHeart =
                                                            state.listDisease;
                                                      }
                                                      return Column(
                                                        children: [
                                                          _searchDiseases(
                                                              setModalState),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 10),
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.55,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: ListView(
                                                              // shrinkWrap: true,
                                                              // physics:
                                                              //     NeverScrollableScrollPhysics(),
                                                              children: (_listDiseaseForHeartForSearch
                                                                              .length >
                                                                          0
                                                                      ? _listDiseaseForHeartForSearch
                                                                      : _listDiseaseForHeart)
                                                                  .asMap()
                                                                  .map(
                                                                    (key, value) =>
                                                                        MapEntry(
                                                                      key,
                                                                      Container(
                                                                        child: showItem(
                                                                            context,
                                                                            value,
                                                                            setModalState),
                                                                      ),
                                                                    ),
                                                                  )
                                                                  .values
                                                                  .toList(),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                    if (state
                                                        is DiseaseHeartListStateSuccess) {
                                                      if (state
                                                              .listDiseaseContract !=
                                                          null) {
                                                        _listDiseaseForHeart = state
                                                            .listDiseaseContract;
                                                      }
                                                      return Column(
                                                        children: [
                                                          _searchDiseases(
                                                              setModalState),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 10),
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.55,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: ListView(
                                                              shrinkWrap: true,
                                                              // physics:
                                                              //     NeverScrollableScrollPhysics(),
                                                              children: (_listDiseaseForHeartForSearch
                                                                              .length >
                                                                          0
                                                                      ? _listDiseaseForHeartForSearch
                                                                      : _listDiseaseForHeart)
                                                                  .asMap()
                                                                  .map(
                                                                    (key, value) =>
                                                                        MapEntry(
                                                                      key,
                                                                      Container(
                                                                        child: showItem(
                                                                            context,
                                                                            value,
                                                                            setModalState),
                                                                      ),
                                                                    ),
                                                                  )
                                                                  .values
                                                                  .toList(),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                    return Container();
                                                  }),
                                                )),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.only(bottom: 30),
                                        child: ButtonHDr(
                                          style: BtnStyle.BUTTON_BLACK,
                                          label: 'Xong',
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                  Positioned(
                    top: 23,
                    left: MediaQuery.of(context).size.width * 0.3,
                    height: 5,
                    child: Container(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.3),
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 15,
                      decoration: BoxDecoration(
                        color: DefaultTheme.WHITE.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget showItem(context, diseaseContractDTO, StateSetter setModalState) {
    return ExpandableGroup(
      collapsedIcon: SizedBox(
          width: 20,
          height: 20,
          child: Image.asset('assets/images/ic-navigator.png')),
      expandedIcon: SizedBox(
          width: 20,
          height: 20,
          child: Image.asset('assets/images/ic-down.png')),
      isExpanded: true,
      header: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Image.asset('assets/images/ic-add-disease.png'),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 122,
            child: Text(
              '${diseaseContractDTO.diseaseLevelTwoId}: ${diseaseContractDTO.diseaseLevelTwoName}',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
      items: _buildItems(
          context, diseaseContractDTO.diseaseLevelThrees, setModalState),
    );
  }

  List<ListTile> _buildItems(BuildContext context,
      List<DiseaseLeverThrees> items, StateSetter setModalState) {
    return items.map((e) {
      bool checkTemp = false;
      if (_diseaseIds.contains(e.diseaseLevelThreeId)) {
        checkTemp = true;
      }

      return ListTile(
        title: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width - 100,
                    child: Text(
                      '${e.diseaseLevelThreeId} - ${e.diseaseLevelThreeName}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: TextStyle(
                          color: DefaultTheme.BLUE_REFERENCE,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Spacer(),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        checkColor: DefaultTheme.GRADIENT_1,
                        activeColor: DefaultTheme.GREY_VIEW,
                        hoverColor: DefaultTheme.GREY_VIEW,
                        value: checkTemp,
                        onChanged: (_) {
                          bool temp = false;
                          if (_diseaseIds.contains(e.diseaseLevelThreeId)) {
                            temp = true;
                          }

                          setModalState(() {
                            setState(() {
                              if (!temp) {
                                _diseaseIds.add(e.diseaseLevelThreeId);
                                _diseaseViews.add(e.diseaseLevelThreeId +
                                    ':' +
                                    e.diseaseLevelThreeName);
                                _listLv3Selected.add(e);
                              } else {
                                _diseaseIds.removeWhere(
                                    (item) => item == e.diseaseLevelThreeId);
                                _listLv3Selected.removeWhere((item) =>
                                    item.diseaseLevelThreeId ==
                                    e.diseaseLevelThreeId);
                                _diseaseViews.removeWhere((item) =>
                                    item.split(':')[0] ==
                                    e.diseaseLevelThreeId);
                              }
                            });
                          });

                          print(_diseaseIds);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          onTap: () {
            bool temp = false;
            if (_diseaseIds.contains(e.diseaseLevelThreeId)) {
              temp = true;
            }

            setModalState(() {
              setState(() {
                if (!temp) {
                  _diseaseIds.add(e.diseaseLevelThreeId);
                  _listLv3Selected.add(e);
                } else {
                  _diseaseIds
                      .removeWhere((item) => item == e.diseaseLevelThreeId);
                  _listLv3Selected.removeWhere((item) =>
                      item.diseaseLevelThreeId == e.diseaseLevelThreeId);
                }
              });
            });

            print(_diseaseIds);
          },
        ),
      );
    }).toList();
  }

  List<DiseaseContractDTO> updateSearchQueryForInsurance(
      String val, List<DiseaseContractDTO> allItems) {
    if (val != null && val.trim().isNotEmpty) {
      List<DiseaseContractDTO> filteredItems = [];
      for (var item in allItems) {
        for (var el in item.diseaseLevelThrees) {
          if (el.strDiseaseID.toLowerCase().contains(val.toLowerCase()) &&
              !filteredItems.contains(item)) {
            filteredItems.add(item);
          }
        }
        // if (item.diseaseLevelTwoId
        //         .toLowerCase()
        //         .contains(val[0].toLowerCase()) &&
        //     !filteredItems.contains(item)) {
        //   var listDiseases = item.diseaseLevelTwoId.split('-');
        //   if (listDiseases.length > 1) {
        //     int num1 = int.parse(listDiseases[0].substring(1));
        //     int num2 = int.parse(listDiseases[1].substring(1));
        //     if (val.substring(1) != '') {
        //       if (num1 <= int.parse(val.substring(1)) &&
        //           int.parse(val.substring(1)) <= num2) {
        //         filteredItems.add(item);
        //       }
        //     } else {
        //       if (item.diseaseLevelTwoId
        //           .toLowerCase()
        //           .contains(val.toLowerCase())) {
        //         filteredItems.add(item);
        //       }
        //     }
        //   } else {
        //     if (item.diseaseLevelTwoId
        //         .toLowerCase()
        //         .contains(val.toLowerCase())) {
        //       filteredItems.add(item);
        //     }
        //   }
        // } else {
        //   for (var itemLV3 in item.diseaseLevelThrees) {
        //     if (itemLV3.diseaseLevelThreeName
        //             .toLowerCase()
        //             .contains(val.toLowerCase()) &&
        //         !filteredItems.contains(item)) {
        //       filteredItems.add(item);
        //     }
        //   }
        // }
      }
      return filteredItems;
    } else {
      return allItems;
    }
  }

  Widget _searchDiseases(StateSetter setModalState) {
    return Container(
      padding: EdgeInsets.only(left: 10, top: 10),
      child: TextField(
        controller: _diseaseIDController,
        autofocus: false,
        decoration: InputDecoration(
          hintText: "Tìm kiếm mã bệnh",
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
        onChanged: (val) {
          // const duration = Duration(
          //     milliseconds:
          //         1000); // set the duration that you want call search() after that.
          // if (searchOnStoppedTyping != null) {
          //   setModalState(() => searchOnStoppedTyping.cancel()); // clear timer
          // }
          // setModalState(() =>
          //     searchOnStoppedTyping = new Timer(duration, () => print(val)));

          setModalState(() {
            setState(() {
              _listDiseaseForHeartForSearch =
                  updateSearchQueryForInsurance(val, _listDiseaseForHeart);
            });
          });
        },
      ),
    );
  }

  checktitle() {
    if (titleCompare != null) {
      if (titleCompare > percenntCompare) {
        return Container();
      } else {
        return Container(
          child: Text(
            'Hãy chắc chắn rằng đây là $_selectedHRType',
            style: TextStyle(
              color: DefaultTheme.RED_TEXT,
              fontSize: 14,
            ),
          ),
        );
      }
    } else {
      return Container(
        child: Text(
          '',
          style: TextStyle(
            color: DefaultTheme.RED_TEXT,
            fontSize: 14,
          ),
        ),
      );
    }
  }

//new show camera/gallery
  _showNewPicker() {
    showGeneralDialog(
        barrierColor: DefaultTheme.BLACK.withOpacity(0.6),
        transitionBuilder: (context, a1, a2, widget) {
          return Material(
            color: DefaultTheme.TRANSPARENT,
            child: Transform.scale(
              scale: a1.value,
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      color: DefaultTheme.WHITE.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(10)),
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //
                      Padding(
                        padding: EdgeInsets.only(bottom: 30),
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              //
                              Text(
                                'Thêm hình ảnh',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child:
                                      Image.asset('assets/images/ic-close.png'),
                                ),
                              ),
                            ],
                          )),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.1 - 5,
                            ),
                          ),
                          InkWell(
                              child: Container(
                                  height: 180,
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: DefaultTheme.GREY_TOP_TAB_BAR,
                                          width: 1),
                                      color: DefaultTheme.WHITE,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: Image.asset(
                                            'assets/images/ic-add-img.png'),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                      ),
                                      Text('Thư viện'),
                                    ],
                                  )),
                              onTap: () {
                                _onImageButtonPressed(ImageSource.gallery,
                                    context: context);
                                Navigator.of(context).pop();
                              }),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 10,
                            ),
                          ),
                          InkWell(
                              child: Container(
                                  height: 180,
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: DefaultTheme.GREY_TOP_TAB_BAR,
                                          width: 1),
                                      color: DefaultTheme.WHITE,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: Image.asset(
                                            'assets/images/ic-open-camera.png'),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                      ),
                                      Text('Máy ảnh'),
                                    ],
                                  )),
                              onTap: () {
                                _onImageButtonPressed(ImageSource.camera,
                                    context: context);
                                Navigator.of(context).pop();
                              }),
                          Padding(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.1 - 5,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 30),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }

//chọn loại để chọn hình: camera hoặc thư viện ảnh
  _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Thư viện ảnh'),
                      onTap: () {
                        _onImageButtonPressed(ImageSource.gallery,
                            context: context);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _onImageButtonPressed(ImageSource.camera,
                          context: context);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await picker.getImage(
        source: source,
      );

      bool load = false;
      if (pickedFile != null) {
        // for (var item in listImage) {
        //   goo(item, pickedFile.path);
        // }

        String fileName = pickedFile.path.split("/").last;
        print('fileName: $fileName');
        //
        //
        await _medicalInstructionRepository
            .checkImageExist(
                pickedFile.path, _hrId, selectType.medicalInstructionTypeId)
            .then((compare) {
          if (compare) {
            setState(() {
              _imgFile = pickedFile;
              if (!listImage.contains(fileName)) {
                listImage.add(pickedFile.path);
                // listImage64Bit.add(ImageUltility.base64String(
                //     File(pickedFile.path).readAsBytesSync()));
                load = true;
              }
            });
            if (titleCompare == null) {
              deteckImage();
            } else {
              if (titleCompare >= percenntCompare) {
                print('titleCompare >= percenntCompare');
              } else {
                if (_imgFile.path != null && _imgFile.path != '' && load) {
                  print('titleCompare < percenntCompare');
                  deteckImage();
                }
              }
            }
          } else {
            alertError(
                'Đã tồn tại hình này trong loại y lệnh này, vui lòng chọn hình ảnh khác');
          }
        });
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('_onImageButtonPressed: $e');
    }
  }

  deteckImage() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: DefaultTheme.WHITE.withOpacity(0.8)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.asset('assets/images/loading.gif'),
                    ),
                    Text(
                      'Vui lòng chờ chúng tôi kiểm tra xem hình này có trùng khớp với loại phiếu bạn đã chọn hay không',
                      style: TextStyle(
                          color: DefaultTheme.GREY_TEXT,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    await _medicalInstructionRepository
        .getTextFromImage(_imgFile.path, _selectedHRType)
        .then((value) {
      Navigator.of(context).pop();
      if (value != null) {
        setState(() {
          _dianoseController.text = _dianoseController.text + value.symptom;
          if (titleCompare == null) {
            titleCompare = value.titleCompare;
          } else if (titleCompare < value.titleCompare) {
            titleCompare = value.titleCompare;
          }
        });
        if (titleCompare < percenntCompare) {
          setState(() {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: new Text("Cảnh báo"),
                  content: new Text(
                      "Hãy chắc chắn rằng đây là phiếu ${_selectedHRType}"),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("Bỏ"),
                      onPressed: () {
                        setState(() {
                          titleCompare = null;
                          // _imgString = '';
                          _imgFile = null;
                          _dianoseController.text = strDiseaseDraft;

                          listImage.removeLast();
                          // listImage64Bit.removeLast();
                          if (listImage.length == 0) {
                            titleCompare = null;
                            _dianoseController.text = strDiseaseDraft;
                          }
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                    new FlatButton(
                      child: new Text("Đồng ý"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          });
        }
      }
    });
  }

  _getPatientId() async {
    await _authenticateHelper.getPatientId().then((value) {
      setState(() {
        _patientId = value;
      });
    });
  }

  getHRId() async {
    _medInsTypeListBloc.add(MedInsTypeEventGetList(status: 'active'));
    await _healthRecordHelper.getHRId().then(
      (value) {
        print('HR ID IN SHARED_PR ${value}');
        setState(() {
          _hrId = value;
        });
      },
    );
  }

  // void goo(String firstImg, String secondImg) {
  //   var firstImageFromMemory = imgs.decodeImage(
  //     File(
  //       firstImg,
  //     ).readAsBytesSync(),
  //   );
  //   var secondImageFromMemory = imgs.decodeImage(
  //     File(
  //       secondImg,
  //     ).readAsBytesSync(),
  //   );

  //   try {
  //     var diff = DiffImage.compareFromMemory(
  //         firstImageFromMemory, secondImageFromMemory);
  //     print('The difference between images is: ${diff.diffValue} %');
  //   } catch (e) {
  //     print('goo error: $e');
  //   }
  // }
}
