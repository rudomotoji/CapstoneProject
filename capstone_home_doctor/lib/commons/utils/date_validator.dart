import 'package:intl/intl.dart';

class DateValidator {
  DateValidator();

  String parseToDateView(String dateString) {
    String result = '';
    String day, month, year;
    String date = dateString.split('T')[0];
    if (!dateString.contains('T')) {
      return result;
    }
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

  String parseToDateView3(String dateString) {
    String result = '';
    if (dateString == '') {
      return dateString;
    }
    String day, month, year;
    String date = dateString.split(' ')[0];
    day = date.split('-')[2];
    month = date.split('-')[1];
    year = date.split('-')[0];
    result = '${day} tháng ${month}, ${year}';
    return result;
  }

  String parseToDateView4(String dateString) {
    String result = '';
    String day, month, year;
    if (dateString != null) {
      day = dateString.split('/')[0];
      month = dateString.split('/')[1];
      year = dateString.split('/')[2];
      result = '${day} tháng ${month}, ${year}';
    } else {
      result = dateString;
    }

    return result;
  }

  String getHourAndMinute(String dateString) {
    String result = '';
    if (dateString.contains(' ')) {
      String hour, minute;
      String date = dateString.split(' ')[1];
      String time = date.split('.')[0];
      hour = time.split(':')[0];
      minute = time.split(':')[1];
      result = hour + ':' + minute;
    }
    return result;
  }

  String getHourAndMinute2(String dateString) {
    String result = '';
    if (dateString.contains('T')) {
      String hour, minute;
      String date = dateString.split('T')[1];
      String time = date.split('.')[0];
      hour = time.split(':')[0];
      minute = time.split(':')[1];
      result = hour + ':' + minute;
    }
    return result;
  }

  String getDateAndTime(String input) {
    String result = '';
    if (input != null && input != '') {
      String date = input.split(' ')[0];
      String time = input.split(' ')[1];
      result = date.split('-')[2] +
          ' tháng ' +
          date.split('-')[1] +
          ', ' +
          date.split('-')[0];
    }
    return result;
  }

  DateTime parseStringToDateApnt(String date) {
    int year = int.tryParse(date.split('/')[2]);
    int month = int.tryParse(date.split('/')[1]);
    int day = int.tryParse(date.split('/')[0]);
    return new DateTime(year, month, day);
  }

  // String parseDateToNotiView(String importedDate) {
  //   String result = '';
  //   //imported date
  //   if (importedDate != '' || importedDate != null) {
  //     String day, month, year;
  //     String date = importedDate.split('T')[0];
  //     day = date.split('-')[2];
  //     month = date.split('-')[1];
  //     year = date.split('-')[0];
  //     String time = importedDate.split('T')[1].split('.')[0];
  //     String hour = time.split(':')[0];
  //     String minute = time.split(':')[1];

  //     //date time now
  //     String now = DateTime.now().toString().split(' ')[0];
  //     String dayNow = now.split('-')[2];
  //     String monthNow = now.split('-')[1];
  //     String yearNow = now.split('-')[0];

  //     //executing
  //     if (day == dayNow && month == monthNow && year == yearNow) {
  //       result = 'Hôm nay, ${hour}:${minute}';
  //     } else if (year == yearNow) {
  //       result = '${hour}:${minute}, ${day}-${month}';
  //     } else {
  //       result = '${hour}:${minute}, ${day}-${month}-${year}';
  //     }
  //   }
  //   return result;
  // }

  String parseDateToNotiView(String importedDate) {
    String result = '';
    String compareYear = importedDate.split('/')[2];
    String compareMonth = importedDate.split('/')[1];
    String compareDate = importedDate.split('/')[0].split(', ')[1];
    String dateInWeek = importedDate.split('/')[0].split(', ')[0];
    //FOR DATE TIME NOW
    String now = DateTime.now().toString().split(' ')[0];
    String dateNow = now.split('-')[2];
    String monthNow = now.split('-')[1];
    String yearNow = now.split('-')[0];

    //FOR YESTERDAY
    String yesterday =
        DateTime.now().add(Duration(days: -1)).toString().split(' ')[0];
    String dateYesterday = now.split('-')[2];
    String monthYesterday = now.split('-')[1];
    String yearYesterday = now.split('-')[0];

    if (compareYear == yearNow &&
        compareMonth == monthNow &&
        compareDate == dateNow) {
      result = 'Hôm nay';
    } else if (compareYear == yearYesterday &&
        compareMonth == monthYesterday &&
        compareDate == dateYesterday) {
      result = 'Hôm qua';
    } else {
      String tempDW = '';
      print('dateInWeek:$dateInWeek');
      if (dateInWeek == 'Monday') {
        tempDW = 'Thứ hai';
      } else if (dateInWeek.contains('Tuesday')) {
        tempDW = 'Thứ ba';
      } else if (dateInWeek.contains('Wednesday')) {
        tempDW = 'Thứ tư';
      } else if (dateInWeek.contains('Thursday')) {
        tempDW = 'Thứ năm';
      } else if (dateInWeek.contains('Friday')) {
        tempDW = 'Thứ sáu';
      } else if (dateInWeek.contains('Saturday')) {
        tempDW = 'Thứ bảy';
      } else if (dateInWeek.contains('Sunday')) {
        tempDW = 'Chủ nhật';
      }
      result = tempDW +
          ', ' +
          compareDate +
          ' tháng ' +
          compareMonth +
          ', năm ' +
          compareYear;
    }
    return result;
  }

  String renderLastTimeNoti(double timeAgo) {
    String result = '';
    //
    double value = timeAgo;
    int minutes = value.toInt();
    if (minutes <= 1 && minutes > 0) {
      result = 'vài giây trước';
    } else if (minutes <= 0) {
      result = '';
    } else if (minutes < 60 && minutes > 1) {
      result = '${minutes} phút trước';
    } else if (minutes <= 1440 && minutes >= 60) {
      //
      var time = minutes / 60;
      int r = time.toInt();

      result = '${r} tiếng trước';
    } else if (minutes > 1440 && minutes <= 10080) {
      //
      var time = minutes / 1440;
      int r = time.toInt();
      result = '${r} ngày trước';
    } else {
      var time = minutes / 10080;
      int r = time.toInt();
      result = '${r} tuần';
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
    } else if (value == 'Tuesday') {
      result = 'Thứ ba';
    } else if (value == 'Wednesday') {
      result = 'Thứ tư';
    } else if (value == 'Thursday') {
      result = 'Thứ năm';
    } else if (value == 'Friday') {
      result = 'Thứ sáu';
    } else if (value.contains('Saturday')) {
      result = 'Thứ bảy';
    } else if (value == 'Sunday') {
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
    String _view = '${_dateInWeek}, ${_day} tháng ${_month}, ${_year}';
    return _view;
  }

  String getDateTimeView2(String timeSystem) {
    String result = '';
    if (timeSystem != null && timeSystem != '') {
      DateFormat _format = DateFormat('yyyy-MM-dd-EEEE');
      String _formatted = _format.format(
          DateTime.parse(timeSystem.split('"')[1].split('"')[0].split('T')[0]));
      String _dateInWeek = parseDateInWeekToView(_formatted.split('-')[3]);
      String _day = _formatted.split('-')[2];
      String _month = _formatted.split('-')[1];
      String _year = _formatted.split('-')[0];
      String _view = '${_dateInWeek}, ${_day} tháng ${_month}, ${_year}';
      result = _view;
    }
    return result;
  }

  String convertDateCreate(String date, String formatTo, String formatFrom) {
    DateTime timeEx = new DateFormat(formatFrom).parse(date);
    return new DateFormat(formatTo).format(timeEx);
  }
}
