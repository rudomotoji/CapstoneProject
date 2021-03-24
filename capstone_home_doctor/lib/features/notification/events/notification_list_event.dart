import 'package:capstone_home_doctor/models/notification_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class NotificationListEvent extends Equatable {
  const NotificationListEvent();
}

class NotificationListEventGet extends NotificationListEvent {
  final int accountId;

  const NotificationListEventGet({@required this.accountId});

  @override
  // TODO: implement props
  List<Object> get props => [accountId];
}

class NotificationUpdateStatusEvent extends NotificationListEvent {
  final int notiId;

  const NotificationUpdateStatusEvent({@required this.notiId});

  @override
  // TODO: implement props
  List<Object> get props => [notiId];
}

class NotiPushEvent extends NotificationListEvent {
  final NotificationPushDTO notiPushDTO;

  const NotiPushEvent({@required this.notiPushDTO});

  @override
  // TODO: implement props
  List<Object> get props => [notiPushDTO];
}
