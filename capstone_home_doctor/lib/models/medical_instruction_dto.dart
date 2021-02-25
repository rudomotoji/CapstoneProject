class MedicalInstructionDTO {
  String medicalIntructionId;
  String description;
  String image;
  String dianose;
  String dateStarted;
  String dateFinished;
  String medicalInstructionTypeId;
  String healthRecordId;

  //constructor
  MedicalInstructionDTO({
    this.medicalIntructionId,
    this.description,
    this.image,
    this.dianose,
    this.dateStarted,
    this.dateFinished,
    this.medicalInstructionTypeId,
    this.healthRecordId,
  });

  Map<String, dynamic> toMapSqflite() {
    var map = <String, dynamic>{
      'medical_instruction_id': medicalIntructionId,
      'description': description,
      'image': image,
      'dianose': dianose,
      'date_start': dateStarted,
      'date_finish': dateFinished,
      'medical_instruction_type_id': medicalInstructionTypeId,
      'health_record_id': healthRecordId,
    };
    return map;
  }

  MedicalInstructionDTO.fromMapSqflite(Map<String, dynamic> map) {
    medicalIntructionId = map['medical_instruction_id'];
    description = map['description'];
    image = map['image'];
    dianose = map['dianose'];
    dateStarted = map['date_start'];
    dateFinished = map['date_finish'];
    medicalInstructionTypeId = map['medical_instruction_type_id'];
    healthRecordId = map['health_record_id'];
  }

  @override
  String toString() {
    // TODO: implement toString
    return '$medicalIntructionId - $dianose - $medicalInstructionTypeId - $dateStarted';
  }
}
