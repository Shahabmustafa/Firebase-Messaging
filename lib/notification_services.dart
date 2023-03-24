import 'dart:math';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices{

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Mobile Request Notification Permissions
  void requestNotificationPermission()async{
    NotificationSettings setting = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      sound: true,
      provisional: true,
      criticalAlert: true,
    );

    if(setting.authorizationStatus == AuthorizationStatus.authorized){
      print('User granted Permission');
    }else if(setting.authorizationStatus == AuthorizationStatus.provisional){
      print('User granted Provisional Permission');
    }else{
      AppSettings.openNotificationSettings();
      print('User denied Permission');
    }
  }


  void initLocalNotification(BuildContext context,RemoteMessage message)async{
    var androidInitalizationSetting = const AndroidInitializationSettings('mipmap/ic_launcher');
    var iosInitalizationSetting = const DarwinInitializationSettings();
    var initalizationSetting = InitializationSettings(
      android: androidInitalizationSetting,
      iOS: iosInitalizationSetting,
    );
    await _flutterLocalNotificationsPlugin.initialize(
        initalizationSetting,
        onDidReceiveNotificationResponse: (payload){
      }
    );
  }

  void firebaseInit(){
    FirebaseMessaging.onMessage.listen((message) {
      if(kDebugMode){
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
      }
      showNotification(message);
    });
  }

  Future<void> showNotification(RemoteMessage message)async{

    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        'High Important Notification',
      importance: Importance.max
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'Your channel Description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero,(){
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails,
      );
    }
    );
  }

  // Get Device Token
  Future<String?> getDeviceToken()async{
    String? token = await messaging.getToken();
    return token;
  }

  // Token Refresh
  Future<String?> isTokenRefresh()async{
    messaging.onTokenRefresh.listen((event) {
     event.toString();
     print(event);
    });
  }
}