class DiseaseDTO {
  String diseaseId;
  String name;
  String status;

  DiseaseDTO({this.diseaseId, this.name, this.status});

  @override
  String toString() {
    return '${diseaseId}: ${name}';
  }

  DiseaseDTO.fromJson(Map<String, dynamic> json) {
    diseaseId = json['diseaseId'];
    name = json['name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diseaseId'] = this.diseaseId;
    data['name'] = this.name;
    data['status'] = this.status;
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
