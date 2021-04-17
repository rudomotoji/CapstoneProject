class ContractListDTO {
  int contractId;
  String fullNameDoctor;
  String phoneNumberDoctor;
  String fullNamePatient;
  String phoneNumberPatient;
  String contractCode;
  String note;
  String status;
  String nameLicense;
  double priceLicense;
  int daysOfTracking;
  List<Diseases> diseases;
  String dateCreated;
  String dateStarted;
  String dateFinished;

  ContractListDTO(
      {this.contractId,
      this.fullNameDoctor,
      this.phoneNumberDoctor,
      this.fullNamePatient,
      this.phoneNumberPatient,
      this.contractCode,
      this.note,
      this.status,
      this.nameLicense,
      this.priceLicense,
      this.daysOfTracking,
      this.diseases,
      this.dateCreated,
      this.dateStarted,
      this.dateFinished});

  ContractListDTO.fromJson(Map<String, dynamic> json) {
    contractId = json['contractId'];
    fullNameDoctor = json['fullNameDoctor'];
    phoneNumberDoctor = json['phoneNumberDoctor'];
    fullNamePatient = json['fullNamePatient'];
    phoneNumberPatient = json['phoneNumberPatient'];
    contractCode = json['contractCode'];
    note = json['note'];
    status = json['status'];
    nameLicense = json['nameLicense'];
    priceLicense = json['priceLicense'];
    daysOfTracking = json['daysOfTracking'];
    if (json['diseases'] != null) {
      diseases = new List<Diseases>();
      json['diseases'].forEach((v) {
        diseases.add(new Diseases.fromJson(v));
      });
    }
    dateCreated = json['dateCreated'];
    dateStarted = json['dateStarted'];
    dateFinished = json['dateFinished'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contractId'] = this.contractId;
    data['fullNameDoctor'] = this.fullNameDoctor;
    data['phoneNumberDoctor'] = this.phoneNumberDoctor;
    data['fullNamePatient'] = this.fullNamePatient;
    data['phoneNumberPatient'] = this.phoneNumberPatient;
    data['contractCode'] = this.contractCode;
    data['note'] = this.note;
    data['status'] = this.status;
    data['nameLicense'] = this.nameLicense;
    data['priceLicense'] = this.priceLicense;
    data['daysOfTracking'] = this.daysOfTracking;
    if (this.diseases != null) {
      data['diseases'] = this.diseases.map((v) => v.toJson()).toList();
    }
    data['dateCreated'] = this.dateCreated;
    data['dateStarted'] = this.dateStarted;
    data['dateFinished'] = this.dateFinished;
    return data;
  }
}

class Diseases {
  String diseaseId;
  String name;

  Diseases({this.diseaseId, this.name});

  Diseases.fromJson(Map<String, dynamic> json) {
    diseaseId = json['diseaseId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diseaseId'] = this.diseaseId;
    data['name'] = this.name;
    return data;
  }
}
