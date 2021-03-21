class AppointmentDTO {
  String dateExamination;
  List<AppointmentDetailDTO> appointments;

  AppointmentDTO({this.dateExamination, this.appointments});

  AppointmentDTO.fromJson(Map<String, dynamic> json) {
    dateExamination = json['dateExamination'];
    if (json['appointments'] != null) {
      appointments = new List<AppointmentDetailDTO>();
      json['appointments'].forEach((v) {
        appointments.add(new AppointmentDetailDTO.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateExamination'] = this.dateExamination;
    if (this.appointments != null) {
      data['appointments'] = this.appointments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AppointmentDetailDTO {
  int appointmentId;
  String status;
  String note;
  String dateExamination;
  String reasonCanceled;
  String dateCanceled;

  AppointmentDetailDTO(
      {this.appointmentId,
      this.status,
      this.note,
      this.dateExamination,
      this.reasonCanceled,
      this.dateCanceled});

  AppointmentDetailDTO.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointmentId'];
    status = json['status'];
    note = json['note'];
    dateExamination = json['dateExamination'];
    reasonCanceled = json['reasonCanceled'];
    dateCanceled = json['dateCanceled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointmentId'] = this.appointmentId;
    data['status'] = this.status;
    data['note'] = this.note;
    data['dateExamination'] = this.dateExamination;
    data['reasonCanceled'] = this.reasonCanceled;
    data['dateCanceled'] = this.dateCanceled;
    return data;
  }
}
