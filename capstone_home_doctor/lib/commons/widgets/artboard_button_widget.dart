import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:flutter/material.dart';

class ButtonArtBoard extends StatefulWidget {
  final String title;
  final String description;
  final String imageAsset;
  final VoidCallback onTap;

  const ButtonArtBoard({
    Key key,
    this.title,
    this.description,
    this.imageAsset,
    this.onTap,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _ButtonArtBoard(title, description, imageAsset);
}

class _ButtonArtBoard extends State<ButtonArtBoard> {
  String _title;
  String _description;
  String _imageAsset;

  @override
  _ButtonArtBoard(
    this._title,
    this._description,
    this._imageAsset,
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.only(left: 20),
        width: MediaQuery.of(context).size.width - 40,
        height: 100,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: DefaultTheme.GREY_TOP_TAB_BAR.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
          color: Color(0xffEEEFF3),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Expanded(
              child: Image.asset(
                _imageAsset,
                width: 35,
                height: 35,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 15),
                  width: MediaQuery.of(context).size.width - 40 - 150,
                  child: Text(
                    _title,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15, top: 3),
                  width: MediaQuery.of(context).size.width - 40 - 150,
                  child: Text(
                    _description,
                    style: TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Image.asset(
                'assets/images/ic-navigator.png',
                width: 20,
                height: 20,
              ),
            ),
            Padding(padding: EdgeInsets.all(5)),
          ],
        ),
      ),
    );
  }
}
