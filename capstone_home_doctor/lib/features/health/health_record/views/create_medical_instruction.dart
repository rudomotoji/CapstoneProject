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

  //
  List<String> listImage = [];
  // List<String> listImage64Bit = [];

//triệu chứng bệnh đối với các bệnh scrope
  List<Disease> listDisease = [];
  List<Disease> listDiseaseSelected = [];
  List<String> _diseaseIds = [];
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

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _medInsCreateBloc = BlocProvider.of(context);
    // _medicalScanText = BlocProvider.of(context);
    _medInsTypeListBloc = BlocProvider.of(context);
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
              buttonHeaderType: ButtonHeaderType.NONE,
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
                        Container(
                          margin: EdgeInsets.only(top: 40),
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: DefaultTheme.GREY_VIEW),
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
                                            fontWeight: FontWeight.w500,
                                          ),
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
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Divider(
                            height: 0.1,
                            color: DefaultTheme.GREY_LIGHT,
                          ),
                        ),

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
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Column(
                            children: [
                              Text('Chẩn đoán(*)'),
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
                        Divider(
                          height: 0.1,
                          color: DefaultTheme.GREY_LIGHT,
                        ),
                        Divider(
                          height: 0.1,
                          color: DefaultTheme.GREY_LIGHT,
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
                          padding: EdgeInsets.only(bottom: 10),
                        ),
                        (listImage.length <= 0) ? Container() : checktitle(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              child: Container(
                                width: 100,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: DefaultTheme.TRANSPARENT,
                                  border: Border.all(
                                    color: DefaultTheme.GREY_TOP_TAB_BAR,
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    'Chọn ảnh +',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: DefaultTheme.BLUE_REFERENCE),
                                  ),
                                ),
                              ),
                              onTap: () async {
                                if (_selectedHRType != '') {
                                  _showPicker(context);
                                } else {
                                  setState(() {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Center(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                  sigmaX: 25, sigmaY: 25),
                                              child: Container(
                                                width: 200,
                                                height: 200,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: DefaultTheme.WHITE
                                                        .withOpacity(0.8)),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: 100,
                                                      height: 100,
                                                      child: Image.asset(
                                                          'assets/images/ic-failed.png'),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        'Hãy chọn loại phiếu trước',
                                                        style: TextStyle(
                                                            color: DefaultTheme
                                                                .GREY_TEXT,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            decoration:
                                                                TextDecoration
                                                                    .none),
                                                        textAlign:
                                                            TextAlign.center,
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
                                    Future.delayed(const Duration(seconds: 2),
                                        () {
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
                                ? Text('${f.format(titleCompare * 100)} %')
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
                          padding: EdgeInsets.only(bottom: 40),
                        ),
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
                    if (selectType == null) {
                      alertError('Hãy chọn loại bệnh lý');
                    } else if (listImage.length <= 0
                        //  ||
                        //     listImage64Bit.length <= 0
                        ) {
                      alertError('Hãy thêm hình ảnh của y lệnh');
                    } else if (_dianoseController.text == '' ||
                        _dianoseController.text.isEmpty ||
                        _dianoseController.text == null) {
                      alertError('Vui lòng điền thêm chẩn đoán bệnh');
                    } else if (_diseaseIds.length <= 0 &&
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
        padding: EdgeInsets.only(left: 20, right: 20),
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            color: DefaultTheme.GREY_VIEW,
            borderRadius: BorderRadius.circular(6)),
        child: Column(
          children: [
            InkWell(
              child: Row(
                children: [
                  Container(
                    height: 25,
                    width: MediaQuery.of(context).size.width - 90,
                    margin: EdgeInsets.only(top: 15, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Chọn bệnh lý (*)',
                          style: TextStyle(
                            color: DefaultTheme.BLACK,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: Image.asset('assets/images/ic-dropdown.png'),
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
            _buildInheritedChipDisplayForDisease()
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildInheritedChipDisplayForDisease() {
    final _itemsView = listDiseaseSelected
        .map((disease) => MultiSelectItem<Disease>(disease, disease.toString()))
        .toList();

    List<MultiSelectItem<Disease>> chipDisplayItems = [];
    chipDisplayItems = listDiseaseSelected
        .map((e) => _itemsView.firstWhere((element) => e == element.value,
            orElse: () => null))
        .toList();

    chipDisplayItems.removeWhere((element) => element == null);
    return MultiSelectChipDisplay<Disease>(
      items: chipDisplayItems,
      onTap: (item) {},
      chipColor: DefaultTheme.BLUE_REFERENCE,
      textStyle: TextStyle(
        color: DefaultTheme.BLACK,
      ),
    );
  }

  _getListDisease() {
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
                    height: MediaQuery.of(context).size.height * 0.6,
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
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      // Text(
                                      //   'Hãy chọn 1 bệnh lý trong danh sách này',
                                      //   style: TextStyle(
                                      //       color: DefaultTheme.BLACK,
                                      //       fontSize: 16,
                                      //       fontWeight: FontWeight.w600),
                                      // ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 20),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: listDisease.length,
                                          itemBuilder: (context, index) {
                                            bool checkTemp = false;
                                            var e = listDisease[index];

                                            if (_diseaseIds
                                                .contains(e.diseaseId)) {
                                              checkTemp = true;
                                            }
                                            return ListTile(
                                              title: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
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
                                                          overflow: TextOverflow
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
                                                                .circular(6),
                                                        child: Container(
                                                          width: 20,
                                                          height: 20,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child: Checkbox(
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
                                                            value: checkTemp,
                                                            onChanged: (_) {
                                                              setModalState(
                                                                () {
                                                                  checkTemp =
                                                                      !checkTemp;

                                                                  setState(
                                                                    () {
                                                                      if (checkTemp) {
                                                                        _diseaseIds.removeWhere((item) =>
                                                                            item ==
                                                                            e.diseaseId);

                                                                        // _diseaseIds
                                                                        //     .clear();
                                                                        _diseaseIds
                                                                            .add(e.diseaseId);

                                                                        // listDiseaseSelected.removeWhere((item) =>
                                                                        //     item.diseaseId ==
                                                                        //     e.diseaseId);
                                                                        //
                                                                        // listDiseaseSelected
                                                                        //     .clear();
                                                                        listDiseaseSelected
                                                                            .add(e);
                                                                      } else {
                                                                        _diseaseIds.removeWhere((item) =>
                                                                            item ==
                                                                            e.diseaseId);
                                                                        listDiseaseSelected.removeWhere((item) =>
                                                                            item.diseaseId ==
                                                                            e.diseaseId);
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
                                        ),
                                      ),
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
