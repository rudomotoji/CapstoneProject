// class MedicalShareDTO {
//   String healthRecordPlace;
//   List<Diseases> diseases;
//   List<MedicalInstructionTypes> medicalInstructionTypes;

//   MedicalShareDTO(
//       {this.healthRecordPlace, this.diseases, this.medicalInstructionTypes});

//   MedicalShareDTO.fromJson(Map<String, dynamic> json) {
//     healthRecordPlace = json['healthRecordPlace'];
//     if (json['diseases'] != null) {
//       diseases = new List<Diseases>();
//       json['diseases'].forEach((v) {
//         diseases.add(new Diseases.fromJson(v));
//       });
//     }
//     if (json['medicalInstructionTypes'] != null) {
//       medicalInstructionTypes = new List<MedicalInstructionTypes>();
//       json['medicalInstructionTypes'].forEach((v) {
//         medicalInstructionTypes.add(new MedicalInstructionTypes.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['healthRecordPlace'] = this.healthRecordPlace;
//     if (this.diseases != null) {
//       data['diseases'] = this.diseases.map((v) => v.toJson()).toList();
//     }
//     if (this.medicalInstructionTypes != null) {
//       data['medicalInstructionTypes'] =
//           this.medicalInstructionTypes.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Diseases {
//   String diseaseId;
//   String diseaseName;

//   Diseases({this.diseaseId, this.diseaseName});

//   Diseases.fromJson(Map<String, dynamic> json) {
//     diseaseId = json['diseaseId'];
//     diseaseName = json['diseaseName'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['diseaseId'] = this.diseaseId;
//     data['diseaseName'] = this.diseaseName;
//     return data;
//   }
// }

// class MedicalInstructionTypes {
//   String miTypeName;
//   List<MedicalInstructions> medicalInstructions;

//   MedicalInstructionTypes({this.miTypeName, this.medicalInstructions});

//   MedicalInstructionTypes.fromJson(Map<String, dynamic> json) {
//     miTypeName = json['miTypeName'];
//     if (json['medicalInstructions'] != null) {
//       medicalInstructions = new List<MedicalInstructions>();
//       json['medicalInstructions'].forEach((v) {
//         medicalInstructions.add(new MedicalInstructions.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['miTypeName'] = this.miTypeName;
//     if (this.medicalInstructions != null) {
//       data['medicalInstructions'] =
//           this.medicalInstructions.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class MedicalInstructions {
//   int medicalInstructionId;
//   String image;

//   MedicalInstructions({this.medicalInstructionId, this.image});

//   MedicalInstructions.fromJson(Map<String, dynamic> json) {
//     medicalInstructionId = json['medicalInstructionId'];
//     image = json['image'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['medicalInstructionId'] = this.medicalInstructionId;
//     data['image'] = this.image;
//     return data;
//   }
// }

class MedicalShareDTO {
  String healthRecordPlace;
  String dateCreate;
  List<MedicalInstructions> medicalInstructions;

  MedicalShareDTO({this.healthRecordPlace, this.medicalInstructions});

  MedicalShareDTO.fromJson(Map<String, dynamic> json) {
    healthRecordPlace = json['healthRecordPlace'];
    dateCreate = json['dateCreate'];
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
  String dateCreate;
  bool isChecked = false;

  MedicalInstructions({this.medicalInstructionId, this.image, this.isChecked});

  MedicalInstructions.fromJson(Map<String, dynamic> json) {
    medicalInstructionId = json['medicalInstructionId'];
    dateCreate = json['dateCreate'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicalInstructionId'] = this.medicalInstructionId;
    data['dateCreate'] = this.dateCreate;
    data['image'] = this.image;
    return data;
  }
}
