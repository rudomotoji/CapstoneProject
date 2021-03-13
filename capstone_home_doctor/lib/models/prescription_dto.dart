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
import 'package:uuid/uuid.dart';

// class PrescriptionDTO {
//   String dateStarted;
//   String dateFinished;
//   List<MedicationSchedules> medicationSchedules;

//   PrescriptionDTO(
//       {this.dateStarted, this.dateFinished, this.medicationSchedules});

//   PrescriptionDTO.fromJson(Map<String, dynamic> json) {
//     dateStarted = json['dateStarted'];
//     dateFinished = json['dateFinished'];
//     if (json['medicationSchedules'] != null) {
//       medicationSchedules = new List<MedicationSchedules>();
//       json['medicationSchedules'].forEach((v) {
//         medicationSchedules.add(new MedicationSchedules.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['dateStarted'] = this.dateStarted;
//     data['dateFinished'] = this.dateFinished;
//     if (this.medicationSchedules != null) {
//       data['medicationSchedules'] =
//           this.medicationSchedules.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class PrescriptionDTO {
  int medicalInstructionId;
  String medicalInstructionType;
  String image;
  String description;
  String diagnose;
  String placeHealthRecord;
  MedicationsRespone medicationsRespone;

  PrescriptionDTO(
      {this.medicalInstructionId,
      this.medicalInstructionType,
      this.image,
      this.description,
      this.diagnose,
      this.placeHealthRecord,
      this.medicationsRespone});

  PrescriptionDTO.fromJson(Map<String, dynamic> json) {
    medicalInstructionId = json['medicalInstructionId'];
    medicalInstructionType = json['medicalInstructionType'];
    image = json['image'];
    description = json['description'];
    diagnose = json['diagnose'];
    placeHealthRecord = json['placeHealthRecord'];
    medicationsRespone = json['medicationsRespone'] != null
        ? new MedicationsRespone.fromJson(json['medicationsRespone'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicalInstructionId'] = this.medicalInstructionId;
    data['medicalInstructionType'] = this.medicalInstructionType;
    data['image'] = this.image;
    data['description'] = this.description;
    data['diagnose'] = this.diagnose;
    data['placeHealthRecord'] = this.placeHealthRecord;
    if (this.medicationsRespone != null) {
      data['medicationsRespone'] = this.medicationsRespone.toJson();
    }
    return data;
  }
}

class MedicationsRespone {
  String dateStarted;
  String dateFinished;
  List<MedicationSchedules> medicationSchedules;

  MedicationsRespone(
      {this.dateStarted, this.dateFinished, this.medicationSchedules});

  MedicationsRespone.fromJson(Map<String, dynamic> json) {
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
  String medicalScheduleId;

  MedicationSchedules(
      {this.medicationName,
      this.content,
      this.useTime,
      this.unit,
      this.morning,
      this.noon,
      this.afterNoon,
      this.night});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'medical_schedule_id': Uuid().v1(),
      'medication_name': medicationName,
      'content': content,
      'useTime': useTime,
      'unit': unit,
      'morning': morning,
      'noon': noon,
      'afterNoon': afterNoon,
      'night': night
    };
    return map;
  }

  MedicationSchedules.fromMap(Map<String, dynamic> map) {
    medicalScheduleId = map['medical_schedule_id'];
    medicationName = map['medication_name'];
    content = map['content'];
    useTime = map['useTime'];
    unit = map['unit'];
    morning = map['morning'];
    noon = map['noon'];
    afterNoon = map['afterNoon'];
    night = map['night'];
  }

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
