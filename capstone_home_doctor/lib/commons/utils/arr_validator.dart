class ArrayValidator {
  ArrayValidator();

  String parseArrToView(String arr) {
    String _first = '';
    String _last = '';
    String _component = '';

    _first = arr.split('[')[1];
    _last = _first.split(']')[0];
    for (int i = 0; i < _last.split(',').length; i++) {
      _component += '${_last.split(',')[i]}\n';
    }
    return _component;
  }

  String parsePhoneToView(String phone) {
    if (!phone.contains('.')) {
      return phone;
    }
    String result = '';
    for (String component in phone.split('.')) {
      result += component + ' ';
    }
    return result.trim();
  }
}
