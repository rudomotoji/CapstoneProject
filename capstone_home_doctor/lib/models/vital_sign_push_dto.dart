class VitalSignPushDTO {
  int patientId;
  int vitalSignTypeId;
  String timeValue;
  String numberValue;

  VitalSignPushDTO(
      {this.patientId, this.vitalSignTypeId, this.timeValue, this.numberValue});

  VitalSignPushDTO.fromJson(Map<String, dynamic> json) {
    patientId = json['patientId'];
    vitalSignTypeId = json['vitalSignTypeId'];
    timeValue = json['timeValue'];
    numberValue = json['numberValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patientId'] = this.patientId;
    data['vitalSignTypeId'] = this.vitalSignTypeId;
    data['timeValue'] = this.timeValue;
    data['numberValue'] = this.numberValue;
    return data;
  }
}
