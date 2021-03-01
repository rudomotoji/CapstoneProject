// class PrescriptionDTO {
//   String doctorName;
//   String dateFrom;
//   String dateTo;
//   List<String> diseases;

//   PrescriptionDTO({this.doctorName, this.dateFrom, this.dateTo, this.diseases});
// }

// class PrescriptionDTO {
//   String healthRecordId;
//   String diagnose;
//   String startDate;
//   String endDate;
//   List<MedicineDTO> listMedicine;

//   PrescriptionDTO(
//       {this.healthRecordId,
//       this.diagnose,
//       this.startDate,
//       this.endDate,
//       this.listMedicine});
// }

class PrescriptionDTO {
  int medicalInstructionId;
  String diagnose;
  String description;
  String dateStarted;
  String dateFinished;
  List<MedicationSchedules> medicationSchedules;

  PrescriptionDTO(
      {this.medicalInstructionId,
      this.diagnose,
      this.description,
      this.dateStarted,
      this.dateFinished,
      this.medicationSchedules});

  PrescriptionDTO.fromJson(Map<String, dynamic> json) {
    medicalInstructionId = json['medicalInstructionId'];
    diagnose = json['diagnose'];
    description = json['description'];
    dateStarted = json['dateStarted'];
    dateFinished = json['dateFinished'];
    if (json['medicationSchedules'] != null) {
      medicationSchedules = new List<MedicationSchedules>();
      json['medicationSchedules'].forEach((v) {
        medicationSchedules.add(new MedicationSchedules.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicalInstructionId'] = this.medicalInstructionId;
    data['diagnose'] = this.diagnose;
    data['description'] = this.description;
    data['dateStarted'] = this.dateStarted;
    data['dateFinished'] = this.dateFinished;
    if (this.medicationSchedules != null) {
      data['medicationSchedules'] =
          this.medicationSchedules.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MedicationSchedules {
  String medicationName;
  String content;
  String useTime;
  String unit;
  int morning;
  int noon;
  int afterNoon;
  int night;

  MedicationSchedules(
      {this.medicationName,
      this.content,
      this.useTime,
      this.unit,
      this.morning,
      this.noon,
      this.afterNoon,
      this.night});

  MedicationSchedules.fromJson(Map<String, dynamic> json) {
    medicationName = json['medicationName'];
    content = json['content'];
    useTime = json['useTime'];
    unit = json['unit'];
    morning = json['morning'];
    noon = json['noon'];
    afterNoon = json['afterNoon'];
    night = json['night'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicationName'] = this.medicationName;
    data['content'] = this.content;
    data['useTime'] = this.useTime;
    data['unit'] = this.unit;
    data['morning'] = this.morning;
    data['noon'] = this.noon;
    data['afterNoon'] = this.afterNoon;
    data['night'] = this.night;
    return data;
  }
}
