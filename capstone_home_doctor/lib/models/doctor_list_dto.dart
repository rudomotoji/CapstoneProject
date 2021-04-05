class DoctorListDTO {
  int doctorId;
  String doctorName;
  int healthRecordId;
  int contractId;
  int accountDoctorId;
  String dateContractStarted;

  DoctorListDTO(
      {this.doctorId,
      this.doctorName,
      this.healthRecordId,
      this.contractId,
      this.accountDoctorId,
      this.dateContractStarted});

  DoctorListDTO.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctorId'];
    doctorName = json['doctorName'];
    healthRecordId = json['healthRecordId'];
    contractId = json['contractId'];
    accountDoctorId = json['accountDoctorId'];
    dateContractStarted = json['dateContractStarted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctorId'] = this.doctorId;
    data['doctorName'] = this.doctorName;
    data['healthRecordId'] = this.healthRecordId;
    data['contractId'] = this.contractId;
    data['accountDoctorId'] = this.accountDoctorId;
    data['dateContractStarted'] = this.dateContractStarted;
    return data;
  }
}
