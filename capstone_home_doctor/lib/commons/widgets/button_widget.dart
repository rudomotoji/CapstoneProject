import 'package:capstone_home_doctor/commons/constants/numeral_ui.dart';
import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:flutter/material.dart';

//For simple button

class ButtonHDr extends StatefulWidget {
  //action onTap
  final VoidCallback onTap;
  //label of button
  final String label;
  //image for button. Image is used if style = BUTTON_IMAGE or BUTTON_FULL
  final Image image;
  //Style of button, enum below.
  final BtnStyle style;
  //optional field
  //width, height
  final double width;
  final double height;
  //we should use margin in stead of width. It's good for responsive (suitable with almost screen types.).
  final double margin;
  //with button full, we can defined button color and text color
  final Color bgColor;
  final Color labelColor;

  const ButtonHDr({
    Key key,
    this.onTap,
    this.label,
    this.image,
    this.style,
    this.width,
    this.height,
    this.margin,
    this.bgColor,
    this.labelColor,
  }) : super(key: key);

  @override
  _ButtonHDr createState() => _ButtonHDr(
      label, image, style, width, height, margin, bgColor, labelColor);
}

class _ButtonHDr extends State<ButtonHDr> {
  String _label;
  Image _image;
  BtnStyle _style;
  double _width;
  double _height;
  double _margin;
  Color _bgColor;
  Color _labelColor;

  @override
  _ButtonHDr(
    this._label,
    this._image,
    this._style,
    this._width,
    this._height,
    this._margin,
    this._bgColor,
    this._labelColor,
  );

  @override
  Widget build(BuildContext context) {
    if ((_width == 0 || _width == null) && (_margin == 0 || _margin == null)) {
      _width =
          MediaQuery.of(context).size.width - (DefaultNumeralUI.PADDING * 4);
    }
    // if ((_width != 0 && _width != null) && (_margin == 0 || _margin == null)) {}
    if ((_width == 0 || _width == null) &&
        (_margin != null || _margin != null)) {
      _width = MediaQuery.of(context).size.width - (_margin * 2);
    }
    if ((_width != 0 || _width != null) &&
        (_margin != null || _margin != null)) {
      _width = MediaQuery.of(context).size.width - (_margin * 2);
    }
    if (_height == 0 || _height == null) {
      _height = DefaultNumeralUI.BUTTON_HEIGHT;
    }
    if (_label == null || _label == '') {
      _label = 'Button';
    }
    switch (_style) {
      case BtnStyle.BUTTON_BLACK:
        _bgColor = DefaultTheme.BLACK_BUTTON;
        _labelColor = DefaultTheme.WHITE;
        break;
      case BtnStyle.BUTTON_GREY:
        _bgColor = DefaultTheme.GREY_BUTTON;
        _labelColor = DefaultTheme.BLACK;
        break;
      case BtnStyle.BUTTON_TRANSPARENT:
        _bgColor = DefaultTheme.TRANSPARENT;
        _labelColor = DefaultTheme.BLACK;
        break;
      case BtnStyle.BUTTON_FULL:
        if (_bgColor == null) {
          _bgColor = DefaultTheme.BLACK_BUTTON;
        }
        if (_labelColor == null) {
          _labelColor = DefaultTheme.WHITE;
        }
        break;
      case BtnStyle.BUTTON_IMAGE:
        if (_width <= 0 || _width > 50 || _width == null) {
          _width = DefaultNumeralUI.BUTTON_IMAGE_SIZE;
        }
        if (_height <= 0 || _height > 50 || _height == null) {
          _height = DefaultNumeralUI.BUTTON_IMAGE_SIZE;
        }
        break;
      default:
        _bgColor = DefaultTheme.BLACK_BUTTON;
        _labelColor = DefaultTheme.WHITE;
        break;
    }
    if (_style == BtnStyle.BUTTON_IMAGE) {
      return SizedBox(
        width: _width,
        height: _height,
        child: IconButton(
          icon: _image,
          onPressed: widget.onTap,
        ),
      );
    } else if (_style == BtnStyle.BUTTON_FULL) {
      return FlatButton.icon(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(DefaultNumeralUI.BORDER_RADIUS)),
        color: _bgColor,
        minWidth: _width,
        height: _height,
        onPressed: widget.onTap,
        icon: SizedBox(
          width: DefaultNumeralUI.ICON_SIZE_BUTTON,
          height: DefaultNumeralUI.ICON_SIZE_BUTTON,
          child: _image,
        ),
        label: Text(
          _label,
          style: TextStyle(
              fontSize: DefaultNumeralUI.BUTTON_LABEL_SIZE, color: _labelColor),
        ),
      );
    } else {
      return FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(DefaultNumeralUI.BORDER_RADIUS)),
        color: _bgColor,
        minWidth: _width,
        height: _height,
        onPressed: widget.onTap,
        child: Text(
          _label,
          style: TextStyle(
              fontSize: DefaultNumeralUI.BUTTON_LABEL_SIZE, color: _labelColor),
        ),
      );
    }
  }
}

enum BtnStyle {
  BUTTON_BLACK,
  BUTTON_GREY,
  BUTTON_TRANSPARENT,
  BUTTON_IMAGE,
  BUTTON_FULL,
}
