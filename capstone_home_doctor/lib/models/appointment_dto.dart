class AppointmentDTO {
  String dateExamination;
  int contractId;
  List<AppointmentDetailDTO> appointments;

  AppointmentDTO({this.dateExamination, this.appointments, this.contractId});

  AppointmentDTO.fromJson(Map<String, dynamic> json) {
    dateExamination = json['dateExamination'];
    contractId = json['contractId'];
    if (json['appointments'] != null) {
      appointments = new List<AppointmentDetailDTO>();
      json['appointments'].forEach((v) {
        AppointmentDetailDTO item = new AppointmentDetailDTO.fromJson(v);
        item.contractId = json['contractId'];
        appointments.add(item);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateExamination'] = this.dateExamination;
    data['contractId'] = this.contractId;
    if (this.appointments != null) {
      data['appointments'] = this.appointments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AppointmentDetailDTO {
  int appointmentId;
  int contractId;
  String status;
  String note;
  String dateExamination;
  String reasonCanceled;
  String dateCanceled;
  String fullNamePatient;
  String fullNameDoctor;
  //add more
  String dianose;
  int patientId;
  List<MedicalInstructions> medicalInstructions;

  AppointmentDetailDTO(
      {this.patientId,
      this.dianose,
      this.appointmentId,
      this.status,
      this.note,
      this.dateExamination,
      this.reasonCanceled,
      this.dateCanceled,
      this.fullNamePatient,
      this.contractId,
      this.fullNameDoctor});

  AppointmentDetailDTO.fromJson(Map<String, dynamic> json) {
    patientId = json['patientId'];
    dianose = json['diagnose'];
    appointmentId = json['appointmentId'];
    status = json['status'];
    note = json['note'];
    dateExamination = json['dateExamination'];
    reasonCanceled = json['reasonCanceled'];
    dateCanceled = json['dateCanceled'];
    fullNamePatient = json['fullNamePatient'];
    fullNameDoctor = json['fullNameDoctor'];
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
    data['diagnose'] = this.dianose;
    data['appointmentId'] = this.appointmentId;
    data['status'] = this.status;
    data['note'] = this.note;
    data['dateExamination'] = this.dateExamination;
    data['reasonCanceled'] = this.reasonCanceled;
    data['dateCanceled'] = this.dateCanceled;
    data['fullNamePatient'] = this.fullNamePatient;
    data['fullNameDoctor'] = this.fullNameDoctor;
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
