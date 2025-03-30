import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Request permission for iOS
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');

    // Initialize Local Notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);
    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    // Foreground Notification Listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message.notification?.title, message.notification?.body);
    });
  }

  static Future<void> _showNotification(String? title, String? body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  static Future<void> sendPushNotification(String token, String title, String body) async {
    const String serverKey = 'YOUR_FIREBASE_SERVER_KEY';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    final payload = {
      'to': token,
      'notification': {
        'title': title,
        'body': body,
        'sound': 'default',
      },
    };

    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: headers,
      body: jsonEncode(payload),
    );

    print("Notification sent: ${response.body}");
  }
}