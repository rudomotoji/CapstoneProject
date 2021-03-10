class NotificationDTO {
  String title;
  String body;
  bool status;
  int contractId;
  int medicalInstructionId;
  String dateCreate;

  NotificationDTO(
      {this.title,
      this.body,
      this.status,
      this.contractId,
      this.medicalInstructionId,
      this.dateCreate});

  NotificationDTO.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    status = json['status'];
    contractId = json['contractId'];
    medicalInstructionId = json['medicalInstructionId'];
    dateCreate = json['dateCreate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    data['status'] = this.status;
    data['contractId'] = this.contractId;
    data['medicalInstructionId'] = this.medicalInstructionId;
    data['dateCreate'] = this.dateCreate;
    return data;
  }
}
