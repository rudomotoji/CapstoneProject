class RelativeDTO {
  String fullName;
  String phoneNumber;

  RelativeDTO({this.fullName, this.phoneNumber});

  RelativeDTO.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}

class RelativeRegisterDTO {
  String fullName;
  String phoneNumber;

  RelativeRegisterDTO({this.fullName, this.phoneNumber});

  RelativeRegisterDTO.fromJson(Map<String, dynamic> json) {
    fullName = json['fullNameRelative'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullNameRelative'] = this.fullName;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}
