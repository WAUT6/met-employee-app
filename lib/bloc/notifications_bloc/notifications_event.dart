part of 'notifications_bloc.dart';

abstract class NotificationsEvent {
  const NotificationsEvent();
}

class NotificationsEventSetUpNotifications extends NotificationsEvent {
  final String userId;

  const NotificationsEventSetUpNotifications({required this.userId,});
}

class NotificationsEventSendNotifications extends NotificationsEvent {
  const NotificationsEventSendNotifications();
}

