import 'package:capstone_home_doctor/models/notification_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class NotificationListState extends Equatable {
  const NotificationListState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class NotificationListStateInitial extends NotificationListState {}

class NotificationListStateLoading extends NotificationListState {}

class NotificationListStateSuccess extends NotificationListState {
  final List<NotificationDTO> listNotification;

  const NotificationListStateSuccess({@required this.listNotification});

  @override
  // TODO: implement props
  List<Object> get props => [listNotification];
}

//push noti success
class NotiPushStateSuccess extends NotificationListState {
  final bool isPushed;
  const NotiPushStateSuccess({@required this.isPushed});
  @override
  // TODO: implement props
  List<Object> get props => [isPushed];
}

//update status noti
class NotificationListStateFailure extends NotificationListState {}

class NotificationUpdateSuccess extends NotificationListState {
  final bool isUpdated;

  const NotificationUpdateSuccess({@required this.isUpdated});

  @override
  // TODO: implement props
  List<Object> get props => [isUpdated];
}

class NotiChangePeopleStatus extends NotificationListState {
  final bool isChanged;

  const NotiChangePeopleStatus({@required this.isChanged});
  @override
  // TODO: implement props
  List<Object> get props => [isChanged];
}
