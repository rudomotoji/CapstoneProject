// class MedicalInstructionDTO {
//   String medicalIntructionId;
//   String description;
//   String image;
//   String dianose;
//   String dateStarted;
//   String dateFinished;
//   String medicalInstructionTypeId;
//   String healthRecordId;

//   //constructor
//   MedicalInstructionDTO({
//     this.medicalIntructionId,
//     this.description,
//     this.image,
//     this.dianose,
//     this.dateStarted,
//     this.dateFinished,
//     this.medicalInstructionTypeId,
//     this.healthRecordId,
//   });

//   Map<String, dynamic> toMapSqflite() {
//     var map = <String, dynamic>{
//       'medical_instruction_id': medicalIntructionId,
//       'description': description,
//       'image': image,
//       'dianose': dianose,
//       'date_start': dateStarted,
//       'date_finish': dateFinished,
//       'medical_instruction_type_id': medicalInstructionTypeId,
//       'health_record_id': healthRecordId,
//     };
//     return map;
//   }

//   MedicalInstructionDTO.fromMapSqflite(Map<String, dynamic> map) {
//     medicalIntructionId = map['medical_instruction_id'];
//     description = map['description'];
//     image = map['image'];
//     dianose = map['dianose'];
//     dateStarted = map['date_start'];
//     dateFinished = map['date_finish'];
//     medicalInstructionTypeId = map['medical_instruction_type_id'];
//     healthRecordId = map['health_record_id'];
//   }

//   MedicalInstructionDTO.fromJson(Map<String, dynamic> json) {
//     medicalIntructionId = json['medicalInstructionId'];
//     description = json['description'];
//     image = json['image'];
//     dianose = json['dianose'];
//     dateStarted = json['date_start'];
//     dateFinished = json['date_finish'];
//     medicalInstructionTypeId = json['medical_instruction_type_id'];
//     healthRecordId = json['health_record_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['medicalInstructionId'] = this.medicalIntructionId;
//     data['description'] = this.description;
//     data['image'] = this.image;
//     data['dianose'] = this.dianose;
//     data['date_start'] = this.dateStarted;
//     data['date_finish'] = this.dateFinished;
//     data['medical_instruction_type_id'] = this.medicalInstructionTypeId;
//     data['health_record_id'] = this.healthRecordId;
//     return data;
//   }

//   @override
//   String toString() {
//     // TODO: implement toString
//     return '$medicalIntructionId - $dianose - $medicalInstructionTypeId - $dateStarted';
//   }
// }
import 'package:image_picker/image_picker.dart';

class MedicalInstructionByTypeDTO {
  String medicalInstructionType;
  List<MedicalInstructions> medicalInstructions;

  MedicalInstructionByTypeDTO(
      {this.medicalInstructionType, this.medicalInstructions});

  MedicalInstructionByTypeDTO.fromJson(Map<String, dynamic> json) {
    medicalInstructionType = json['medicalInstructionType'];
    if (json['medicalInstructions'] != null) {
      medicalInstructions = new List<MedicalInstructions>();
      json['medicalInstructions'].forEach((v) {
        medicalInstructions.add(new MedicalInstructions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicalInstructionType'] = this.medicalInstructionType;
    if (this.medicalInstructions != null) {
      data['medicalInstructions'] =
          this.medicalInstructions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MedicalInstructionDTO {
  String medicalInstructionType;
  String image;
  String description;
  String diagnose;
  String placeHealthRecord;
  String dateStarted;
  String dateFinished;
  //for multiple part post api
  int medicalInstructionTypeId;
  int healthRecordId;
  int patientId;
  PickedFile imageFile;

  MedicalInstructionDTO(
      {this.medicalInstructionType,
      this.image,
      this.description,
      this.diagnose,
      this.placeHealthRecord,
      this.dateStarted,
      this.dateFinished,
      this.medicalInstructionTypeId,
      this.healthRecordId,
      this.patientId,
      this.imageFile});

  MedicalInstructionDTO.fromJson(Map<String, dynamic> json) {
    medicalInstructionType = json['medicalInstructionType'];
    image = json['image'];
    description = json['description'];
    diagnose = json['diagnose'];
    placeHealthRecord = json['placeHealthRecord'];
    dateStarted = json['dateStarted'];
    dateFinished = json['dateFinished'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicalInstructionType'] = this.medicalInstructionType;
    data['image'] = this.image;
    data['description'] = this.description;
    data['diagnose'] = this.diagnose;
    data['placeHealthRecord'] = this.placeHealthRecord;
    data['dateStarted'] = this.dateStarted;
    data['dateFinished'] = this.dateFinished;
    return data;
  }
}

class MedicalInstructions {
  int medicalInstructionId;
  String image;
  bool check = false;

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
