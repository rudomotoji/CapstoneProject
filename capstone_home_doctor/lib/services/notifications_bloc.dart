import 'package:capstone_home_doctor/services/noti_helper.dart';
import 'package:rxdart/rxdart.dart';

class NotificationsBloc {
  NotificationsBloc._internal();

  static final NotificationsBloc instance = NotificationsBloc._internal();

  final BehaviorSubject<ReceiveNotification> _notificationsStreamController =
      BehaviorSubject<ReceiveNotification>();

  Stream<ReceiveNotification> get notificationsStream {
    return _notificationsStreamController;
  }

  void newNotification(ReceiveNotification notification) {
    _notificationsStreamController.sink.add(notification);
  }

  void dispose() {
    _notificationsStreamController?.close();
  }
}
