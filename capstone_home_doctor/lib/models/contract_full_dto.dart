class ContractFullDTO {
  int accountDoctorId;
  int doctorId;
  String fullNameDoctor;
  String phoneNumberDoctor;
  String addressDoctor;
  String dobDoctor;
  String workLocationDoctor;
  String experience;
  String specialization;
  int accountPatientId;
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
  double priceLicense;
  int daysOfTracking;
  List<String> diseaseContracts;
  List<MedicalInstructionDiseases> medicalInstructionDiseases;
  List<MedicalInstructionOthers> medicalInstructionOthers;
  List<MedicalInstructionChoosed> medicalInstructionChoosed;
  String dateCreated;
  String dateStarted;
  String dateFinished;

  ContractFullDTO(
      {this.accountDoctorId,
      this.doctorId,
      this.fullNameDoctor,
      this.phoneNumberDoctor,
      this.addressDoctor,
      this.dobDoctor,
      this.workLocationDoctor,
      this.experience,
      this.specialization,
      this.accountPatientId,
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
      this.diseaseContracts,
      this.medicalInstructionDiseases,
      this.medicalInstructionOthers,
      this.medicalInstructionChoosed,
      this.dateCreated,
      this.dateStarted,
      this.dateFinished});

  ContractFullDTO.fromJson(Map<String, dynamic> json) {
    accountDoctorId = json['accountDoctorId'];
    doctorId = json['doctorId'];
    fullNameDoctor = json['fullNameDoctor'];
    phoneNumberDoctor = json['phoneNumberDoctor'];
    addressDoctor = json['addressDoctor'];
    dobDoctor = json['dobDoctor'];
    workLocationDoctor = json['workLocationDoctor'];
    experience = json['experience'];
    specialization = json['specialization'];
    accountPatientId = json['accountPatientId'];
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
    if (json['diseaseContracts'] == null) {
      diseaseContracts = [];
    } else {
      diseaseContracts = json['diseaseContracts'].cast<String>();
    }
    if (json['medicalInstructionDiseases'] != null) {
      medicalInstructionDiseases = new List<MedicalInstructionDiseases>();
      json['medicalInstructionDiseases'].forEach((v) {
        medicalInstructionDiseases
            .add(new MedicalInstructionDiseases.fromJson(v));
      });
    }
    if (json['medicalInstructionOthers'] != null) {
      medicalInstructionOthers = new List<MedicalInstructionOthers>();
      json['medicalInstructionOthers'].forEach((v) {
        medicalInstructionOthers.add(new MedicalInstructionOthers.fromJson(v));
      });
    }
    if (json['medicalInstructionChoosed'] != null) {
      medicalInstructionChoosed = new List<MedicalInstructionChoosed>();
      json['medicalInstructionChoosed'].forEach((v) {
        medicalInstructionChoosed
            .add(new MedicalInstructionChoosed.fromJson(v));
      });
    }
    dateCreated = json['dateCreated'];
    dateStarted = json['dateStarted'];
    dateFinished = json['dateFinished'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accountDoctorId'] = this.accountDoctorId;
    data['doctorId'] = this.doctorId;
    data['fullNameDoctor'] = this.fullNameDoctor;
    data['phoneNumberDoctor'] = this.phoneNumberDoctor;
    data['addressDoctor'] = this.addressDoctor;
    data['dobDoctor'] = this.dobDoctor;
    data['workLocationDoctor'] = this.workLocationDoctor;
    data['experience'] = this.experience;
    data['specialization'] = this.specialization;
    data['accountPatientId'] = this.accountPatientId;
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
    data['diseaseContracts'] = this.diseaseContracts;
    if (this.medicalInstructionDiseases != null) {
      data['medicalInstructionDiseases'] =
          this.medicalInstructionDiseases.map((v) => v.toJson()).toList();
    }
    if (this.medicalInstructionOthers != null) {
      data['medicalInstructionOthers'] =
          this.medicalInstructionOthers.map((v) => v.toJson()).toList();
    }
    if (this.medicalInstructionChoosed != null) {
      data['medicalInstructionChoosed'] =
          this.medicalInstructionChoosed.map((v) => v.toJson()).toList();
    }
    data['dateCreated'] = this.dateCreated;
    data['dateStarted'] = this.dateStarted;
    data['dateFinished'] = this.dateFinished;
    return data;
  }
}

class MedicalInstructionDiseases {
  String diseaseId;
  String nameDisease;
  List<MedicalInstructions> medicalInstructions;

  MedicalInstructionDiseases(
      {this.diseaseId, this.nameDisease, this.medicalInstructions});

  MedicalInstructionDiseases.fromJson(Map<String, dynamic> json) {
    diseaseId = json['diseaseId'];
    nameDisease = json['nameDisease'];
    if (json['medicalInstructions'] != null) {
      medicalInstructions = new List<MedicalInstructions>();
      json['medicalInstructions'].forEach((v) {
        medicalInstructions.add(new MedicalInstructions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diseaseId'] = this.diseaseId;
    data['nameDisease'] = this.nameDisease;
    if (this.medicalInstructions != null) {
      data['medicalInstructions'] =
          this.medicalInstructions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MedicalInstructions {
  int medicalInstructionId;
  String medicalInstructionTypeName;
  List<String> images;
  List<String> diseases;
  String diagnose;
  String description;

  MedicalInstructions(
      {this.medicalInstructionId,
      this.medicalInstructionTypeName,
      this.images,
      this.diseases,
      this.diagnose,
      this.description});

  MedicalInstructions.fromJson(Map<String, dynamic> json) {
    medicalInstructionId = json['medicalInstructionId'];
    medicalInstructionTypeName = json['medicalInstructionTypeName'];
    if (json['images'] == null) {
      diseases = [];
    } else {
      images = json['images'].cast<String>();
    }
    if (json['diseases'] == null) {
      diseases = [];
    } else {
      diseases = json['diseases'].cast<String>();
    }
    diagnose = json['diagnose'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicalInstructionId'] = this.medicalInstructionId;
    data['medicalInstructionTypeName'] = this.medicalInstructionTypeName;
    data['images'] = this.images;
    data['diseases'] = this.diseases;
    data['diagnose'] = this.diagnose;
    data['description'] = this.description;
    return data;
  }
}

class MedicalInstructionOthers {
  int medicalInstructionId;
  String medicalInstructionTypeName;
  List<String> images;
  List<String> diseases;
  String diagnose;
  String description;

  MedicalInstructionOthers(
      {this.medicalInstructionId,
      this.medicalInstructionTypeName,
      this.images,
      this.diseases,
      this.diagnose,
      this.description});

  MedicalInstructionOthers.fromJson(Map<String, dynamic> json) {
    medicalInstructionId = json['medicalInstructionId'];
    medicalInstructionTypeName = json['medicalInstructionTypeName'];
    if (json['images'] == null) {
      diseases = [];
    } else {
      images = json['images'].cast<String>();
    }

    if (json['diseases'] == null) {
      diseases = [];
    } else {
      diseases = json['diseases'].cast<String>();
    }
    diagnose = json['diagnose'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicalInstructionId'] = this.medicalInstructionId;
    data['medicalInstructionTypeName'] = this.medicalInstructionTypeName;
    data['images'] = this.images;
    data['diseases'] = this.diseases;
    data['diagnose'] = this.diagnose;
    data['description'] = this.description;
    return data;
  }
}

class MedicalInstructionChoosed {
  int medicalInstructionId;
  String medicalInstructionTypeName;
  List<String> images;
  List<String> diseases;
  String diagnose;
  String description;

  MedicalInstructionChoosed(
      {this.medicalInstructionId,
      this.medicalInstructionTypeName,
      this.images,
      this.diseases,
      this.diagnose,
      this.description});

  MedicalInstructionChoosed.fromJson(Map<String, dynamic> json) {
    medicalInstructionId = json['medicalInstructionId'];
    medicalInstructionTypeName = json['medicalInstructionTypeName'];
    if (json['images'] == null) {
      diseases = [];
    } else {
      images = json['images'].cast<String>();
    }
    if (json['diseases'] == null) {
      diseases = [];
    } else {
      diseases = json['diseases'].cast<String>();
    }

    diagnose = json['diagnose'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicalInstructionId'] = this.medicalInstructionId;
    data['medicalInstructionTypeName'] = this.medicalInstructionTypeName;
    data['images'] = this.images;
    data['diseases'] = this.diseases;
    data['diagnose'] = this.diagnose;
    data['description'] = this.description;
    return data;
  }
}
