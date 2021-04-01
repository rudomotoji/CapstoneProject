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

  // int findNumberMostUse(List<int> arr) {
  //   arr.sort();
  //   var arrA = [];
  //   var arrB = [];
  //   var prev;
  //   for (var i = 0; i < arr.length; i++) {
  //     if (arr[i] != prev) {
  //       arrA.add(arr[i]);
  //       arrB.add(1);
  //     } else {
  //       arrB[arrB.length - 1]++;
  //     }
  //     prev = arr[i];
  //   }

  //   return 1;
  // }

  List<int> findNumberMostUse(List<int> arr) {
    List<int> mostPopularValues = [];
    var map = Map();
    arr.forEach((element) {
      if (!map.containsKey(element)) {
        map[element] = 1;
      } else {
        map[element] += 1;
      }
    });
    List sortedValues = map.values.toList()..sort();
    int popularValue = sortedValues.last;
    map.forEach((k, v) {
      if (v == popularValue) {
        // mostPopularValues.add("$k occurs $v time in the list");
        mostPopularValues.add(k);
      }
    });
    return mostPopularValues;
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  String phoneNumberValidator(String value) {
    Pattern pattern = r'^(?:[+84])?[0-9]{10}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'SĐT không đúng với cấu trúc (0123456789)';
    else
      return null;
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }
}
