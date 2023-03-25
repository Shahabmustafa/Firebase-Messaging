import 'dart:math';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices{

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

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

  void firebaseInit(){
    FirebaseMessaging.onMessage.listen((event) {
      print(event.notification!.title.toString());
      print(event.notification!.body.toString());
      showNotification(event);
    });
  }

  void initLocalNotification(BuildContext context,RemoteMessage message)async{
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    // var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
      android: androidInitializationSettings,
      // iOS: iosInitializationSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (payload){

      }
    );
  }

  Future<void> showNotification(RemoteMessage message)async{


    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString() ,
      importance: Importance.max  ,
      showBadge: true ,
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString() ,
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high ,
      ticker: 'ticker' ,
      //  icon: largeIconPath
    );

    // const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
    //     presentAlert: true ,
    //     presentBadge: true ,
    //     presentSound: true
    // ) ;

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        // iOS: darwinNotificationDetails
    );

    Future.delayed(Duration.zero , (){
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });

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

  void handleMessage(BuildContext context,RemoteMessage message){


  }
}