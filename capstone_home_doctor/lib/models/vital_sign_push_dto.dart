class VitalSignPushDTO {
  int vitalSignScheduleId;
  int vitalSignTypeId;
  String currentDate;
  String timeValue;
  String numberValue;

  VitalSignPushDTO(
      {this.vitalSignScheduleId,
      this.vitalSignTypeId,
      this.currentDate,
      this.timeValue,
      this.numberValue});

  VitalSignPushDTO.fromJson(Map<String, dynamic> json) {
    vitalSignScheduleId = json['vitalSignScheduleId'];
    vitalSignTypeId = json['vitalSignTypeId'];
    currentDate = json['currentDate'];
    timeValue = json['timeValue'];
    numberValue = json['numberValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vitalSignScheduleId'] = this.vitalSignScheduleId;
    data['vitalSignTypeId'] = this.vitalSignTypeId;
    data['currentDate'] = this.currentDate;
    data['timeValue'] = this.timeValue;
    data['numberValue'] = this.numberValue;
    return data;
  }
}
