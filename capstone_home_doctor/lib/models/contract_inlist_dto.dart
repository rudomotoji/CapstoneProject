class ContractListDTO {
  int contractId;
  String contractCode;
  String fullNameDoctor;
  int daysOfTracking;
  String status;
  String dateCreated;
  String dateStarted;
  String dateFinished;

  ContractListDTO(
      {this.contractId,
      this.contractCode,
      this.fullNameDoctor,
      this.daysOfTracking,
      this.status,
      this.dateCreated,
      this.dateStarted,
      this.dateFinished});

  ContractListDTO.fromJson(Map<String, dynamic> json) {
    contractId = json['contractId'];
    contractCode = json['contractCode'];
    fullNameDoctor = json['fullNameDoctor'];
    daysOfTracking = json['daysOfTracking'];
    status = json['status'];
    dateCreated = json['dateCreated'];
    dateStarted = json['dateStarted'];
    dateFinished = json['dateFinished'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contractId'] = this.contractId;
    data['contractCode'] = this.contractCode;
    data['fullNameDoctor'] = this.fullNameDoctor;
    data['daysOfTracking'] = this.daysOfTracking;
    data['status'] = this.status;
    data['dateCreated'] = this.dateCreated;
    data['dateStarted'] = this.dateStarted;
    data['dateFinished'] = this.dateFinished;
    return data;
  }
}
