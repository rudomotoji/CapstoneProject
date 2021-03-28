class VitalSignScheduleDTO {
  int medicalInstructionId;
  String status;
  String dateCreate;
  String dateStarted;
  String dateFinished;
  List<VitalSigns> vitalSigns;

  VitalSignScheduleDTO(
      {this.medicalInstructionId,
      this.status,
      this.dateCreate,
      this.dateStarted,
      this.dateFinished,
      this.vitalSigns});

  VitalSignScheduleDTO.fromJson(Map<String, dynamic> json) {
    medicalInstructionId = json['medicalInstructionId'];
    status = json['status'];
    dateCreate = json['dateCreate'];
    dateStarted = json['dateStarted'];
    dateFinished = json['dateFinished'];
    if (json['vitalSigns'] != null) {
      vitalSigns = new List<VitalSigns>();
      json['vitalSigns'].forEach((v) {
        vitalSigns.add(new VitalSigns.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicalInstructionId'] = this.medicalInstructionId;
    data['status'] = this.status;
    data['dateCreate'] = this.dateCreate;
    data['dateStarted'] = this.dateStarted;
    data['dateFinished'] = this.dateFinished;
    if (this.vitalSigns != null) {
      data['vitalSigns'] = this.vitalSigns.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VitalSigns {
  String vitalSignType;
  int numberMax;
  int numberMin;
  int minuteDangerInterval;
  String timeStart;
  int minuteAgain;

  VitalSigns(
      {this.vitalSignType,
      this.numberMax,
      this.numberMin,
      this.minuteDangerInterval,
      this.timeStart,
      this.minuteAgain});

  VitalSigns.fromJson(Map<String, dynamic> json) {
    vitalSignType = json['vitalSignType'];
    numberMax = json['numberMax'];
    numberMin = json['numberMin'];
    minuteDangerInterval = json['minuteDangerInterval'];
    timeStart = json['timeStart'];
    minuteAgain = json['minuteAgain'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vitalSignType'] = this.vitalSignType;
    data['numberMax'] = this.numberMax;
    data['numberMin'] = this.numberMin;
    data['minuteDangerInterval'] = this.minuteDangerInterval;
    data['timeStart'] = this.timeStart;
    data['minuteAgain'] = this.minuteAgain;
    return data;
  }
}
