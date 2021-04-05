class ContractFullDTO {
  int doctorId;
  String fullNameDoctor;
  String phoneNumberDoctor;
  String addressDoctor;
  String dobDoctor;
  String workLocationDoctor;
  String experience;
  String specialization;
  int patientId;
  String fullNamePatient;
  String phoneNumberPatient;
  String addressPatient;
  String genderPatient;
  String dobPatient;
  String contractCode;
  String note;
  String status;
  String nameLicense;
  int priceLicense;
  int daysOfTracking;
  List<Diseases> diseases;
  List<MedicalInstructionTypes> medicalInstructionTypes;
  String dateCreated;
  String dateStarted;
  String dateFinished;

  ContractFullDTO(
      {this.doctorId,
      this.fullNameDoctor,
      this.phoneNumberDoctor,
      this.addressDoctor,
      this.dobDoctor,
      this.workLocationDoctor,
      this.experience,
      this.specialization,
      this.patientId,
      this.fullNamePatient,
      this.phoneNumberPatient,
      this.addressPatient,
      this.genderPatient,
      this.dobPatient,
      this.contractCode,
      this.note,
      this.status,
      this.nameLicense,
      this.priceLicense,
      this.daysOfTracking,
      this.diseases,
      this.medicalInstructionTypes,
      this.dateCreated,
      this.dateStarted,
      this.dateFinished});

  ContractFullDTO.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctorId'];
    fullNameDoctor = json['fullNameDoctor'];
    phoneNumberDoctor = json['phoneNumberDoctor'];
    addressDoctor = json['addressDoctor'];
    dobDoctor = json['dobDoctor'];
    workLocationDoctor = json['workLocationDoctor'];
    experience = json['experience'];
    specialization = json['specialization'];
    patientId = json['patientId'];
    fullNamePatient = json['fullNamePatient'];
    phoneNumberPatient = json['phoneNumberPatient'];
    addressPatient = json['addressPatient'];
    genderPatient = json['genderPatient'];
    dobPatient = json['dobPatient'];
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
    if (json['medicalInstructionTypes'] != null) {
      medicalInstructionTypes = new List<MedicalInstructionTypes>();
      json['medicalInstructionTypes'].forEach((v) {
        medicalInstructionTypes.add(new MedicalInstructionTypes.fromJson(v));
      });
    }
    dateCreated = json['dateCreated'];
    dateStarted = json['dateStarted'];
    dateFinished = json['dateFinished'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctorId'] = this.doctorId;
    data['fullNameDoctor'] = this.fullNameDoctor;
    data['phoneNumberDoctor'] = this.phoneNumberDoctor;
    data['addressDoctor'] = this.addressDoctor;
    data['dobDoctor'] = this.dobDoctor;
    data['workLocationDoctor'] = this.workLocationDoctor;
    data['experience'] = this.experience;
    data['specialization'] = this.specialization;
    data['patientId'] = this.patientId;
    data['fullNamePatient'] = this.fullNamePatient;
    data['phoneNumberPatient'] = this.phoneNumberPatient;
    data['addressPatient'] = this.addressPatient;
    data['genderPatient'] = this.genderPatient;
    data['dobPatient'] = this.dobPatient;
    data['contractCode'] = this.contractCode;
    data['note'] = this.note;
    data['status'] = this.status;
    data['nameLicense'] = this.nameLicense;
    data['priceLicense'] = this.priceLicense;
    data['daysOfTracking'] = this.daysOfTracking;
    if (this.diseases != null) {
      data['diseases'] = this.diseases.map((v) => v.toJson()).toList();
    }
    if (this.medicalInstructionTypes != null) {
      data['medicalInstructionTypes'] =
          this.medicalInstructionTypes.map((v) => v.toJson()).toList();
    }
    data['dateCreated'] = this.dateCreated;
    data['dateStarted'] = this.dateStarted;
    data['dateFinished'] = this.dateFinished;
    return data;
  }
}

class Diseases {
  String diseaseId;
  String nameDisease;

  Diseases({this.diseaseId, this.nameDisease});

  Diseases.fromJson(Map<String, dynamic> json) {
    diseaseId = json['diseaseId'];
    nameDisease = json['nameDisease'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diseaseId'] = this.diseaseId;
    data['nameDisease'] = this.nameDisease;
    return data;
  }
}

class MedicalInstructionTypes {
  String medicalInstructionTypeName;
  List<MedicalInstructions> medicalInstructions;

  MedicalInstructionTypes(
      {this.medicalInstructionTypeName, this.medicalInstructions});

  MedicalInstructionTypes.fromJson(Map<String, dynamic> json) {
    medicalInstructionTypeName = json['medicalInstructionTypeName'];
    if (json['medicalInstructions'] != null) {
      medicalInstructions = new List<MedicalInstructions>();
      json['medicalInstructions'].forEach((v) {
        medicalInstructions.add(new MedicalInstructions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicalInstructionTypeName'] = this.medicalInstructionTypeName;
    if (this.medicalInstructions != null) {
      data['medicalInstructions'] =
          this.medicalInstructions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MedicalInstructions {
  String image;
  String diagnose;
  String description;
  int medicalInstructionId;

  MedicalInstructions({
    this.image,
    this.diagnose,
    this.description,
    this.medicalInstructionId,
  });

  MedicalInstructions.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    diagnose = json['diagnose'];
    description = json['description'];
    medicalInstructionId = json['medicalInstructionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['diagnose'] = this.diagnose;
    data['description'] = this.description;
    data['medicalInstructionId'] = this.medicalInstructionId;
    return data;
  }
}
