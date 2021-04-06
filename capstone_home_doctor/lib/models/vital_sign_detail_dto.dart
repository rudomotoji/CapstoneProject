class VitalSignDetailDTO {
  String vitalSignValueDateCreated;
  List<VitalSigns> vitalSigns;
  List<VitalSignValues> vitalSignValues;

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
    if (json['vitalSignValues'] != null) {
      vitalSignValues = new List<VitalSignValues>();
      json['vitalSignValues'].forEach((v) {
        vitalSignValues.add(new VitalSignValues.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vitalSignValueDateCreated'] = this.vitalSignValueDateCreated;
    if (this.vitalSigns != null) {
      data['vitalSigns'] = this.vitalSigns.map((v) => v.toJson()).toList();
    }
    if (this.vitalSignValues != null) {
      data['vitalSignValues'] =
          this.vitalSignValues.map((v) => v.toJson()).toList();
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
  int vitalSignTypeId;
  String dateCreated;
  String timeValue;
  String numberValue;

  VitalSignValues(
      {this.vitalSignTypeId,
      this.dateCreated,
      this.timeValue,
      this.numberValue});

  VitalSignValues.fromJson(Map<String, dynamic> json) {
    vitalSignTypeId = json['vitalSignTypeId'];
    dateCreated = json['dateCreated'];
    timeValue = json['timeValue'];
    numberValue = json['numberValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vitalSignTypeId'] = this.vitalSignTypeId;
    data['dateCreated'] = this.dateCreated;
    data['timeValue'] = this.timeValue;
    data['numberValue'] = this.numberValue;
    return data;
  }
}
