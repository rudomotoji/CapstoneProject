class MedicalShareDTO {
  String healthRecordPlace;
  String dateCreated;

  List<String> diseases;
  List<MedicalInstructions> medicalInstructions;

  MedicalShareDTO(
      {this.healthRecordPlace,
      this.dateCreated,
      this.diseases,
      this.medicalInstructions});

  MedicalShareDTO.fromJson(Map<String, dynamic> json) {
    healthRecordPlace = json['healthRecordPlace'];
    dateCreated = json['dateCreated'];

    diseases = json['diseases'].cast<String>();
    if (json['medicalInstructions'] != null) {
      medicalInstructions = new List<MedicalInstructions>();
      json['medicalInstructions'].forEach((v) {
        medicalInstructions.add(new MedicalInstructions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['healthRecordPlace'] = this.healthRecordPlace;
    data['dateCreated'] = this.dateCreated;

    data['diseases'] = this.diseases;
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

  String disease;
  List<String> images;
  String dateTreatment;
  String conclusion;

  MedicalInstructions(
      {this.medicalInstructionId,
      this.medicalInstructionTypeName,
      this.disease,
      this.images,
      this.dateTreatment,
      this.conclusion});

  MedicalInstructions.fromJson(Map<String, dynamic> json) {
    medicalInstructionId = json['medicalInstructionId'];
    disease = json['disease'];
    // if (json['diseases'] == null) {
    //   diseases = [];
    // } else {
    //   diseases = json['diseases'].cast<String>();
    // }

    images = json['images'].cast<String>();
    dateTreatment = json['dateTreatment'];
    conclusion = json['conclusion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicalInstructionId'] = this.medicalInstructionId;
    data['disease'] = this.disease;
    data['images'] = this.images;
    data['dateTreatment'] = this.dateTreatment;
    data['conclusion'] = this.conclusion;
    return data;
  }
}
