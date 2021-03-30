class VitalSignScheduleDTO {
  int medicalInstructionId;
  int vitalSignScheduleId;
  int patientAccountId;
  int doctorAccountId;
  String status;
  String dateCreate;
  String dateStarted;
  List<VitalSigns> vitalSigns;

  VitalSignScheduleDTO(
      {this.medicalInstructionId,
      this.vitalSignScheduleId,
      this.patientAccountId,
      this.doctorAccountId,
      this.status,
      this.dateCreate,
      this.dateStarted,
      this.vitalSigns});

  VitalSignScheduleDTO.fromJson(Map<String, dynamic> json) {
    medicalInstructionId = json['medicalInstructionId'];
    vitalSignScheduleId = json['vitalSignScheduleId'];
    patientAccountId = json['patientAccountId'];
    doctorAccountId = json['doctorAccountId'];
    status = json['status'];
    dateCreate = json['dateCreate'];
    dateStarted = json['dateStarted'];
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
    data['vitalSignScheduleId'] = this.vitalSignScheduleId;
    data['patientAccountId'] = this.patientAccountId;
    data['doctorAccountId'] = this.doctorAccountId;
    data['status'] = this.status;
    data['dateCreate'] = this.dateCreate;
    data['dateStarted'] = this.dateStarted;
    if (this.vitalSigns != null) {
      data['vitalSigns'] = this.vitalSigns.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VitalSigns {
  String id;
  int idSchedule;
  int vitalSignScheduleId;
  String vitalSignType;
  int numberMax;
  int numberMin;
  int minuteDangerInterval;
  int minuteNormalInterval;
  String timeStart;
  int minuteAgain;

  VitalSigns(
      {this.id,
      this.idSchedule,
      this.vitalSignScheduleId,
      this.vitalSignType,
      this.numberMax,
      this.numberMin,
      this.minuteDangerInterval,
      this.minuteNormalInterval,
      this.timeStart,
      this.minuteAgain});

  VitalSigns.fromJson(Map<String, dynamic> json) {
    vitalSignType = json['vitalSignType'];
    numberMax = json['numberMax'];
    numberMin = json['numberMin'];
    minuteDangerInterval = json['minuteDangerInterval'];
    minuteNormalInterval = json['minuteNormalInterval'];
    timeStart = json['timeStart'];
    minuteAgain = json['minuteAgain'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vitalSignType'] = this.vitalSignType;
    data['numberMax'] = this.numberMax;
    data['numberMin'] = this.numberMin;
    data['minuteDangerInterval'] = this.minuteDangerInterval;
    data['minuteNormalInterval'] = this.minuteNormalInterval;
    data['timeStart'] = this.timeStart;
    data['minuteAgain'] = this.minuteAgain;
    return data;
  }

  // SQFLITE
  Map<String, dynamic> toMapSQL() {
    var map = <String, dynamic>{
      'id': id,
      'id_schedule': idSchedule,
      'vital_sign_schedule_id': vitalSignScheduleId,
      'vital_sign_type': vitalSignType,
      'number_max': numberMax,
      'number_min': numberMin,
      'minute_danger_interval': minuteDangerInterval,
      'minute_normal_interval': minuteNormalInterval,
      'time_start': timeStart,
      'minute_again': minuteAgain,
    };
    return map;
  }

  VitalSigns.fromMapSQL(Map<String, dynamic> map) {
    id = map['id'];
    idSchedule = map['id_schedule'];
    vitalSignScheduleId = map['vital_sign_schedule_id'];
    vitalSignType = map['vital_sign_type'];
    numberMax = map['number_max'];
    numberMin = map['number_min'];
    minuteDangerInterval = map['minute_danger_interval'];
    minuteNormalInterval = map['minute_normal_interval'];
    timeStart = map['time_start'];
    minuteAgain = map['minute_again'];
  }
}
