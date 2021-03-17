class DiseaseDTO {
  String diseaseId;
  String name;
  String status;
  String code;
  int number;
  int start;
  int end;
  Null contracts;
  Null healthRecords;

  DiseaseDTO(
      {this.diseaseId,
      this.code,
      this.number,
      this.start,
      this.end,
      this.name,
      this.contracts,
      this.healthRecords});

  @override
  String toString() {
    return '${diseaseId}: ${name}';
  }

  DiseaseDTO.fromJson(Map<String, dynamic> json) {
    diseaseId = json['diseaseId'];
    code = json['code'];
    number = json['number'];
    start = json['start'];
    end = json['end'];
    name = json['name'];
    contracts = json['contracts'];
    healthRecords = json['healthRecords'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diseaseId'] = this.diseaseId;
    data['code'] = this.code;
    data['number'] = this.number;
    data['start'] = this.start;
    data['end'] = this.end;
    data['name'] = this.name;
    data['contracts'] = this.contracts;
    data['healthRecords'] = this.healthRecords;
    return data;
  }

  String get getDiseaseId => diseaseId;
}

//heart disease
class DiseaseHeartDTO {
  String diseaseId;
  String name;

  DiseaseHeartDTO({this.diseaseId, this.name});

  @override
  String toString() {
    return '${diseaseId}: ${name}';
  }

  DiseaseHeartDTO.fromJson(Map<String, dynamic> json) {
    diseaseId = json['diseaseId'];
    name = json['nameDisease'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diseaseId'] = this.diseaseId;
    data['nameDisease'] = this.name;
    return data;
  }

  String get getDiseaseId => diseaseId;
}
