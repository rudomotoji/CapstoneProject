import 'package:flutter/material.dart';

// class TextFieldHDr extends StatefulWidget {
//   //controller of textfield
//   final TextEditingController controller;
//   //onChange action
//   final ValueChanged<Object> onChange;
//   //label of textfield
//   final String label;
//   //style of textfield. Enum below.
//   final TextFieldStyleHDr style;
//   //format type of textfield. Enum below
//   final
// }

// class _TextFieldHDr extends State<TextFieldHDr> with WidgetsBindingObserver {}

import 'package:capstone_home_doctor/commons/constants/numeral_ui.dart';
import 'package:capstone_home_doctor/commons/constants/theme.dart';

enum TextFieldStyleHDr { NO_BORDER, BORDERED, CONTAIN_UNIT, TEXT_AREA }

class TextFieldHDr2 extends StatefulWidget {
  //controller of textfield
  final TextEditingController controller;
  //action onChange
  final ValueChanged<Object> onChange;
  //label of textfield
  final String label;
  //all text font size in a textfield
  final double fontSize;
  //color text
  final Color textColor;
  //is password field or not
  final bool isObsecure;
  //custom for submit button in keyboard
  final TextInputAction buttonKeyboardAction;
  //keyboard type
  final TextInputType keyboardType;
  //style of textfield, default is NO_BORDER.
  final TextFieldStyleHDr textfieldStyle;
  //hint text in textfield
  final String hintText;
  //helper text under textfield
  final String helperText;
  //max lenght for textfield
  final int maxLength;
  //style capitalization
  final TextCapitalization capitalStyle;
  //input field style

  const TextFieldHDr2({
    Key key,
    this.controller,
    this.onChange,
    this.label,
    this.fontSize,
    this.textColor,
    this.isObsecure,
    this.buttonKeyboardAction,
    this.keyboardType,
    this.textfieldStyle,
    this.hintText,
    this.helperText,
    this.maxLength,
    this.capitalStyle,
  }) : super(key: key);

  @override
  _TextFieldHDr2 createState() => _TextFieldHDr2(
      controller,
      label,
      fontSize,
      textColor,
      isObsecure,
      buttonKeyboardAction,
      keyboardType,
      textfieldStyle,
      hintText,
      helperText,
      capitalStyle,
      maxLength);
}

class _TextFieldHDr2 extends State<TextFieldHDr2> with WidgetsBindingObserver {
  TextEditingController _controller;
  String _label;
  double _fontSize;
  Color _textColor;
  bool _isObsecure;
  TextInputAction _buttonKeyboardAction;
  TextInputType _keyboardType;
  TextFieldStyleHDr _textfieldStyle;
  String _hintText;
  String _helperText;
  int _maxLength;
  TextCapitalization _capitalStyle;

  _TextFieldHDr2(
    this._controller,
    this._label,
    this._fontSize,
    this._textColor,
    this._isObsecure,
    this._buttonKeyboardAction,
    this._keyboardType,
    this._textfieldStyle,
    this._hintText,
    this._helperText,
    this._capitalStyle,
    this._maxLength,
  );

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_label == null || _label == '' || _label.isEmpty) {
      _label = 'Label';
    }
    if (_fontSize == null || _fontSize == 0) {
      _fontSize = 15;
    }
    if (_textColor == null) {
      _textColor = DefaultTheme.BLACK;
    }
    if (_isObsecure == null) {
      _isObsecure = false;
    }
    if (_buttonKeyboardAction == null) {
      _buttonKeyboardAction = TextInputAction.done;
    }
    if (_keyboardType == null) {
      _keyboardType = TextInputType.text;
    }
    if (_textfieldStyle == null) {
      _textfieldStyle = TextFieldStyleHDr.NO_BORDER;
    }
    if (_hintText == null || _hintText == '' || _hintText.isEmpty) {
      _hintText = 'placeholder';
    }
    if (_helperText == null || _helperText == '' || _helperText.isEmpty) {
      _helperText = 'Please describes helper text: some desc here';
    }
    if (_capitalStyle == null) {
      _capitalStyle = TextCapitalization.none;
    }
    switch (_textfieldStyle) {
      case TextFieldStyleHDr.NO_BORDER:
        return Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: DefaultNumeralUI.PADDING),
              width: DefaultNumeralUI.LABEL_TEXTFIELD_WIDTH,
              height: DefaultNumeralUI.LABEL_TEXTFIELD_HEIGHT,
              alignment: Alignment.centerLeft,
              child: Text(
                '${_label}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: _fontSize,
                ),
              ),
            ),
            Flexible(
              child: TextField(
                obscureText: _isObsecure,
                keyboardType: _keyboardType,
                textInputAction: _buttonKeyboardAction,
                textCapitalization: _capitalStyle,
                maxLength: _maxLength,
                buildCounter: (BuildContext context,
                        {int currentLength, int maxLength, bool isFocused}) =>
                    null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: _hintText,
                  contentPadding:
                      EdgeInsets.fromLTRB(10, 0, DefaultNumeralUI.PADDING, 0),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                onChanged: widget.onChange,
                controller: _controller,
              ),
            )
          ],
        );
        break;
      case TextFieldStyleHDr.BORDERED:
        return Row(
          children: [
            Padding(padding: EdgeInsets.only(left: DefaultNumeralUI.PADDING)),
            Flexible(
              child: TextField(
                obscureText: _isObsecure,
                keyboardType: _keyboardType,
                textInputAction: _buttonKeyboardAction,
                textCapitalization: _capitalStyle,
                maxLength: _maxLength,
                decoration: InputDecoration(
                  counter: Offstage(),
                  labelText: _label,
                  helperText: _helperText,
                  filled: true,
                  fillColor: DefaultTheme.GREY_BUTTON.withOpacity(0.8),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(
                      DefaultNumeralUI.PADDING, 0, DefaultNumeralUI.PADDING, 0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      width: 0.25,
                      color: DefaultTheme.TRANSPARENT,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      width: 0.25,
                      color: DefaultTheme.TRANSPARENT,
                    ),
                  ),
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(right: DefaultNumeralUI.PADDING)),
          ],
        );
        break;
      case TextFieldStyleHDr.CONTAIN_UNIT:
        return Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  left: DefaultNumeralUI.PADDING,
                  right: DefaultNumeralUI.PADDING),
              child: TextField(
                textAlign: TextAlign.right,
                obscureText: _isObsecure,
                keyboardType: _keyboardType,
                textInputAction: _buttonKeyboardAction,
                textCapitalization: _capitalStyle,
                maxLength: _maxLength,
                decoration: InputDecoration(
                  counter: Offstage(),
                  hintText: _label,
                  filled: true,
                  fillColor: DefaultTheme.GREY_BUTTON.withOpacity(0.8),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(DefaultNumeralUI.PADDING,
                      0, DefaultNumeralUI.PADDING * 2 + 10, 0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      width: 0.25,
                      color: DefaultTheme.TRANSPARENT,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      width: 0.25,
                      color: DefaultTheme.TRANSPARENT,
                    ),
                  ),
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
            Positioned(
              right: DefaultNumeralUI.PADDING * 2,
              top: 14,
              child: Text(
                'cm',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: _fontSize,
                ),
              ),
            ),
          ],
        );
        break;
      case TextFieldStyleHDr.TEXT_AREA:
        break;
    }
  }
}

// enum TextFieldStyleHDr {
//   BORDER,
//   NO_BORDER,
//   CONTAIN_UNIT,
//   TEXT_EREA,
// }

// enum InputStyleHDr {
//   PASSWORD,
//   TEXT,
//   NUMBER,
//   DOUBLE,
// }
