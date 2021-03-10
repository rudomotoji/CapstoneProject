//noti & warning badge,
import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum NotificationType {
  MEDICAL_INSTRUCTION,
  CONTRACT,
  UNKNOWN,
}

final DateValidator _dateValidator = DateValidator();

class BadgeWidget extends StatefulWidget {
  final String title;
  final bool isRead;
  final String description;
  final int contractId;
  final int medInsId;
  final String date;

  const BadgeWidget({
    Key key,
    this.title,
    this.isRead,
    this.description,
    this.contractId,
    this.medInsId,
    this.date,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BadgeWidget(title, isRead, description, contractId, medInsId, date);
  }
}

class _BadgeWidget extends State<BadgeWidget> with WidgetsBindingObserver {
  String _title;
  bool _isRead;
  String _description;
  int _contractId;
  int _medInsId;
  String _date;
  NotificationType _notiType;
  String _imgString;

  @override
  _BadgeWidget(
    this._title,
    this._isRead,
    this._description,
    this._contractId,
    this._medInsId,
    this._date,
  );

  @override
  Widget build(BuildContext context) {
    if (_isRead == null) {
      _isRead = false;
    }
    if (_title.trim().toUpperCase().contains('Y LỆNH')) {
      //
      _notiType = NotificationType.MEDICAL_INSTRUCTION;
      _imgString = 'assets/images/ic-medical-instruction.png';
    } else if (_title.trim().toUpperCase().contains('HỢP ĐỒNG')) {
      //
      _notiType = NotificationType.CONTRACT;
      _imgString = 'assets/images/ic-contract.png';
    } else {
      _notiType = NotificationType.UNKNOWN;
      _imgString = 'assets/images/logo-home-doctor.png';
    }
    if (_date == null) {
      _date = '';
    }
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(bottom: 5),
        width: MediaQuery.of(context).size.width - 10,
        height: 100,
        decoration: BoxDecoration(
          color: (_isRead == false)
              ? DefaultTheme.GREY_VIEW
              : (DefaultTheme.TRANSPARENT),
          borderRadius: BorderRadius.circular(0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 65,
              height: 100,
              child: Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset('${_imgString}'),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: 5, top: 10),
                  width: MediaQuery.of(context).size.width - 80,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      (_title == '' || _title == null)
                          ? 'Tiêu đề'
                          : '${toBeginningOfSentenceCase(_title.trim().toLowerCase())}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: DefaultTheme.BLACK,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 5, top: 5),
                  width: MediaQuery.of(context).size.width - 75,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      (_title == '' || _title == null)
                          ? 'Mô tả'
                          : '${_description}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                // Spacer(),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 6),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: (_date != null && _date != '')
                        ? Text('${_dateValidator.parseDateToNotiView(_date)}',
                            style: TextStyle(
                              color: DefaultTheme.GREY_TEXT,
                              fontSize: 14,
                            ))
                        : Text(
                            'Thời gian',
                            style: TextStyle(
                              color: DefaultTheme.GREY_TEXT,
                              fontSize: 14,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
