import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import 'cloud_device_token.dart';
import 'firebase/firebase_cloud_storage.dart';

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
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  void _saveToken({required String token, required String userId,}) async {
    await _cloudStorage.saveToken(token: token, userId: userId);
  }

  void getToken({required String userId,}) async {
    await FirebaseMessaging.instance.getToken().then((token) async {
      _saveToken(token: token!, userId: userId);
    });
  }

  Future<Iterable<CloudDeviceToken>> allTokens() async {
    final tokens = await _cloudStorage.allTokens().timeout(const Duration(seconds: 1), onTimeout: (sink) {

    }).first;
    return tokens;
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
    final fcmUrl = dotenv.get('FCM_API_URL', fallback: "");
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