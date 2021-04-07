class MedicalShareDTO {
  String healthRecordPlace;
  String dateCreate;
  List<String> diseases;
  List<MedicalInstructions> medicalInstructions;

  MedicalShareDTO(
      {this.healthRecordPlace,
      this.dateCreate,
      this.diseases,
      this.medicalInstructions});

  MedicalShareDTO.fromJson(Map<String, dynamic> json) {
    healthRecordPlace = json['healthRecordPlace'];
    dateCreate = json['dateCreate'];
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
    data['dateCreate'] = this.dateCreate;
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
  List<String> images;
  String dateCreate;
  String diagnose;

  MedicalInstructions(
      {this.medicalInstructionId, this.images, this.dateCreate, this.diagnose});

  MedicalInstructions.fromJson(Map<String, dynamic> json) {
    medicalInstructionId = json['medicalInstructionId'];
    images = json['images'].cast<String>();
    dateCreate = json['dateCreate'];
    diagnose = json['diagnose'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicalInstructionId'] = this.medicalInstructionId;
    data['images'] = this.images;
    data['dateCreate'] = this.dateCreate;
    data['diagnose'] = this.diagnose;
    return data;
  }
}
