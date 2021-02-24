class HealthRecordDTO {
  String healthRecordId;
  String disease;
  String place;
  String doctorName;
  String description;
  //to get owner
  String personalHealthRecordId;
  String dateCreated;
  //for currency health record.
  String contractId;

  //constructor
  HealthRecordDTO({
    this.healthRecordId,
    this.disease,
    this.place,
    this.doctorName,
    this.description,
    this.personalHealthRecordId,
    this.dateCreated,
    this.contractId,
  });

  Map<String, dynamic> toMapSqflite() {
    var map = <String, dynamic>{
      'health_record_id': healthRecordId,
      'disease': disease,
      'place': place,
      'doctor_name': doctorName,
      'description': description,
      'personal_health_record_id': personalHealthRecordId,
      'date_create': dateCreated,
      'contract_id': contractId,
    };
    return map;
  }

  HealthRecordDTO.fromMapSqflite(Map<String, dynamic> map) {
    healthRecordId = map['health_record_id'];
    disease = map['disease'];
    place = map['place'];
    doctorName = map['doctor_name'];
    description = map['description'];
    personalHealthRecordId = map['personal_health_record_id'];
    dateCreated = map['date_create'];
    contractId = map['contract_id'];
  }
}
