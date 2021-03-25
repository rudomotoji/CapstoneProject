class VitalSignScheduleDTO {
  int healthRecordId;
  int doctorAccountId;
  int contractId;
  String diagnose;
  String dateStart;
  String dateFinish;
  String description;
  List<VitalSigns> vitalSigns;

  VitalSignScheduleDTO(
      {this.healthRecordId,
      this.doctorAccountId,
      this.contractId,
      this.diagnose,
      this.dateStart,
      this.dateFinish,
      this.description,
      this.vitalSigns});

  VitalSignScheduleDTO.fromJson(Map<String, dynamic> json) {
    healthRecordId = json['healthRecordId'];
    doctorAccountId = json['doctorAccountId'];
    contractId = json['contractId'];
    diagnose = json['diagnose'];
    dateStart = json['dateStart'];
    dateFinish = json['dateFinish'];
    description = json['description'];
    if (json['vitalSigns'] != null) {
      vitalSigns = new List<VitalSigns>();
      json['vitalSigns'].forEach((v) {
        vitalSigns.add(new VitalSigns.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['healthRecordId'] = this.healthRecordId;
    data['doctorAccountId'] = this.doctorAccountId;
    data['contractId'] = this.contractId;
    data['diagnose'] = this.diagnose;
    data['dateStart'] = this.dateStart;
    data['dateFinish'] = this.dateFinish;
    data['description'] = this.description;
    if (this.vitalSigns != null) {
      data['vitalSigns'] = this.vitalSigns.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VitalSigns {
  int vitalSignTypeId;
  int numberMax;
  int numberMin;
  int minuteDangerInterval;
  String timeStart;
  int minuteAgain;

  VitalSigns(
      {this.vitalSignTypeId,
      this.numberMax,
      this.numberMin,
      this.minuteDangerInterval,
      this.timeStart,
      this.minuteAgain});

  VitalSigns.fromJson(Map<String, dynamic> json) {
    vitalSignTypeId = json['vitalSignTypeId'];
    numberMax = json['numberMax'];
    numberMin = json['numberMin'];
    minuteDangerInterval = json['minuteDangerInterval'];
    timeStart = json['timeStart'];
    minuteAgain = json['minuteAgain'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vitalSignTypeId'] = this.vitalSignTypeId;
    data['numberMax'] = this.numberMax;
    data['numberMin'] = this.numberMin;
    data['minuteDangerInterval'] = this.minuteDangerInterval;
    data['timeStart'] = this.timeStart;
    data['minuteAgain'] = this.minuteAgain;
    return data;
  }
}
