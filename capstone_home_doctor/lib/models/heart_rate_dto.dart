class HeartRateDTO {
  int value;
  String date;

  HeartRateDTO({this.value, this.date});

  Map<String, dynamic> toMapSQL() {
    //
    var map = <String, dynamic>{
      'value': value,
      'date': date,
    };
    return map;
  }

  HeartRateDTO.fromMapSQL(Map<String, dynamic> map) {
    value = map['value'];
    date = map['date'];
  }
}

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
