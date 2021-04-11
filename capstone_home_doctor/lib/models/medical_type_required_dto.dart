// class MedicalTypeRequiredDTO {
//   int medicalInstructionRequireId;
//   String diseaseId;
//   List<MedicalInstructions2> medicalInstructions;

//   MedicalTypeRequiredDTO(
//       {this.medicalInstructionRequireId,
//       this.diseaseId,
//       this.medicalInstructions});

//   MedicalTypeRequiredDTO.fromJson(Map<String, dynamic> json) {
//     medicalInstructionRequireId = json['medicalInstructionRequireId'];
//     diseaseId = json['diseaseId'];
//     if (json['medicalInstructions'] != null) {
//       medicalInstructions = new List<MedicalInstructions2>();
//       json['medicalInstructions'].forEach((v) {
//         medicalInstructions.add(new MedicalInstructions2.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['medicalInstructionRequireId'] = this.medicalInstructionRequireId;
//     data['diseaseId'] = this.diseaseId;
//     if (this.medicalInstructions != null) {
//       data['medicalInstructions'] =
//           this.medicalInstructions.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class MedicalInstructions2 {
//   int medicalInstructionTypeId;
//   String medicalInstructionTypeName;

//   MedicalInstructions2(
//       {this.medicalInstructionTypeId, this.medicalInstructionTypeName});

//   MedicalInstructions2.fromJson(Map<String, dynamic> json) {
//     medicalInstructionTypeId = json['medicalInstructionTypeId'];
//     medicalInstructionTypeName = json['medicalInstructionTypeName'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['medicalInstructionTypeId'] = this.medicalInstructionTypeId;
//     data['medicalInstructionTypeName'] = this.medicalInstructionTypeName;
//     return data;
//   }
// }

class MedicalTypeRequiredDTO {
  int medicalInstructionRequiredId;
  int medicalInstructionTypeId;
  String medicalInstructionTypeName;
  List<SuggestionDisease> suggestionDisease;

  MedicalTypeRequiredDTO(
      {this.medicalInstructionRequiredId,
      this.medicalInstructionTypeId,
      this.medicalInstructionTypeName,
      this.suggestionDisease});

  MedicalTypeRequiredDTO.fromJson(Map<String, dynamic> json) {
    medicalInstructionRequiredId = json['medicalInstructionRequiredId'];
    medicalInstructionTypeId = json['medicalInstructionTypeId'];
    medicalInstructionTypeName = json['medicalInstructionTypeName'];
    if (json['suggestionDisease'] != null) {
      suggestionDisease = new List<SuggestionDisease>();
      json['suggestionDisease'].forEach((v) {
        suggestionDisease.add(new SuggestionDisease.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicalInstructionRequiredId'] = this.medicalInstructionRequiredId;
    data['medicalInstructionTypeId'] = this.medicalInstructionTypeId;
    data['medicalInstructionTypeName'] = this.medicalInstructionTypeName;
    if (this.suggestionDisease != null) {
      data['suggestionDisease'] =
          this.suggestionDisease.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SuggestionDisease {
  int suggestionDiseaseId;
  String diseaseId;
  String diseaseName;

  SuggestionDisease(
      {this.suggestionDiseaseId, this.diseaseId, this.diseaseName});

  SuggestionDisease.fromJson(Map<String, dynamic> json) {
    suggestionDiseaseId = json['suggestionDiseaseId'];
    diseaseId = json['diseaseId'];
    diseaseName = json['diseaseName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['suggestionDiseaseId'] = this.suggestionDiseaseId;
    data['diseaseId'] = this.diseaseId;
    data['diseaseName'] = this.diseaseName;
    return data;
  }
}
