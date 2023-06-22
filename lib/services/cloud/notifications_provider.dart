import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:metapp/services/cloud/firebase_cloud_storage.dart';
import 'package:http/http.dart' as http;

import 'cloud_device_token.dart';

class HTTPRequestFailedException implements Exception {}

class NotificationsProvider {
  final FirebaseCloudStorage _cloudStorage = FirebaseCloudStorage();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void initInfo() {
    var androidInitialize = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitialize = const InitializationSettings().iOS;
    var initializationSettings = InitializationSettings(iOS: iosInitialize, android: androidInitialize);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('onMessage: ${message.notification?.title}/${message.notification?.body}');

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );
      
      AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'MET',
        'MET',
        importance: Importance.max,
        styleInformation: bigTextStyleInformation,
        playSound: false,
        priority: Priority.max,
      );

      NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,

      );
      await _flutterLocalNotificationsPlugin.show(
          0,
          message.notification?.title,
          message.notification?.body,
          platformChannelSpecifics,
          payload: message.data['body'],
      );
    });
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings notificationSettings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if(notificationSettings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if(notificationSettings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User did not grant permission');
    }
  }

  void _saveToken({required String token, required String userId,}) async {
    await _cloudStorage.saveToken(token: token, userId: userId);
  }

  void getToken({required String userId,}) async {
    await FirebaseMessaging.instance.getToken().then((token) async {
      print(token);
      _saveToken(token: token!, userId: userId);
    });
  }

  Future<Iterable<CloudDeviceToken>> allTokens() async {
    return await _cloudStorage.allTokens().first;
  }

  Future<void> sendNotifications({required Iterable<CloudDeviceToken> tokens,}) async {
    List<String> tokensString = [];
    for(var token in tokens) {
      tokensString.add(token.token);
    }
    final Map<String, dynamic> notification = {
      'title': 'New Order',
      'body': 'New order has been added',
      'sound': 'default',
    };
    const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
    final serverKey = dotenv.get('FCM_SERVER_KEY', fallback: "");

    final Map<String, dynamic> data = {
      'notification' : notification,
      'registration_ids' : tokensString,
    };

    final headers = {
      'Content-Type' : 'application/json',
      'Authorization' : 'key=$serverKey',
    };

    final response = await http.post(
      Uri.parse(fcmUrl),
      headers: headers,
      body: jsonEncode(data),
    );
    if(response.statusCode == 200) {
      return;
    } else {
      throw HTTPRequestFailedException();
    }
  }

}