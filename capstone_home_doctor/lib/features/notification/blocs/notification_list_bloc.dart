import 'package:capstone_home_doctor/features/notification/events/notification_list_event.dart';
import 'package:capstone_home_doctor/features/notification/repositories/notification_repository.dart';
import 'package:capstone_home_doctor/features/notification/states/notification_list_state.dart';
import 'package:capstone_home_doctor/models/activity_dto.dart';
import 'package:capstone_home_doctor/models/notification_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationListBloc
    extends Bloc<NotificationListEvent, NotificationListState> {
  final NotificationRepository notificationRepository;
//
  NotificationListBloc({@required this.notificationRepository})
      : assert(notificationRepository != null),
        super(NotificationListStateInitial());
  //
  @override
  Stream<NotificationListState> mapEventToState(
      NotificationListEvent event) async* {
    if (event is NotificationListEventGet) {
      yield NotificationListStateLoading();
      try {
        final List<NotificationDTO> list =
            await notificationRepository.getListNotification(event.accountId);
        yield NotificationListStateSuccess(listNotification: list);
      } catch (e) {
        yield NotificationListStateFailure();
      }
    }
    if (event is NotificationUpdateStatusEvent) {
      yield NotificationListStateLoading();
      try {
        print('go bloc and event update noti');
        final bool isUpdated =
            await notificationRepository.updateStatusNotification(event.notiId);
        if (isUpdated) {
          yield NotificationUpdateSuccess(isUpdated: isUpdated);
        } else {
          yield NotificationListStateFailure();
        }
      } catch (e) {
        yield NotificationListStateFailure();
      }
    }
    if (event is NotiPushEvent) {
      yield NotificationListStateLoading();
      try {
        print('go bloc and event update noti');
        final bool isPushed =
            await notificationRepository.pushNotification(event.notiPushDTO);
        if (isPushed) {
          yield NotiPushStateSuccess(isPushed: isPushed);
        } else {
          yield NotificationListStateFailure();
        }
      } catch (e) {
        yield NotificationListStateFailure();
      }
    }
    if (event is NotiChangePeopleStatusEvent) {
      yield NotificationListStateLoading();
      try {
        //
        final bool isChanged = await notificationRepository
            .changePersonalStatus(event.patientId, event.status);
        if (isChanged) {
          print('changed successful status people');
          yield NotiChangePeopleStatus(isChanged: isChanged);
        }
      } catch (e) {
        yield NotificationListStateFailure();
      }
    }
    if (event is TimeLineGetEvent) {
      yield NotificationListStateLoading();
      try {
        //
        final ActivityDTO dto = await notificationRepository.getListTimeline(
            event.patientAccountId, event.doctorAccountId, event.dateTime);
        yield TimeLineStateSuccess(dto: dto);
      } catch (e) {
        yield NotificationListStateFailure();
      }
    }
  }
}
