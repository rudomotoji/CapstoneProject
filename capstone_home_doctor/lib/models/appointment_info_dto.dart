class AppointmentInfoDTO {
  int patientId;
  String fullNamePatient;
  String fullNameDoctor;
  String status;
  String note;
  Null diagnose;
  String dateExamination;
  Null reasonCanceled;
  Null dateCanceled;
  List<MedicalInstructions> medicalInstructions;

  AppointmentInfoDTO(
      {this.patientId,
      this.fullNamePatient,
      this.fullNameDoctor,
      this.status,
      this.note,
      this.diagnose,
      this.dateExamination,
      this.reasonCanceled,
      this.dateCanceled,
      this.medicalInstructions});

  AppointmentInfoDTO.fromJson(Map<String, dynamic> json) {
    patientId = json['patientId'];
    fullNamePatient = json['fullNamePatient'];
    fullNameDoctor = json['fullNameDoctor'];
    status = json['status'];
    note = json['note'];
    diagnose = json['diagnose'];
    dateExamination = json['dateExamination'];
    reasonCanceled = json['reasonCanceled'];
    dateCanceled = json['dateCanceled'];
    if (json['medicalInstructions'] != null) {
      medicalInstructions = new List<MedicalInstructions>();
      json['medicalInstructions'].forEach((v) {
        medicalInstructions.add(new MedicalInstructions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patientId'] = this.patientId;
    data['fullNamePatient'] = this.fullNamePatient;
    data['fullNameDoctor'] = this.fullNameDoctor;
    data['status'] = this.status;
    data['note'] = this.note;
    data['diagnose'] = this.diagnose;
    data['dateExamination'] = this.dateExamination;
    data['reasonCanceled'] = this.reasonCanceled;
    data['dateCanceled'] = this.dateCanceled;
    if (this.medicalInstructions != null) {
      data['medicalInstructions'] =
          this.medicalInstructions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MedicalInstructions {
  int medicalInstructionId;
  String medicalInstructionType;
  String dateCreated;

  MedicalInstructions(
      {this.medicalInstructionId,
      this.medicalInstructionType,
      this.dateCreated});

  MedicalInstructions.fromJson(Map<String, dynamic> json) {
    medicalInstructionId = json['medicalInstructionId'];
    medicalInstructionType = json['medicalInstructionType'];
    dateCreated = json['dateCreated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicalInstructionId'] = this.medicalInstructionId;
    data['medicalInstructionType'] = this.medicalInstructionType;
    data['dateCreated'] = this.dateCreated;
    return data;
  }
}
