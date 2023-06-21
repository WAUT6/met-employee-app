import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:metapp/services/cloud/firebase_cloud_storage.dart';
import 'package:http/http.dart' as http;

import 'cloud_device_token.dart';

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
    Iterable<CloudDeviceToken> tokens = [];
    await for(var event in _cloudStorage.allTokens()) {
      for (var token in event) {
        tokens = [...tokens, token];
      }
    }
    return tokens;
  }

  Future<void> sendNotifications({required Iterable<CloudDeviceToken> tokens,}) async {
    List<String> tokensString = [];
    for(var token in tokens) {
      tokensString.add(token.token);
    }
    final Map<String, dynamic> notification = {
      'title': 'Notification Title',
      'body': 'Notification Body',
      'sound': 'default',
    };
    const String serverKey = 'nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDhEa86h5uCRJcKs822X10tnTGfGXo2SoAFCpsRmT6oMpFbBKsZKoIaElLJD8pA2ZOudvsrfDQTMXC/GpsjdBahnpKQpWnec6si56ScoecbZhh8CR0ga0Gc95doklsX1SCRSjyJhAGIQHuVC5UDpBEMZSyLl+l+r2Hb1dJZcC5CE0u9l9Wqc3juSIaCtyne/dOlVuIzIIV2zWcaeEvAUPXHig5wzHyn+dxDGvRCxISzpLVsrl/QE4OB8xg7R8KHQr94r5/a+38a5RXaarNy55qC6n2ekAp7aauPTiVmjiV/diI/X91MTCChBdGkjhu935I0HyZCiF4JYx5J5RsuP4ATAgMBAAECggEASEySghZCxbd736O/vshmmbsH0ChyglMvSa9M/fvAzW4lFFxtDBIEJhThxBXO7kMWdjJhX+gvoES/B5yn3l0x0ewq/80rM5rrjDRmRCycHUiQL/QLh7j8pExCtoRhP8gmhJWY2cHubhLswAWu8jL3iQhNJXCAwMHdCS3oOvPW4EFRWTM93xbgtch+iu8TRLwDK2+C13btx+dIqlD2nwmLotig1SpCXQLXEWKsySlfiht3goHn3wqaFkOIE3BrQjGRhbg6Dx0l/MPLgLMhrsWT5YrSJEytxahnIgqms9lQy0KOqMMLGefeySotcE+mao1/tRgKOgvQIC4+6savc4xbCQKBgQDwnVfgvpVuloN1Z4zetp1DHLpoOVhayG32WeRzRsRP6HPRCJsjhGc/2XyvtrESwGQmxOyPKM0iruwbydaJfdfTXMJVxdME/kvSSBU+75aJxvrpXSWaPrIyu/7wNN07RgRjcS/Nv9uj1VYfYU0Ta5IPkgnTgG2+cCU++BiQ/vpFGwKBgQDvdd+4lDuUAU8lh6NCcoUVHAgew2YUn/M+zbPoCik8uX2kEipJ90oQIZXHJ4pkfT6g4jGAMNq2GsUyKq1BM27OCKHFnNsgImCbXg/lFHfj9AP2l7Sy+tAimVhOf80U/x0+9nDy1Uv+JeVy3cVi1rDIMAl5t9J5watfZS/d2WX4aQKBgQDHMnu+JAmyNAlA+Sk2eBhZpz7rag4rmiLvAByREtUTEm5Pb8B/9u1Dftoq3iRaUcyYDA+LtUuemxH9L2vdB8HVycVZHR1F1QEQZXyxTchi58hxyhuHRsBgICM+2YUNvTmE2f+pZlx/le5mrDcTDMsu+MgJwRkZv94V827jGzQ2YQKBgQDIrNXiD4emTzqOzw7IfsR8nlNHxKTln+3vsd+VE/7e/uwF9ZsvBWgyAJNOpRpbgIJdvXGSZl7DwceEdTNgssOnMqCvxPX2BhlD2x4i8nZOuI4ht50daQfIFw5kKsIpWGqf+1NIjevzfrq8+pGSdS0NdwRZ1u0yUFVXyqrElo3YEQKBgAyOQwa0R/iSAN/rrlz8AUYIlYdObRwEZ0+e5dO7KHt0EnisHBmfRBSqWJwM9ieQehDg2UKf4Xdkz8fiitaTzcblpuFvJEgEw3NcxTRznXe3D3folWWEUP+YsJoBpLCZY/+xdeUi6HbE1dtZER9sssdjkfFAz5hPtnZOCkxQRtd';
    const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

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
      print('success');
    } else {
      print(response.statusCode);
      print('error occured');
    }
  }

}