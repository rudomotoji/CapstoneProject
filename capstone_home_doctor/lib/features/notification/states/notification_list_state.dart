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

class NotificationListStateFailure extends NotificationListState {}
