import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:flutter/material.dart';

enum ButtonStyleHDr {
  BUTTON_BLACK,
  BUTTON_GREY,
  BUTTON_TRANSPARENT,
  BUTTON_IMAGE,
}

//rerange button case
//status: Not Done yet.

class ButtonHomeDoctor extends StatefulWidget {
  //action onTap
  final VoidCallback onTap;
  //width button
  final double width;
  //height button
  final double height;
  //border radius of button
  final double borderRadius;
  //button name
  final String text;
  //color of button
  final Color backgroundColor;
  //color of button's name
  final Color textColor;
  //size of button's name
  final double fontSize;
  //Margin of button with screen. We should define margin for button in stead of width :D
  final double margin;
  //style of button
  final ButtonStyleHDr buttonStyle;

  const ButtonHomeDoctor({
    Key key,
    this.onTap,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.fontSize,
    this.text,
    this.textColor,
    this.margin,
    this.buttonStyle,
  }) : super(key: key);

  @override
  _ButtonHomeDoctor createState() => _ButtonHomeDoctor(
      width,
      height,
      borderRadius,
      text,
      backgroundColor,
      textColor,
      fontSize,
      margin,
      buttonStyle);
}

class _ButtonHomeDoctor extends State<ButtonHomeDoctor> {
  double _width;
  double _height;
  double _borderRadius;
  String _text;
  Color _backgroundColor;
  Color _textColor;
  double _fontSize;
  double _margin;
  ButtonStyleHDr _buttonStyle;

  @override
  _ButtonHomeDoctor(
    this._width,
    this._height,
    this._borderRadius,
    this._text,
    this._backgroundColor,
    this._textColor,
    this._fontSize,
    this._margin,
    this._buttonStyle,
  );
  @override
  Widget build(BuildContext context) {
    if (_width != null && _margin != null) {
      _width = MediaQuery.of(context).size.width - 80;
    } else if (_width == null && _margin != null) {
      _width = MediaQuery.of(context).size.width - (_margin * 2);
    }
    if (_width == 0 || _width == null || _width.isNaN || _width.isNegative) {
      _width = MediaQuery.of(context).size.width - 80;
    }
    if (_height == 0 || _height == null) {
      _height = 50;
    }
    if (_borderRadius == 0 || _borderRadius == null) {
      _borderRadius = 12;
    }
    if (_fontSize == 0 || _fontSize == null) {
      _fontSize = 16;
    }
    if (_textColor == null) {
      _textColor = DefaultTheme.WHITE;
    }
    if (_backgroundColor == null) {
      _backgroundColor = DefaultTheme.BLACK_BUTTON;
    }

    //notice this
    if (_text == null || _text == '' || _text.isEmpty) {
      _text = 'Button';
    }

    //notice this
    if (_buttonStyle == ButtonStyleHDr.BUTTON_TRANSPARENT) {
      _backgroundColor = DefaultTheme.TRANSPARENT;
    }
    if (_buttonStyle == ButtonStyleHDr.BUTTON_BLACK) {
      _textColor = DefaultTheme.WHITE;
      _backgroundColor = DefaultTheme.BLACK;
    }
    if (_buttonStyle == ButtonStyleHDr.BUTTON_GREY) {
      _textColor = DefaultTheme.BLACK;
      _backgroundColor = DefaultTheme.GREY_BUTTON;
    }
    return FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius)),
      color: _backgroundColor,
      minWidth: _width,
      height: _height,
      onPressed: widget.onTap,
      child: Text(
        _text,
        style: TextStyle(fontSize: _fontSize, color: _textColor),
      ),
    );
  }
}
