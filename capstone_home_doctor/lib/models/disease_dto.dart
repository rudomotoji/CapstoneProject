class DiseaseDTO {
  String diseaseId;
  String name;
  String strDiseaseID;
  String status;
  String code;
  int number;
  int start;
  int end;
  Null contracts;
  Null healthRecords;

  DiseaseDTO({
    this.diseaseId,
    this.code,
    this.number,
    this.start,
    this.end,
    this.name,
    this.contracts,
    this.healthRecords,
    this.strDiseaseID,
  });

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
    name = json['nameDisease'];
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
    data['nameDisease'] = this.name;
    data['contracts'] = this.contracts;
    data['healthRecords'] = this.healthRecords;
    return data;
  }

  String get getDiseaseId => diseaseId;
}

// //heart disease
// class DiseaseHeartDTO {
//   String diseaseId;
//   String name;

//   DiseaseHeartDTO({this.diseaseId, this.name});

//   @override
//   String toString() {
//     return '${diseaseId}: ${name}';
//   }

//   DiseaseHeartDTO.fromJson(Map<String, dynamic> json) {
//     diseaseId = json['diseaseId'];
//     name = json['nameDisease'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['diseaseId'] = this.diseaseId;
//     data['nameDisease'] = this.name;
//     return data;
//   }

//   String get getDiseaseId => diseaseId;
// }

class DiseaseContractDTO {
  String diseaseLevelTwoId;
  String diseaseLevelTwoName;
  List<DiseaseLeverThrees> diseaseLevelThrees;

  DiseaseContractDTO(
      {this.diseaseLevelTwoId,
      this.diseaseLevelTwoName,
      this.diseaseLevelThrees});

  DiseaseContractDTO.fromJson(Map<String, dynamic> json) {
    diseaseLevelTwoId = json['diseaseLevelTwoId'];
    diseaseLevelTwoName = json['diseaseLevelTwoName'];
    if (json['diseaseLevelThrees'] != null) {
      diseaseLevelThrees = new List<DiseaseLeverThrees>();
      json['diseaseLevelThrees'].forEach((v) {
        diseaseLevelThrees.add(new DiseaseLeverThrees.fromJson(v));
      });
    }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['diseaseLevelTwoId'] = this.diseaseLevelTwoId;
  //   data['diseaseLevelTwoName'] = this.diseaseLevelTwoName;
  //   if (this.diseaseLevelThrees != null) {
  //     data['diseaseLeverThrees'] =
  //         this.diseaseLevelThrees.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class DiseaseLeverThrees {
  String diseaseLevelThreeId;
  String diseaseLevelThreeName;
  String strDiseaseID;

  DiseaseLeverThrees({
    this.diseaseLevelThreeId,
    this.diseaseLevelThreeName,
    this.strDiseaseID,
  });

  @override
  String toString() {
    return '${diseaseLevelThreeId}: ${diseaseLevelThreeName}';
  }

  DiseaseLeverThrees.fromJson(Map<String, dynamic> json) {
    diseaseLevelThreeId = json['diseaseLevelThreeId'];
    diseaseLevelThreeName = json['diseaseLevelThreeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diseaseLevelThreeId'] = this.diseaseLevelThreeId;
    data['diseaseLevelThreeName'] = this.diseaseLevelThreeName;
    return data;
  }
}

class Disease {
  String diseaseId;
  String diseaseName;

  Disease({
    this.diseaseId,
    this.diseaseName,
  });

  String toString() {
    return '${diseaseId}: ${diseaseName}';
  }

  Disease.fromJson(Map<String, dynamic> json) {
    diseaseId = json['diseaseId'];
    diseaseName = json['diseaseName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diseaseId'] = this.diseaseId;
    data['diseaseName'] = this.diseaseName;
    return data;
  }
}
