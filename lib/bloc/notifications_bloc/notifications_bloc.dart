import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:metapp/services/cloud/notifications_provider.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc(NotificationsProvider provider) : super(const NotificationsInitial()) {
    on<NotificationsEventSetUpNotifications>((event, emit) async {
      try {
        emit(const NotificationsStateSettingUpNotifications());
        provider.requestPermission();
        provider.getToken(userId: event.userId);
        provider.initInfo();
        emit(const NotificationsInitial());
      } catch (e) {
        print(e.toString());
        Fluttertoast.showToast(msg: 'Could Not set up notifications');
      }
    }
    );

    on<NotificationsEventSendNotifications>((event, emit) async {
      try {
        emit(const NotificationsStateSendingNotifications());
        final tokens = await provider.allTokens();
        print(tokens);
        print('----------before');
        await provider.sendNotifications(tokens: tokens);
        print('----------after');
        emit(const NotificationsInitial());
      } catch (e) {
        print('failure');
        Fluttertoast.showToast(msg: 'Could not send notifications');
      }
    });
  }
}
