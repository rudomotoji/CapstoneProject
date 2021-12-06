class TokenDeviceDTO {
  int accountId;
  String tokenDevice;

  TokenDeviceDTO({this.accountId, this.tokenDevice});

  TokenDeviceDTO.fromJson(Map<String, dynamic> json) {
    accountId = json['accountId'];
    tokenDevice = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accountId'] = this.accountId;
    data['token'] = this.tokenDevice;
    return data;
  }
}
