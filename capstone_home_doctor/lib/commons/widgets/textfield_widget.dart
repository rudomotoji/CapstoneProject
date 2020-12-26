import 'package:capstone_home_doctor/commons/constants/numeral.dart';
import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:flutter/material.dart';

enum TextFieldStyleHDr { NO_BORDER, BORDERED, CONTAIN_UNIT }

//status: not done yet.

//defined addition about input style.
//catch length of textfield. if number, make number right of textfield, else left
//sub label if text field has unit.
//...

class TextFieldHomeDoctor extends StatefulWidget {
  //add more attribute about the input type: number, email, text, textarea,

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
  final int maxLenght;
  //style capitalization
  final TextCapitalization capitalStyle;

  const TextFieldHomeDoctor({
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
    this.maxLenght,
    this.capitalStyle,
  }) : super(key: key);

  @override
  _TextFieldHomeDoctor createState() => _TextFieldHomeDoctor(
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
      maxLenght);
}

class _TextFieldHomeDoctor extends State<TextFieldHomeDoctor>
    with WidgetsBindingObserver {
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
  int _maxLenght;
  TextCapitalization _capitalStyle;

  _TextFieldHomeDoctor(
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
    this._maxLenght,
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
              padding: EdgeInsets.only(left: DefaultNumeral.DEFAULT_PADDING),
              width: DefaultNumeral.DEFAULT_LABEL_WIDTH,
              height: DefaultNumeral.DEFAULT_LABEL_HEIGHT,
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
                textInputAction: _buttonKeyboardAction,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: _hintText,
                  contentPadding: EdgeInsets.fromLTRB(
                      10, 0, DefaultNumeral.DEFAULT_PADDING, 0),
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
            Padding(
                padding: EdgeInsets.only(left: DefaultNumeral.DEFAULT_PADDING)),
            Flexible(
              child: TextField(
                obscureText: _isObsecure,
                textInputAction: _buttonKeyboardAction,
                textCapitalization: _capitalStyle,
                maxLength: _maxLenght,
                decoration: InputDecoration(
                  labelText: _label,
                  helperText: _helperText,
                  filled: true,
                  fillColor: DefaultTheme.GREY_BUTTON.withOpacity(0.8),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(
                      DefaultNumeral.DEFAULT_PADDING,
                      0,
                      DefaultNumeral.DEFAULT_PADDING,
                      0),
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
            Padding(
                padding:
                    EdgeInsets.only(right: DefaultNumeral.DEFAULT_PADDING)),
          ],
        );
        break;
      case TextFieldStyleHDr.CONTAIN_UNIT:
        print('contian unit');
        // TODO: Handle this case.
        break;
    }
  }
}

//not official.
