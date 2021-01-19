//Simple Textfield
import 'dart:math';

import 'package:capstone_home_doctor/commons/constants/numeral_ui.dart';
import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:flutter/material.dart';

enum TFInputType {
  TF_PASSWORD,
  TF_TEXT,
  TF_NUMBER,
  TF_PHONE,
  TF_EMAIL,
}

enum TFStyle {
  NO_BORDER,
  BORDERED,
  UNIT,
  TEXT_AREA,
}

class TextFieldHDr extends StatefulWidget {
  //controller of textfield
  final TextEditingController controller;
  //action onChange
  final ValueChanged<Object> onChange;
  //label of textfield
  final String label;
  //The view of keyboard and the value view in textfield
  final TFInputType inputType;
  //the action of keyboard
  final TextInputAction keyboardAction;
  //the desc. in textfield.
  final String placeHolder;
  //helper Text is shown below the textfield for help people inut right
  final String helperText;
  //maximum Length of text field
  final int maxLength;
  //style capitalization
  final TextCapitalization capitalStyle;
  //style of textfield
  final TFStyle style;
  //unit of textfield
  final String unit;
  //flag for multiple textfield in row
  final bool isMultipleInRow;
  //auto focus textfield
  final bool autoFocus;

  const TextFieldHDr({
    Key key,
    this.controller,
    this.onChange,
    this.label,
    this.inputType,
    this.keyboardAction,
    this.placeHolder,
    this.helperText,
    this.maxLength,
    this.capitalStyle,
    this.style,
    this.unit,
    this.isMultipleInRow,
    this.autoFocus,
  }) : super(key: key);

  @override
  _TextFieldHDr createState() => _TextFieldHDr(
      controller,
      label,
      inputType,
      keyboardAction,
      placeHolder,
      helperText,
      maxLength,
      capitalStyle,
      style,
      unit,
      isMultipleInRow,
      autoFocus);
}

class _TextFieldHDr extends State<TextFieldHDr> with WidgetsBindingObserver {
  TextEditingController _controller;
  String _label;
  TFInputType _inputType;
  TextInputAction _keyboardAction;
  String _placeHolder;
  String _helperText;
  int _maxLength;
  TextCapitalization _capitalStyle;
  TFStyle _style;
  String _unit;
  bool _isMultipleInRow;
  bool _autoFocus;

  _TextFieldHDr(
    this._controller,
    this._label,
    this._inputType,
    this._keyboardAction,
    this._placeHolder,
    this._helperText,
    this._maxLength,
    this._capitalStyle,
    this._style,
    this._unit,
    this._isMultipleInRow,
    this._autoFocus,
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
    if (_style == null) {
      _style = TFStyle.NO_BORDER;
    }
    if (_capitalStyle == null) {
      _capitalStyle = TextCapitalization.none;
    }

    switch (_style) {
      case TFStyle.NO_BORDER:
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
                  fontWeight: DefaultNumeralUI.FONT_WEIGHT_LABEL_TEXTFIELD,
                  fontSize: DefaultNumeralUI.TEXTFIELD_LABEL_SIZE,
                ),
              ),
            ),
            Flexible(
              child: TextField(
                autofocus: true,
                obscureText:
                    (_inputType == TFInputType.TF_PASSWORD) ? true : false,
                keyboardType: (_inputType == TFInputType.TF_NUMBER)
                    ? TextInputType.number
                    : (_inputType == TFInputType.TF_EMAIL)
                        ? TextInputType.emailAddress
                        : (_inputType == TFInputType.TF_PHONE)
                            ? TextInputType.phone
                            : (_inputType == TFInputType.TF_TEXT)
                                ? TextInputType.text
                                : null,
                textInputAction: _keyboardAction,
                textCapitalization: _capitalStyle,
                maxLength: _maxLength,
                buildCounter: (BuildContext context,
                        {int currentLength, int maxLength, bool isFocused}) =>
                    null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: _placeHolder,
                  contentPadding: EdgeInsets.fromLTRB(
                      DefaultNumeralUI.PADDING_10,
                      0,
                      DefaultNumeralUI.PADDING,
                      0),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                onChanged: widget.onChange,
                controller: _controller,
              ),
            ),
          ],
        );
        break;
      case TFStyle.BORDERED:
        return Row(
          children: [
            if (_isMultipleInRow == false)
              Padding(padding: EdgeInsets.only(left: DefaultNumeralUI.PADDING)),
            Padding(padding: EdgeInsets.only(left: 2.5)),
            Flexible(
              child: TextField(
                autofocus: true,
                obscureText:
                    (_inputType == TFInputType.TF_PASSWORD) ? true : false,
                keyboardType: (_inputType == TFInputType.TF_NUMBER)
                    ? TextInputType.number
                    : (_inputType == TFInputType.TF_EMAIL)
                        ? TextInputType.emailAddress
                        : (_inputType == TFInputType.TF_PHONE)
                            ? TextInputType.phone
                            : (_inputType == TFInputType.TF_TEXT)
                                ? TextInputType.text
                                : null,
                textInputAction: _keyboardAction,
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
                onChanged: widget.onChange,
                controller: _controller,
              ),
            ),
            if (_isMultipleInRow == false)
              Padding(padding: EdgeInsets.only(left: DefaultNumeralUI.PADDING)),
            Padding(padding: EdgeInsets.only(left: 2.5)),
          ],
        );
        break;
      case TFStyle.TEXT_AREA:
        break;
      case TFStyle.UNIT:
        return Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  left: DefaultNumeralUI.PADDING,
                  right: DefaultNumeralUI.PADDING),
              child: TextField(
                autofocus: true,
                textAlign: TextAlign.right,
                obscureText:
                    (_inputType == TFInputType.TF_PASSWORD) ? true : false,
                keyboardType: (_inputType == TFInputType.TF_NUMBER)
                    ? TextInputType.number
                    : (_inputType == TFInputType.TF_EMAIL)
                        ? TextInputType.emailAddress
                        : (_inputType == TFInputType.TF_PHONE)
                            ? TextInputType.phone
                            : (_inputType == TFInputType.TF_TEXT)
                                ? TextInputType.text
                                : null,
                textInputAction: _keyboardAction,
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
                _unit,
                style: TextStyle(
                  fontWeight: DefaultNumeralUI.FONT_WEIGHT_LABEL_TEXTFIELD,
                  fontSize: DefaultNumeralUI.TEXTFIELD_LABEL_SIZE,
                ),
              ),
            ),
          ],
        );
        break;
    }
  }
}
