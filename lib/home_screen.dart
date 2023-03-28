import 'dart:convert';

import 'package:cloude_firestore/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
     notificationServices.firebaseInit(context);
     notificationServices.setupInteractMessage(context);
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: TextButton(
                onPressed: (){
                  notificationServices.getDeviceToken().then((value)async{
                    var data = {
                      'to' : value.toString(),
                      'priority' : 'high',
                      'notification' : {
                        'title' : 'Kitoob App',
                        'body' : 'Flutter Fire',
                      }
                    };
                    await http.post(Uri.parse('http://fcm.googleapis.com/fcm/send'),
                      body: jsonEncode(data),
                      headers: {
                      "Content-Type" : "application/json; charset=UTF-8",
                        "Authorization" : 'AAAAhUZO6WE:APA91bHo0iLmC9O2SMGqbFpZO6Lcy02SwKd2qLfd5cWRqEtthF6-Pl2qjHVdy1cCkeSYYSi-p8xbYartGPM7MH3K__jayFPefvzhK5Sb_2F0LHl5GQwgd1Cnp6caitSdN5J_7vOXE4Xa',

                      }
                    );
                  });
                },
                child: Text('Notification Send')),
          )
        ],
      ),
    );
  }
}
