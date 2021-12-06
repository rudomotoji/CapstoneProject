class ActivityDTO {
  String dateCreate;
  List<Notifications> notifications;

  ActivityDTO({this.dateCreate, this.notifications});

  ActivityDTO.fromJson(Map<String, dynamic> json) {
    dateCreate = json['dateCreate'];
    if (json['notifications'] != null) {
      notifications = new List<Notifications>();
      json['notifications'].forEach((v) {
        notifications.add(new Notifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateCreate'] = this.dateCreate;
    if (this.notifications != null) {
      data['notifications'] =
          this.notifications.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notifications {
  int notificationId;
  String title;
  String body;
  bool status;
  int notificationType;
  int contractId;
  int medicalInstructionId;
  int appointmentId;
  double timeAgo;
  String dateCreated;

  Notifications(
      {this.notificationId,
      this.title,
      this.body,
      this.status,
      this.notificationType,
      this.contractId,
      this.medicalInstructionId,
      this.appointmentId,
      this.timeAgo,
      this.dateCreated});

  Notifications.fromJson(Map<String, dynamic> json) {
    notificationId = json['notificationId'];
    title = json['title'];
    body = json['body'];
    status = json['status'];
    notificationType = json['notificationType'];
    contractId = json['contractId'];
    medicalInstructionId = json['medicalInstructionId'];
    appointmentId = json['appointmentId'];
    timeAgo = json['timeAgo'];
    dateCreated = json['dateCreated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notificationId'] = this.notificationId;
    data['title'] = this.title;
    data['body'] = this.body;
    data['status'] = this.status;
    data['notificationType'] = this.notificationType;
    data['contractId'] = this.contractId;
    data['medicalInstructionId'] = this.medicalInstructionId;
    data['appointmentId'] = this.appointmentId;
    data['timeAgo'] = this.timeAgo;
    data['dateCreated'] = this.dateCreated;
    return data;
  }
}
