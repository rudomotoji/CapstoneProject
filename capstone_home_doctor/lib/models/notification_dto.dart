//THIS IS NOTI

class NotificationDTO {
  String dateCreate;
  List<Notifications> notifications;

  NotificationDTO({this.dateCreate, this.notifications});

  NotificationDTO.fromJson(Map<String, dynamic> json) {
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
  double timeAgo;

  Notifications(
      {this.notificationId,
      this.title,
      this.body,
      this.status,
      this.notificationType,
      this.contractId,
      this.medicalInstructionId,
      this.timeAgo});

  Notifications.fromJson(Map<String, dynamic> json) {
    notificationId = json['notificationId'];
    title = json['title'];
    body = json['body'];
    status = json['status'];
    notificationType = json['notificationType'];
    contractId = json['contractId'];
    medicalInstructionId = json['medicalInstructionId'];
    timeAgo = json['timeAgo'];
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
    data['timeAgo'] = this.timeAgo;
    return data;
  }
}

class NotificationPushDTO {
  int deviceType;
  int notificationType;
  int senderAccountId;
  int recipientAccountId;

  NotificationPushDTO(
      {this.deviceType,
      this.notificationType,
      this.senderAccountId,
      this.recipientAccountId});

  NotificationPushDTO.fromJson(Map<String, dynamic> json) {
    deviceType = json['deviceType'];
    notificationType = json['notificationType'];
    senderAccountId = json['senderAccountId'];
    recipientAccountId = json['recipientAccountId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceType'] = this.deviceType;
    data['notificationType'] = this.notificationType;
    data['senderAccountId'] = this.senderAccountId;
    data['recipientAccountId'] = this.recipientAccountId;
    return data;
  }
}
