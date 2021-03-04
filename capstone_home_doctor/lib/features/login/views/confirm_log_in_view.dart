// import 'package:capstone_home_doctor/commons/constants/theme.dart';
// import 'package:capstone_home_doctor/commons/routes/routes.dart';
// import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
// import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
// import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
// import 'package:capstone_home_doctor/services/authen_helper.dart';
// import 'package:flutter/material.dart';

// import 'package:firebase_auth/firebase_auth.dart';

// class ConfirmLogin extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return _ConfirmLogin();
//   }
// }

// final AuthenticateHelper authenHelper = AuthenticateHelper();

// class _ConfirmLogin extends State<ConfirmLogin> {
//   var _pin1 = TextEditingController();
//   var _pin2 = TextEditingController();
//   var _pin3 = TextEditingController();
//   var _pin4 = TextEditingController();
//   var _pin5 = TextEditingController();
//   var _pin6 = TextEditingController();

//   String _phoneNo = '';
//   String _otpCode;
//   String _verificationId;

//   @override
//   void initState() {
//     //WidgetsBinding.instance.addObserver(this);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     // WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Map<String, String> arguments = ModalRoute.of(context).settings.arguments;
//     _phoneNo = arguments['PHONE_NO_&_VERIFICATION_ID'].split(':::')[0];
//     _verificationId = arguments['PHONE_NO_&_VERIFICATION_ID'].split(':::')[1];
//     //
//     // _phoneNo = Provider.of<PhoneAuthDataProvider>(context, listen: false)
//     //     .phoneNumberController
//     //     .text;

//     // final phoneAuthDataProvider =
//     //     Provider.of<PhoneAuthDataProvider>(context, listen: false);

//     // phoneAuthDataProvider.setMethods(
//     //   onStarted: onStarted,
//     //   onError: onError,
//     //   onFailed: onFailed,
//     //   onVerified: onVerified,
//     //   onCodeResent: onCodeResent,
//     //   onCodeSent: onCodeSent,
//     //   onAutoRetrievalTimeout: onAutoRetrievalTimeOut,
//     // );

//     return Scaffold(
//       backgroundColor: DefaultTheme.WHITE,
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             HeaderWidget(
//               title: 'Xác nhận',
//               isMainView: false,
//               //buttonHeaderType: ButtonHeaderType.NEW_MESSAGE,
//             ),
//             Container(
//               padding: EdgeInsets.only(top: 20, left: 20, right: 20),
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 'Nhập mã số gồm 6 chữ số được gửi tới ',
//                 textAlign: TextAlign.left,
//                 style: TextStyle(color: DefaultTheme.GREY_TEXT, fontSize: 16),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.only(left: 20, right: 20),
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 '+84${_phoneNo}',
//                 textAlign: TextAlign.left,
//                 style: TextStyle(color: DefaultTheme.BLACK, fontSize: 20),
//               ),
//             ),
//             Expanded(
//               flex: 3,
//               child: Row(
//                 children: <Widget>[
//                   Padding(
//                     padding: EdgeInsets.only(left: 10),
//                   ),
//                   Flexible(
//                     child: TextFieldHDr(
//                       controller: _pin1,
//                       inputType: TFInputType.TF_NUMBER,
//                       style: TFStyle.BORDERED,
//                       maxLength: 1,
//                       keyboardAction: TextInputAction.next,
//                       onChange: (text) {
//                         if (text.toString().length == 1) {
//                           FocusScope.of(context).unfocus();
//                           FocusScope.of(context).nextFocus();
//                         }
//                       },
//                     ),
//                   ),
//                   Flexible(
//                     child: TextFieldHDr(
//                       controller: _pin2,
//                       inputType: TFInputType.TF_NUMBER,
//                       style: TFStyle.BORDERED,
//                       maxLength: 1,
//                       keyboardAction: TextInputAction.next,
//                       onChange: (text) {
//                         if (text.toString().length == 1) {
//                           FocusScope.of(context).unfocus();
//                           FocusScope.of(context).nextFocus();
//                         }
//                       },
//                     ),
//                   ),
//                   Flexible(
//                     child: TextFieldHDr(
//                       controller: _pin3,
//                       inputType: TFInputType.TF_NUMBER,
//                       style: TFStyle.BORDERED,
//                       maxLength: 1,
//                       keyboardAction: TextInputAction.next,
//                       onChange: (text) {
//                         if (text.toString().length == 1) {
//                           FocusScope.of(context).unfocus();
//                           FocusScope.of(context).nextFocus();
//                         }
//                       },
//                     ),
//                   ),
//                   Flexible(
//                     child: TextFieldHDr(
//                       controller: _pin4,
//                       inputType: TFInputType.TF_NUMBER,
//                       style: TFStyle.BORDERED,
//                       maxLength: 1,
//                       keyboardAction: TextInputAction.next,
//                       onChange: (text) {
//                         if (text.toString().length == 1) {
//                           FocusScope.of(context).unfocus();
//                           FocusScope.of(context).nextFocus();
//                         }
//                       },
//                     ),
//                   ),
//                   Flexible(
//                     child: TextFieldHDr(
//                       controller: _pin5,
//                       inputType: TFInputType.TF_NUMBER,
//                       style: TFStyle.BORDERED,
//                       maxLength: 1,
//                       keyboardAction: TextInputAction.next,
//                       onChange: (text) {
//                         if (text.toString().length == 1) {
//                           FocusScope.of(context).unfocus();
//                           FocusScope.of(context).nextFocus();
//                         }
//                       },
//                     ),
//                   ),
//                   Flexible(
//                     child: TextFieldHDr(
//                       controller: _pin6,
//                       inputType: TFInputType.TF_NUMBER,
//                       style: TFStyle.BORDERED,
//                       maxLength: 1,
//                       keyboardAction: TextInputAction.next,
//                       onChange: (text) {
//                         if (text.toString().length == 1) {
//                           FocusScope.of(context).unfocus();
//                           FocusScope.of(context).nextFocus();
//                         }
//                       },
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(right: 10),
//                   ),
//                 ],
//               ),
//             ),
//             ButtonHDr(
//               style: BtnStyle.BUTTON_BLACK,
//               label: 'Đăng nhập',
//               onTap: () async {
//                 _otpCode = _pin1.text +
//                     _pin2.text +
//                     _pin3.text +
//                     _pin4.text +
//                     _pin5.text +
//                     _pin6.text;

//                 //the last login
//                 // signIn();

//                 //I dont' know this
//                 // //   _loginAuth.verifyPhoneNo(
//                 // //       _phoneNo,
//                 // //       PhoneAuthDataProvider.getCredential(
//                 // //           verificationId: actualCode, smsCode: _otpCode),
//                 // //       _otpCode);

//                 //new

//                 AuthCredential credential = PhoneAuthProvider.getCredential(
//                     verificationId: _verificationId, smsCode: _otpCode);
//                 FirebaseAuth _auth = FirebaseAuth.instance;
//                 UserCredential result =
//                     await _auth.signInWithCredential(credential);
//                 //PRINT
//                 print('CREDENTIAL NOW ${credential}');
//                 print('RESULT NOW ${result}');
//                 if (result.user != null) {
//                   authenHelper.updateAuth(true);
//                   Navigator.pushNamed(context, RoutesHDr.MAIN_HOME);
//                 } else {
//                   print("Error");
//                 }
//               },
//             ),
//             Padding(padding: EdgeInsets.only(top: 20)),
//             Text(
//               'Powered by HomeDoctor',
//               style: TextStyle(
//                 color: DefaultTheme.GREY_TEXT,
//                 fontSize: 12,
//               ),
//             ),
//             Padding(padding: EdgeInsets.only(top: 10)),
//           ],
//         ),
//       ),
//     );
//   }
// }
