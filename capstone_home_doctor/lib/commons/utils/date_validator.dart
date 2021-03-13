import 'package:intl/intl.dart';

class DateValidator {
  DateValidator();

  String parseToDateView(String dateString) {
    String result = '';
    String day, month, year;
    String date = dateString.split('T')[0];
    day = date.split('-')[2];
    month = date.split('-')[1];
    year = date.split('-')[0];
    result = '${day} tháng ${month}, ${year}';
    return result;
  }

  String parseToDateView2(String dateString) {
    String result = '';
    if (dateString != null) {
      String day, month, year;
      String date = dateString.split('T')[0];
      day = date.split('-')[2];
      month = date.split('-')[1];
      year = date.split('-')[0];
      result = '${day} tháng ${month}, năm ${year}';
    }

    return result;
  }

  String parseDateToNotiView(String importedDate) {
    String result = '';
    //imported date
    if (importedDate != '' || importedDate != null) {
      String day, month, year;
      String date = importedDate.split('T')[0];
      day = date.split('-')[2];
      month = date.split('-')[1];
      year = date.split('-')[0];
      String time = importedDate.split('T')[1].split('.')[0];
      String hour = time.split(':')[0];
      String minute = time.split(':')[1];

      //date time now
      String now = DateTime.now().toString().split(' ')[0];
      String dayNow = now.split('-')[2];
      String monthNow = now.split('-')[1];
      String yearNow = now.split('-')[0];

      //executing
      if (day == dayNow && month == monthNow && year == yearNow) {
        result = 'Hôm nay, ${hour}:${minute}';
      } else if (year == yearNow) {
        result = '${hour}:${minute}, ${day}-${month}';
      } else {
        result = '${hour}:${minute}, ${day}-${month}-${year}';
      }
    }
    return result;
  }

  String parseToSumaryDateView(String dateString) {
    String result = '';
    String day, month, year;
    String date = dateString.split('T')[0];
    day = date.split('-')[2];
    month = date.split('-')[1];
    year = date.split('-')[0];
    result = '${day}/${month}';
    return result;
  }

  String parseDateInWeekToView(String value) {
    String result = '';
    if (value == 'Monday') {
      result = 'Thứ hai';
    }
    if (value == 'Tuesday') {
      result = 'Thứ ba';
    }
    if (value == 'Wednesday') {
      result = 'Thứ tư';
    }
    if (value == 'Thursday') {
      result = 'Thứ năm';
    }
    if (value == 'Friday') {
      result = 'Thứ sáu';
    }
    if (value == 'Saturday') {
      result = 'Thứ bảy';
    }
    if (value == 'Sunday') {
      result = 'Chủ nhật';
    }

    return result;
  }

  String getDateTimeView() {
    DateTime _now = DateTime.now();
    DateFormat _format = DateFormat('yyyy-MM-dd-EEEE');
    String _formatted = _format.format(_now);
    String _dateInWeek = parseDateInWeekToView(_formatted.split('-')[3]);
    String _day = _formatted.split('-')[2];
    String _month = _formatted.split('-')[1];
    String _year = _formatted.split('-')[0];
    String _view = '${_dateInWeek}, ngày ${_day} tháng ${_month}, ${_year}';
    return _view;
  }
}
