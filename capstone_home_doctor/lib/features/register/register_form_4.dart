import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:capstone_home_doctor/models/relative_dto.dart';
import 'package:flutter/material.dart';

class RegisterPage4 extends StatefulWidget {
  List<RelativeDTO> listRelative;
  TextEditingController relativeNameController = TextEditingController();
  TextEditingController phoneRelativeController = TextEditingController();
  VoidCallback addRelative;
  void Function(int) deleteRelative;

  RegisterPage4({
    Key key,
    this.listRelative,
    this.relativeNameController,
    this.phoneRelativeController,
    this.addRelative,
    this.deleteRelative,
  }) : super(key: key);

  @override
  _RegisterPage4State createState() => _RegisterPage4State();
}

class _RegisterPage4State extends State<RegisterPage4> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Text(
              'Thêm người thân',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ),
          Row(
            children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      width: 300,
                      child: TextFieldHDr(
                        style: TFStyle.BORDERED,
                        label: 'Tên người thân:',
                        placeHolder: 'nguyen van a...',
                        inputType: TFInputType.TF_TEXT,
                        controller: widget.relativeNameController,
                        keyboardAction: TextInputAction.done,
                        onChange: (text) {},
                      ),
                    ),
                    Container(
                      width: 300,
                      child: TextFieldHDr(
                        style: TFStyle.BORDERED,
                        label: 'Số điện thoại:',
                        placeHolder: '0987654321',
                        inputType: TFInputType.TF_PHONE,
                        controller: widget.phoneRelativeController,
                        keyboardAction: TextInputAction.done,
                        onChange: (text) {},
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => widget.addRelative(),
                child: Text('Thêm'),
              )
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.listRelative.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Text(widget.listRelative[index].fullName),
                            Text(widget.listRelative[index].phoneNumber),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => widget.deleteRelative(index),
                        child: Text('Xóa'),
                      )
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
