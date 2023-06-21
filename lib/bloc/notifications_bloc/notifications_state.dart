part of 'notifications_bloc.dart';

abstract class NotificationsState {
  const NotificationsState();
}

class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

class NotificationsStateSettingUpNotifications extends NotificationsState {
  const NotificationsStateSettingUpNotifications();
}

class NotificationsStateSendingNotifications extends NotificationsState {
  const NotificationsStateSendingNotifications();
}
