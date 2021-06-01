import 'package:capstone_home_doctor/models/prescription_dto.dart';
import 'package:image_picker/image_picker.dart';

class MedicalInstructionByTypeDTO {
  String medicalInstructionType;
  List<MedicalInstructionsDTO> medicalInstructions;

  MedicalInstructionByTypeDTO(
      {this.medicalInstructionType, this.medicalInstructions});

  MedicalInstructionByTypeDTO.fromJson(Map<String, dynamic> json) {
    medicalInstructionType = json['medicalInstructionType'];
    if (json['medicalInstructions'] != null) {
      medicalInstructions = new List<MedicalInstructionsDTO>();
      json['medicalInstructions'].forEach((v) {
        medicalInstructions.add(new MedicalInstructionsDTO.fromJson(v));
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
  int medicalInstructionId;
  String medicalInstructionType;
  List<String> image;
  String description;
  String diagnose;
  String placeHealthRecord;
  List<String> diseaseIds; // list mã bệnh để tạo medical instruction
  List<String> diseases;
  // String diseaseIds; // list mã bệnh để tạo medical instruction
  String patientFullName;
  String status;
  PrescriptionDTO medicationsRespone;
  //for multiple part post api
  int medicalInstructionTypeId;
  int healthRecordId;
  String dateCreate;
  String dateStarted;
  String dateFinished;
  String dateTreatment;
  int patientId;
  List<String> imageFile;
  //vitalsign
  VitalSignScheduleRespone vitalSignScheduleRespone;
  //appointmemt
  AppointmentDetail appointmentDetail;
  int appointmentId;

  MedicalInstructionDTO({
    this.medicalInstructionType,
    this.medicalInstructionId,
    this.image,
    this.description,
    this.diagnose,
    this.placeHealthRecord,
    this.dateCreate,
    this.medicalInstructionTypeId,
    this.healthRecordId,
    this.patientId,
    this.imageFile,
    this.patientFullName,
    this.status,
    this.vitalSignScheduleRespone,
    this.medicationsRespone,
    this.appointmentDetail,
    this.diseaseIds,
    this.diseases,
    this.appointmentId,
    this.dateFinished,
    this.dateStarted,
    this.dateTreatment,
  });

  MedicalInstructionDTO.fromJson(Map<String, dynamic> json) {
    medicalInstructionId = json['medicalInstructionId'];
    medicalInstructionType = json['medicalInstructionTypeName'];
    medicalInstructionTypeId = json['medicalInstructionTypeId'];
    image = json['images'] != null ? json['images'].cast<String>() : null;
    description = json['description'];
    diagnose = json['conclusion'];
    placeHealthRecord = json['placeHealthRecord'];
    diseases =
        json['diseases'] != null ? json['diseases'].cast<String>() : null;
    dateStarted = json['dateStarted'];
    dateFinished = json['dateFinished'];
    dateCreate = json['dateCreate'];
    dateTreatment = json['dateTreatment'];
    patientFullName = json['patientFullName'];
    status = json['status'];
    medicationsRespone = json['prescriptionRespone'] != null
        ? new PrescriptionDTO.fromJson(json['prescriptionRespone'])
        : null;

    vitalSignScheduleRespone = json['vitalSignScheduleRespone'] != null
        ? new VitalSignScheduleRespone.fromJson(
            json['vitalSignScheduleRespone'])
        : null;

    appointmentDetail = json['appointmentDetail'] != null
        ? new AppointmentDetail.fromJson(json['appointmentDetail'])
        : null;
    appointmentId = json['appointmentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicalInstructionType'] = this.medicalInstructionType;
    data['images'] = this.image;
    data['description'] = this.description;
    data['diagnose'] = this.diagnose;
    data['placeHealthRecord'] = this.placeHealthRecord;
    // data['dateStarted'] = this.dateStarted;
    // data['dateFinished'] = this.dateFinished;
    data['dateCreate'] = this.dateCreate;
    data['patientFullName'] = this.patientFullName;
    data['status'] = this.status;
    data['diseases'] = this.diseases;
    return data;
  }
}

class MedicalInstructionsDTO {
  String status;
  int medicalInstructionId;
  String diagnose;
  String description;
  List<String> image;
  String dateCreate;
  int medicalInstructionTypeId;
  PrescriptionDTO prescriptionRespone;

  MedicalInstructionsDTO(
      {this.status,
      this.medicalInstructionId,
      this.diagnose,
      this.description,
      this.image,
      this.prescriptionRespone,
      this.dateCreate,
      this.medicalInstructionTypeId});

  MedicalInstructionsDTO.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    medicalInstructionId = json['medicalInstructionId'];
    diagnose = json['diagnose'];
    description = json['description'];
    image = json['images'].cast<String>();
    dateCreate = json['dateCreate'];
    medicalInstructionTypeId = json['medicalInstructionTypeId'];

    prescriptionRespone = json['prescriptionRespone'] != null
        ? new PrescriptionDTO.fromJson(json['prescriptionRespone'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['medicalInstructionId'] = this.medicalInstructionId;
    data['diagnose'] = this.diagnose;
    data['description'] = this.description;
    data['image'] = this.image;
    data['prescriptionRespone'] = this.prescriptionRespone;
    data['dateCreate'] = this.dateCreate;
    data['medicalInstructionTypeId'] = this.medicalInstructionTypeId;
    return data;
  }
}

class VitalSignScheduleRespone {
  String timeStared;
  String timeCanceled;
  List<VitalSigns> vitalSigns;

  VitalSignScheduleRespone(
      {this.timeStared, this.timeCanceled, this.vitalSigns});

  VitalSignScheduleRespone.fromJson(Map<String, dynamic> json) {
    timeStared = json['timeStared'];
    timeCanceled = json['timeCanceled'];
    if (json['vitalSigns'] != null) {
      vitalSigns = new List<VitalSigns>();
      json['vitalSigns'].forEach((v) {
        vitalSigns.add(new VitalSigns.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timeStared'] = this.timeStared;
    data['timeCanceled'] = this.timeCanceled;
    if (this.vitalSigns != null) {
      data['vitalSigns'] = this.vitalSigns.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VitalSigns {
  int vitalSignTypeId;
  String vitalSignType;
  int numberMax;
  int numberMin;
  int minuteDangerInterval;
  int minuteNormalInterval;
  String timeStart;
  int minuteAgain;

  VitalSigns(
      {this.vitalSignTypeId,
      this.vitalSignType,
      this.numberMax,
      this.numberMin,
      this.minuteDangerInterval,
      this.minuteNormalInterval,
      this.timeStart,
      this.minuteAgain});

  VitalSigns.fromJson(Map<String, dynamic> json) {
    vitalSignTypeId = json['vitalSignTypeId'];
    vitalSignType = json['vitalSignType'];
    numberMax = json['numberMax'];
    numberMin = json['numberMin'];
    minuteDangerInterval = json['minuteDangerInterval'];
    minuteNormalInterval = json['minuteNormalInterval'];
    timeStart = json['timeStart'];
    minuteAgain = json['minuteAgain'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vitalSignTypeId'] = this.vitalSignTypeId;
    data['vitalSignType'] = this.vitalSignType;
    data['numberMax'] = this.numberMax;
    data['numberMin'] = this.numberMin;
    data['minuteDangerInterval'] = this.minuteDangerInterval;
    data['minuteNormalInterval'] = this.minuteNormalInterval;
    data['timeStart'] = this.timeStart;
    data['minuteAgain'] = this.minuteAgain;
    return data;
  }
}

class AppointmentDetail {
  int appointmentId;
  String dateExamination;
  String status;
  String note;
  String description;
  String reasonCanceled;
  String dateCanceled;

  AppointmentDetail(
      {this.appointmentId,
      this.dateExamination,
      this.status,
      this.note,
      this.description,
      this.reasonCanceled,
      this.dateCanceled});

  AppointmentDetail.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointmentId'];
    dateExamination = json['dateExamination'];
    status = json['status'];
    note = json['note'];
    description = json['description'];
    reasonCanceled = json['reasonCanceled'];
    dateCanceled = json['dateCanceled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointmentId'] = this.appointmentId;
    data['dateExamination'] = this.dateExamination;
    data['status'] = this.status;
    data['note'] = this.note;
    data['description'] = this.description;
    data['reasonCanceled'] = this.reasonCanceled;
    data['dateCanceled'] = this.dateCanceled;
    return data;
  }
}
