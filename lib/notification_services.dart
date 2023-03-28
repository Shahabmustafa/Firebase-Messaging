import 'dart:io';
import 'dart:math';
import 'package:app_settings/app_settings.dart';
import 'package:cloude_firestore/chat_massege.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  void firebaseInit(BuildContext context){
    FirebaseMessaging.onMessage.listen((message) {
        if (kDebugMode) {
          print(message.notification!.title.toString());
          print(message.data.toString());
          print(message.data['type']);
          print(message.data['id']);
          print(message.notification!.body.toString());
        }
        if(Platform.isAndroid){
          initLocalNotification(context,message);
          showNotification(message);
        }
        showNotification(message);
    });
  }

  void initLocalNotification(BuildContext context,RemoteMessage message)async{
    var androidInitializationSettings = const AndroidInitializationSettings('@drawable/images');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (payload){
        handleMessage(context, message);
      }
    );
  }

  Future<void> showNotification(RemoteMessage message)async{
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'High Importance Notification',
      importance: Importance.max  ,
      showBadge: true ,
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id.toString(),
      channel.id.toString() ,
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high ,
      ticker: 'ticker' ,
      icon: '@drawable/images',
    );

    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails
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

  Future<void> setupInteractMessage(BuildContext context)async{

    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if(initialMessage != null){
      handleMessage(context,initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  void handleMessage(BuildContext context,RemoteMessage message){
    if(message.data['type'] == 'massage'){
      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatMessage(
        id: message.data['id'],
      )));
    }
  }
}