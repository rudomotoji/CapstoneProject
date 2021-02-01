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
}
