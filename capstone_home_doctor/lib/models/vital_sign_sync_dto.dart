class VitalSignSyncDTO {
  String vitalSignValueDateCreated;
  Null vitalSigns;
  List<VitalSignValues> vitalSignValues;

  VitalSignSyncDTO(
      {this.vitalSignValueDateCreated, this.vitalSigns, this.vitalSignValues});

  VitalSignSyncDTO.fromJson(Map<String, dynamic> json) {
    vitalSignValueDateCreated = json['vitalSignValueDateCreated'];
    vitalSigns = json['vitalSigns'];
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
    data['vitalSigns'] = this.vitalSigns;
    if (this.vitalSignValues != null) {
      data['vitalSignValues'] =
          this.vitalSignValues.map((v) => v.toJson()).toList();
    }
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