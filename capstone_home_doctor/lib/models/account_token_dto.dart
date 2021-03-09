class AccountTokenDTO {
  String accountId;
  String patientId;
  int exp;
  String iss;
  String aud;

  AccountTokenDTO(
      {this.accountId, this.patientId, this.exp, this.iss, this.aud});

  AccountTokenDTO.fromJson(Map<String, dynamic> json) {
    accountId = json['accountId'];
    patientId = json['patientId'];
    exp = json['exp'];
    iss = json['iss'];
    aud = json['aud'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accountId'] = this.accountId;
    data['patientId'] = this.patientId;
    data['exp'] = this.exp;
    data['iss'] = this.iss;
    data['aud'] = this.aud;
    return data;
  }
}