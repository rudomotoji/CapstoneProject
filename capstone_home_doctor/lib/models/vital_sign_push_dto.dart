class VitalSignPushDTO {
  int patientId;
  int vitalSignTypeId;
  String timeValue;
  String numberValue;
  String timeStartValue;
  String numberStartValue;

  VitalSignPushDTO(
      {this.patientId,
      this.vitalSignTypeId,
      this.timeValue,
      this.numberValue,
      this.timeStartValue,
      this.numberStartValue});

  VitalSignPushDTO.fromJson(Map<String, dynamic> json) {
    patientId = json['patientId'];
    vitalSignTypeId = json['vitalSignTypeId'];
    timeValue = json['timeValue'];
    numberValue = json['numberValue'];
    timeStartValue = json['timeStartValue'];
    numberStartValue = json['numberStartValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patientId'] = this.patientId;
    data['vitalSignTypeId'] = this.vitalSignTypeId;
    data['timeValue'] = this.timeValue;
    data['numberValue'] = this.numberValue;
    data['timeStartValue'] = this.timeStartValue;
    data['numberStartValue'] = this.numberStartValue;
    return data;
  }
}
