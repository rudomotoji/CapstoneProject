import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Register();
  }
}

class _Register extends State<Register> with WidgetsBindingObserver {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _careerController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  List gender = ["Male", "Female", "Other"];
  String select = 'Male';

  String birthday;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWidget(
              title: 'Đăng ký thông tin bệnh nhân',
              isMainView: true,
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            TextFieldHDr(
              style: TFStyle.BORDERED,
              label: 'Họ tên(*):',
              placeHolder: 'Nguyễn Văn A',
              maxLength: 10,
              inputType: TFInputType.TF_TEXT,
              controller: _fullNameController,
              keyboardAction: TextInputAction.next,
              onChange: (text) {},
            ),
            TextFieldHDr(
              style: TFStyle.BORDERED,
              label: 'SĐT(*):',
              placeHolder: '123456789',
              maxLength: 10,
              inputType: TFInputType.TF_PHONE,
              controller: _phoneController,
              keyboardAction: TextInputAction.next,
              onChange: (text) {},
            ),
            Row(
              children: [
                Text('Giới tính:'),
                Row(
                  children: <Widget>[
                    addRadioButton(0, 'Male'),
                    addRadioButton(1, 'Female'),
                    addRadioButton(2, 'Others'),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Text('Ngày sinh (*):'),
                FlatButton(
                  child: Text(
                    birthday == null ? 'show date time picker' : birthday,
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () async {
                    DateTime newDateTime = await showRoundedDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year - 1),
                        lastDate: DateTime(DateTime.now().year + 1),
                        borderRadius: 16,
                        theme: ThemeData.dark());
                    if (newDateTime != null) {
                      setState(() => birthday = newDateTime.toString());
                    }
                  },
                ),
              ],
            ),
            TextFieldHDr(
              style: TFStyle.BORDERED,
              label: 'Email:',
              placeHolder: 'abc@gmail.com',
              maxLength: 10,
              inputType: TFInputType.TF_EMAIL,
              controller: _emailController,
              keyboardAction: TextInputAction.next,
              onChange: (text) {},
            ),
            TextFieldHDr(
              style: TFStyle.BORDERED,
              label: 'Địa chỉ:',
              placeHolder: 'Hai Bà Trưng HN...',
              maxLength: 10,
              inputType: TFInputType.TF_TEXT,
              controller: _addressController,
              keyboardAction: TextInputAction.next,
              onChange: (text) {},
            ),
            TextFieldHDr(
              style: TFStyle.BORDERED,
              label: 'Nghề nghiệp:',
              placeHolder: 'Sinh viên',
              maxLength: 10,
              inputType: TFInputType.TF_TEXT,
              controller: _careerController,
              keyboardAction: TextInputAction.next,
              onChange: (text) {},
            ),
            TextFieldHDr(
              style: TFStyle.BORDERED,
              label: 'Chiều cao (*):',
              placeHolder: '1,75',
              maxLength: 10,
              inputType: TFInputType.TF_NUMBER,
              controller: _heightController,
              keyboardAction: TextInputAction.next,
              onChange: (text) {},
            ),
            TextFieldHDr(
              style: TFStyle.BORDERED,
              label: 'Cân nặng (*):',
              placeHolder: '59',
              maxLength: 10,
              inputType: TFInputType.TF_NUMBER,
              controller: _weightController,
              keyboardAction: TextInputAction.done,
              onChange: (text) {},
            ),
            ButtonHDr(
              style: BtnStyle.BUTTON_GREY,
              label: 'Xong',
              onTap: () {
                Navigator.pushReplacementNamed(context, RoutesHDr.MAIN_HOME);
              },
            ),
          ],
        ),
      )),
    );
  }

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: gender[btnValue],
          groupValue: select,
          onChanged: (value) {
            setState(() {
              print(value);
              select = value;
            });
          },
        ),
        Text(title)
      ],
    );
  }
}
