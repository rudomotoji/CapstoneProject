class ContractListDTO {
  int contractId;
  String status;
  String dateCreated;
  String dateStarted;
  String dateFinished;

  ContractListDTO(
      {this.contractId,
      this.status,
      this.dateCreated,
      this.dateStarted,
      this.dateFinished});

  ContractListDTO.fromJson(Map<String, dynamic> json) {
    contractId = json['contractId'];
    status = json['status'];
    dateCreated = json['dateCreated'];
    dateStarted = json['dateStarted'];
    dateFinished = json['dateFinished'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contractId'] = this.contractId;
    data['status'] = this.status;
    data['dateCreated'] = this.dateCreated;
    data['dateStarted'] = this.dateStarted;
    data['dateFinished'] = this.dateFinished;
    return data;
  }
}
