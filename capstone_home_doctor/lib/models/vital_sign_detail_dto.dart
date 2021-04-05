class VitalSignDetailDTO {
  String vitalSignValueDateCreated;
  List<VitalSigns> vitalSigns;
  VitalSignValues vitalSignValues;

  VitalSignDetailDTO(
      {this.vitalSignValueDateCreated, this.vitalSigns, this.vitalSignValues});

  VitalSignDetailDTO.fromJson(Map<String, dynamic> json) {
    vitalSignValueDateCreated = json['vitalSignValueDateCreated'];
    if (json['vitalSigns'] != null) {
      vitalSigns = new List<VitalSigns>();
      json['vitalSigns'].forEach((v) {
        vitalSigns.add(new VitalSigns.fromJson(v));
      });
    }
    vitalSignValues = json['vitalSignValues'] != null
        ? new VitalSignValues.fromJson(json['vitalSignValues'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vitalSignValueDateCreated'] = this.vitalSignValueDateCreated;
    if (this.vitalSigns != null) {
      data['vitalSigns'] = this.vitalSigns.map((v) => v.toJson()).toList();
    }
    if (this.vitalSignValues != null) {
      data['vitalSignValues'] = this.vitalSignValues.toJson();
    }
    return data;
  }
}

class VitalSigns {
  String vitalSignType;
  int vitalSignTypeId;
  int numberMax;
  int numberMin;
  int minuteDangerInterval;
  int minuteNormalInterval;
  String timeStart;
  int minuteAgain;

  VitalSigns(
      {this.vitalSignType,
      this.vitalSignTypeId,
      this.numberMax,
      this.numberMin,
      this.minuteDangerInterval,
      this.minuteNormalInterval,
      this.timeStart,
      this.minuteAgain});

  VitalSigns.fromJson(Map<String, dynamic> json) {
    vitalSignType = json['vitalSignType'];
    vitalSignTypeId = json['vitalSignTypeId'];
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
    data['vitalSignTypeId'] = this.vitalSignTypeId;
    data['numberMax'] = this.numberMax;
    data['numberMin'] = this.numberMin;
    data['minuteDangerInterval'] = this.minuteDangerInterval;
    data['minuteNormalInterval'] = this.minuteNormalInterval;
    data['timeStart'] = this.timeStart;
    data['minuteAgain'] = this.minuteAgain;
    return data;
  }
}

class VitalSignValues {
  String dateCreated;
  String heartBeatTimeValue;
  String heartBeatNumberValue;
  String bloodPressureTimeValue;
  String bloodPressureNumberValue;

  VitalSignValues(
      {this.dateCreated,
      this.heartBeatTimeValue,
      this.heartBeatNumberValue,
      this.bloodPressureTimeValue,
      this.bloodPressureNumberValue});

  VitalSignValues.fromJson(Map<String, dynamic> json) {
    dateCreated = json['dateCreated'];
    heartBeatTimeValue = json['heartBeatTimeValue'];
    heartBeatNumberValue = json['heartBeatNumberValue'];
    bloodPressureTimeValue = json['bloodPressureTimeValue'];
    bloodPressureNumberValue = json['bloodPressureNumberValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateCreated'] = this.dateCreated;
    data['heartBeatTimeValue'] = this.heartBeatTimeValue;
    data['heartBeatNumberValue'] = this.heartBeatNumberValue;
    data['bloodPressureTimeValue'] = this.bloodPressureTimeValue;
    data['bloodPressureNumberValue'] = this.bloodPressureNumberValue;
    return data;
  }
}
