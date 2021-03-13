class ContractUpdateDTO {
  int doctorId;
  int patientId;
  int contractId;
  String status;
  String dateStart;
  int daysOfTracking;

  ContractUpdateDTO(
      {this.doctorId,
      this.patientId,
      this.contractId,
      this.status,
      this.dateStart,
      this.daysOfTracking});

  ContractUpdateDTO.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctorId'];
    patientId = json['patientId'];
    contractId = json['contractId'];
    status = json['status'];
    dateStart = json['dateStart'];
    daysOfTracking = json['daysOfTracking'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctorId'] = this.doctorId;
    data['patientId'] = this.patientId;
    data['contractId'] = this.contractId;
    data['status'] = this.status;
    data['dateStart'] = this.dateStart;
    data['daysOfTracking'] = this.daysOfTracking;
    return data;
  }
  //
}
