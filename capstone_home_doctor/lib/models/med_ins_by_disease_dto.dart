class MedInsByDiseaseDTO {
  String healthRecordPlace;
  List<MedicalInstructionTypes> medicalInstructionTypes;

  MedInsByDiseaseDTO({this.healthRecordPlace, this.medicalInstructionTypes});

  MedInsByDiseaseDTO.fromJson(Map<String, dynamic> json) {
    healthRecordPlace = json['healthRecordPlace'];
    if (json['medicalInstructionTypes'] != null) {
      medicalInstructionTypes = new List<MedicalInstructionTypes>();
      json['medicalInstructionTypes'].forEach((v) {
        medicalInstructionTypes.add(new MedicalInstructionTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['healthRecordPlace'] = this.healthRecordPlace;
    if (this.medicalInstructionTypes != null) {
      data['medicalInstructionTypes'] =
          this.medicalInstructionTypes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MedicalInstructionTypes {
  String miTypeName;
  List<MedicalInstructions> medicalInstructions;

  MedicalInstructionTypes({this.miTypeName, this.medicalInstructions});

  MedicalInstructionTypes.fromJson(Map<String, dynamic> json) {
    miTypeName = json['miTypeName'];
    if (json['medicalInstructions'] != null) {
      medicalInstructions = new List<MedicalInstructions>();
      json['medicalInstructions'].forEach((v) {
        medicalInstructions.add(new MedicalInstructions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['miTypeName'] = this.miTypeName;
    if (this.medicalInstructions != null) {
      data['medicalInstructions'] =
          this.medicalInstructions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MedicalInstructions {
  int medicalInstructionId;
  String image;

  MedicalInstructions({this.medicalInstructionId, this.image});

  MedicalInstructions.fromJson(Map<String, dynamic> json) {
    medicalInstructionId = json['medicalInstructionId'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicalInstructionId'] = this.medicalInstructionId;
    data['image'] = this.image;
    return data;
  }
}
