import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';

class PushNotification extends ChangeNotifier{
  late String token;

  getToken() async {
    token = (await FirebaseMessaging.instance.getToken())!;
    debugPrint('Token => $token');
  }

  getNotification(context) {
    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = const DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false, requestAlertPermission: false);
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid,iOS: initializationSettingsIOS,);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;

      if (notification != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: "@mipmap/ic_launcher",
              ),
              iOS: const DarwinNotificationDetails(),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // RemoteNotification? notification = message.notification;
      // AndroidNotification? android = message.notification?.android;
      // DarwinNotificationDetails? ios = message.notification?.apple as DarwinNotificationDetails?;
    });
    getToken();
  }

  sendPushNotification(notificationToken,bookName,bookDescription) async{
    final msg = jsonEncode({
      "registration_ids": <String>[
        "$notificationToken",
      ],
      "notification": {
        "title": "$bookName",
        "body": "$bookDescription",
        "android_channel_id": "schoolsupplies-5cf3f",
        "sound": true,
      },
    });

    try {
      var response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Authorization': 'key=AAAAQVc6cuQ:APA91bHReqAaTXUpNIX2Xm7sAu9yMvAXz-apvKEqaQFxCZJ0WZ_DxgNB-kqnu22U8--WgIs08u4nImPpsCj7atLFB00MbLGihMEy0eme5cJTKmm5JTjDDlNNbhuCifTOBK6JR_VSZMkY',
          'Content-Type': 'application/json'
        },
        body: msg,
      );

      if(response.statusCode==200){
        debugPrint("Notification Send");
      }
      else{
        debugPrint("Notification Send Error");
      }
    }catch(e){
      debugPrint("Debug print Catch $e");
    }
  }
}
