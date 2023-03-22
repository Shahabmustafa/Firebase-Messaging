import 'package:cloude_firestore/notification_services.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  NotificationServices notificationServices = NotificationServices();

   @override
  void initState() {
    // TODO: implement initState
     notificationServices.requestNotificationPermission();
     notificationServices.firebaseInit();
     // notificationServices.isTokenRefresh();
     notificationServices.getDeviceToken().then((value){
       print('Device Token>>>>${value}');
     }).onError((error, stackTrace){
       print(error.toString());
     });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
    );
  }
}
