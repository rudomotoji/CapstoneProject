import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:capstone_home_doctor/features/login/blocs/account_bloc.dart';
import 'package:capstone_home_doctor/features/login/events/account_event.dart';
import 'package:capstone_home_doctor/features/login/repositories/account_repository.dart';
import 'package:capstone_home_doctor/features/login/states/account_state.dart';
import 'package:capstone_home_doctor/models/account_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

final AuthenticateHelper _authenticateHelper = AuthenticateHelper();

class Login extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => Login());
  }

  @override
  State<StatefulWidget> createState() {
    return _Login();
  }
}

class _Login extends State<Login> with WidgetsBindingObserver {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  //
  AccountRepository accountRepository =
      AccountRepository(httpClient: http.Client());
  AccountBloc _accountBloc;
  //
  AccountDTO accountDTO;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _accountBloc = BlocProvider.of(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      backgroundColor: DefaultTheme.WHITE,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HeaderWidget(
              title: 'Đăng nhập',
              isMainView: true,
            ),
            Padding(padding: const EdgeInsets.only(top: 30)),
            Image.asset(
              'assets/images/logo-home-doctor.png',
              width: 80,
              height: 80,
            ),
            Expanded(
              flex: 3,
              child: ListView(
                children: <Widget>[
                  Column(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 50)),
                      Divider(
                        color: DefaultTheme.GREY_TOP_TAB_BAR,
                        height: 0.25,
                      ),
                      TextFieldHDr(
                        style: TFStyle.NO_BORDER,
                        label: 'Tên đăng nhập',
                        placeHolder: '',
                        inputType: TFInputType.TF_TEXT,
                        controller: _usernameController,
                        keyboardAction: TextInputAction.next,
                        onChange: (text) {
                          //
                        },
                      ),
                      Divider(
                        color: DefaultTheme.GREY_TOP_TAB_BAR,
                        height: 0.25,
                      ),
                      TextFieldHDr(
                        style: TFStyle.NO_BORDER,
                        label: 'Mật khẩu',
                        placeHolder: '',
                        inputType: TFInputType.TF_PASSWORD,
                        // controller: Provider.of<PhoneAuthDataProvider>(context,
                        //         listen: false)
                        //     .phoneNumberController,
                        controller: _passwordController,
                        keyboardAction: TextInputAction.next,
                        onChange: (text) {
                          //
                        },
                      ),
                      Divider(
                        color: DefaultTheme.GREY_TOP_TAB_BAR,
                        height: 0.25,
                      ),
                    ],
                  ),
                  //
                ],
              ),
            ),
            ButtonHDr(
              style: BtnStyle.BUTTON_BLACK,
              label: 'Đăng nhập',
              onTap: () async {
                //
                setState(() {
                  accountDTO = AccountDTO(
                      username: _usernameController.text,
                      password: _passwordController.text);
                });
                if (accountDTO.username != '' && accountDTO.password != '') {
                  await _checkLogin(accountDTO);
                } else {
                  return showDialog(
                      context: context,
                      builder: (BuildContext context) => CupertinoAlertDialog(
                            title: Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text("Đăng nhập thất bại"),
                            ),
                            content: Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                'Vui lòng điền đầy đủ thông tin đăng nhập.',
                                style: TextStyle(
                                    color: DefaultTheme.GREY_TEXT,
                                    height: 1.25),
                              ),
                            ),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                isDefaultAction: true,
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ));
                }
              },
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            Text(
              'Powered by HomeDoctor',
              style: TextStyle(
                color: DefaultTheme.GREY_TEXT,
                fontSize: 12,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
          ],
        ),
      ),
    );
  }

  _checkLogin(AccountDTO dto) async {
    setState(() {
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text("Đang đăng nhập"),
                ),
                content: Container(
                  width: 200,
                  height: 200,
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset('assets/images/loading.gif'),
                  ),
                ),
              ));
      if (dto != null) {
        _accountBloc.add(AccountEventCheckLogin(dto: dto));
        Future.delayed(const Duration(seconds: 2), () {
          // deleayed code here
          print('delayed execution');

          _authenticateHelper.isAuthenticated().then((value) async {
            if (value == true) {
              Navigator.of(context).pop();
              await Navigator.pushNamedAndRemoveUntil(context,
                  RoutesHDr.MAIN_HOME, (Route<dynamic> route) => false);
            } else {
              Navigator.of(context).pop();
              return showDialog(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                        title: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text("Đăng nhập thất bại"),
                        ),
                        content: Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            'Tên đăng nhập hoặc mật khẩu không đúng',
                            style: TextStyle(
                                color: DefaultTheme.GREY_TEXT, height: 1.25),
                          ),
                        ),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ));
            }
          });
        });
      }
    });
  }

  // Future<bool> loginUser(String phone, BuildContext context) async {
  //   FirebaseAuth _auth = FirebaseAuth.instance;
  //   _auth.setSettings(appVerificationDisabledForTesting: true);
  //   _auth.verifyPhoneNumber(
  //     phoneNumber: phone.toString(),
  //     timeout: Duration(seconds: 60),
  //     verificationCompleted: (AuthCredential credential) async {
  //       UserCredential result = await _auth.signInWithCredential(credential);
  //       FirebaseUser user = result.user;

  //       if (user != null) {
  //         Navigator.pushNamed(context, RoutesHDr.MAIN_HOME);
  //       } else {
  //         print("Error");
  //       }

  //       //This callback would gets called when verification is done auto maticlly
  //     },
  //     verificationFailed: (FirebaseAuthException exception) {
  //       print('Login EXCEPTION FIREBASE ${exception}');
  //     },
  //     codeSent: (String verificationId, [int forceResendingToken]) {
  //       // showDialog(
  //       //     context: context,
  //       //     barrierDismissible: false,
  //       //     builder: (context) {
  //       //       return AlertDialog(
  //       //         title: Text("Give the code?"),
  //       //         content: Column(
  //       //           mainAxisSize: MainAxisSize.min,
  //       //           children: <Widget>[
  //       //             TextField(
  //       //               controller: _codeController,
  //       //             ),
  //       //           ],
  //       //         ),
  //       //         actions: <Widget>[
  //       //           FlatButton(
  //       //             child: Text("Confirm"),
  //       //             textColor: Colors.white,
  //       //             color: Colors.blue,
  //       //             onPressed: () async {
  //       //               final code = _codeController.text.trim();
  //       //               AuthCredential credential =
  //       //                   PhoneAuthProvider.getCredential(
  //       //                       verificationId: verificationId, smsCode: code);

  //       //               UserCredential result =
  //       //                   await _auth.signInWithCredential(credential);

  //       //               if (result.user != null) {
  //       //                 Navigator.pushNamed(context, RoutesHDr.MAIN_HOME);
  //       //               } else {
  //       //                 print("Error");
  //       //               }
  //       //             },
  //       //           )
  //       //         ],
  //       //       );
  //       //     });
  //       String _phoneAndVerificationId = '${_phoneNo}:::${verificationId}';
  //       Navigator.pushNamed(context, RoutesHDr.CONFIRM_LOG_IN,
  //           arguments: {'PHONE_NO_&_VERIFICATION_ID': _phoneAndVerificationId});
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {
  //       // Auto-resolution timed out...
  //     },
  //   );
  // }
}
