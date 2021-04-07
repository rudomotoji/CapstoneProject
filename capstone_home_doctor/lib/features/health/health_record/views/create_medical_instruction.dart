import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/utils/img_util.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/med_ins_create_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/med_ins_type_list_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/events/med_ins_create_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/events/med_ins_type_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/medical_instruction_repository.dart';
import 'package:capstone_home_doctor/features/health/health_record/states/med_ins_type_list_state.dart';
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
  PickedFile _imgFile;
  String _note = '';
  double titleCompare;
  String _imgString = '';
  String nowDate = '${DateTime.now()}';
  List<MedicalInstructionTypeDTO> _listMedInsType = [];
  double percenntCompare = 100;
  var f = NumberFormat("###.0#", "en_US");

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
                                            _imgString = '';
                                            _imgFile = null;
                                            _dianoseController.text = '';
                                            _medInsTypeId =
                                                _.medicalInstructionTypeId;
                                            _selectedHRType = _.name;
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
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        //     Padding(
                        //       padding: EdgeInsets.only(top: 40, left: 0),
                        //       child: Text(
                        //         'Chọn loại phiếu',
                        //         style: TextStyle(
                        //           color: DefaultTheme.BLACK,
                        //           fontSize: 18,
                        //         ),
                        //       ),
                        //     ),
                        //     Spacer(),

                        //   ],
                        // ),
                        (_selectedHRType == '')
                            ? Container()
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 10, left: 0),
                                    child: Text(
                                      '${_selectedHRType}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Divider(
                            height: 0.1,
                            color: DefaultTheme.GREY_LIGHT,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Column(
                            children: [
                              Text('Chẩn đoán*'),
                              Container(
                                height: 200,
                                child: TextFieldHDr(
                                  controller: _dianoseController,
                                  placeHolder: 'Nhập tên bệnh lý',
                                  style: TFStyle.TEXT_AREA,
                                  keyboardAction: TextInputAction.done,
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
                        (_imgFile == null) ? Container() : checktitle(),
                        (titleCompare != null)
                            ? Text('${f.format(titleCompare * 100)} %')
                            : Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              child: Container(
                                width: (_imgString == '') ? 120 : 50,
                                height: (_imgString == '') ? 120 : 50,
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
                                    (_imgString == '')
                                        ? 'Chọn ảnh +'
                                        : 'Chọn lại',
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
                            (_imgString == '')
                                ? Container()
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                        width: 120,
                                        height: 120,
                                        child:
                                            ImageUltility.imageFromBase64String(
                                                _imgString)),
                                  ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 25),
                        ),
                        (_dianoseController.text == '' || _imgString == '')
                            ? Container()
                            : ButtonHDr(
                                width: MediaQuery.of(context).size.width - 40,
                                style: BtnStyle.BUTTON_BLACK,
                                label: 'Thêm',
                                onTap: () async {
                                  if (_patientId != 0) {
                                    MedicalInstructionDTO medInsDTO =
                                        MedicalInstructionDTO(
                                      medicalInstructionTypeId: _medInsTypeId,
                                      healthRecordId: _hrId,
                                      patientId: _patientId,
                                      description: _note,
                                      diagnose: _dianoseController.text,
                                      imageFile: _imgFile,
                                    );

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
                                                  width: 300,
                                                  height: 300,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: DefaultTheme.WHITE
                                                          .withOpacity(0.8)),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 200,
                                                        height: 200,
                                                        child: Image.asset(
                                                            'assets/images/loading.gif'),
                                                      ),
                                                      Text(
                                                        'Đang tạo...',
                                                        style: TextStyle(
                                                            color: DefaultTheme
                                                                .GREY_TEXT,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            decoration:
                                                                TextDecoration
                                                                    .none),
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
                                                  color: DefaultTheme.RED_TEXT,
                                                  fontSize: 18),
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
                        Padding(
                          padding: EdgeInsets.only(bottom: 25),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _createMedIns(medInsDTO) {
    _medInsCreateBloc.add(MedInsCreateEventSend(dto: medInsDTO));
    Future.delayed(
      Duration(seconds: 3),
      () {
        _medicalInstructionHelper.getMedicalInsCreate().then(
          (value) {
            Navigator.of(context).pop();
            setState(() {
              if (value) {
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
                                  child: Image.asset(
                                      'assets/images/ic-checked.png'),
                                ),
                                Text(
                                  'Tạo thành công',
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
                Future.delayed(const Duration(seconds: 2), () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                });
              } else {
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
                                  child: Image.asset(
                                      'assets/images/ic-failed.png'),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Không thể tạo bệnh án, vui lòng tạo lại',
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
            });
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
                      title: new Text('Photo Library'),
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
      if (pickedFile != null) {
        //
        setState(() {
          _imgFile = pickedFile;
          _imgString = ImageUltility.base64String(
              File(pickedFile.path).readAsBytesSync());
        });
        if (_imgFile.path != null || _imgFile.path != '') {
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
                            'Vui lòng chờ trong giây lát....',
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
                _dianoseController.text =
                    _dianoseController.text + value.symptom;
                if (titleCompare < value.titleCompare) {
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
                                _imgString = '';
                                _imgFile = null;
                                _dianoseController.text = '';
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
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('_onImageButtonPressed: $e');
    }
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
}
