//Simple Textfield
import 'dart:math';

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
      unit);
}

class _TextFieldHDr extends State<TextFieldHDr> with WidgetsBindingObserver {
  TextEditingController _controller;
  String _label;
  TFInputType _inputType;
  TextInputAction _keyboardAction;
  String _placeHolder;
  String _helperText;
  int _maxLength;
  TFStyle _style;
  String _unit;

  final TextCapitalization _capitalStyle;
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
    if (_helperText == null || _helperText == '' || _helperText.isEmpty) {
      _helperText = 'Helper text';
    }
    if (_placeHolder == null || _placeHolder == '' || _placeHolder.isEmpty) {
      _placeHolder = 'Placeholder';
    }
      
    return null;
  }
}
