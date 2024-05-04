import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../presentation/routes/routes.dart';
import '../remote/token_manager.dart';
import 'notification_service.dart';

class FirebaseMessagingService {
  final NotificationService _notificationService;

  FirebaseMessagingService(this._notificationService);

  Future<void> initialize() async {
    debugPrint('Initializing Firebase Messaging Service...');
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      badge: true,
      sound: true,
      alert: true,
    );
    await getDeviceFirebaseToken();
    _onMessage();
    _onMessageOpenedApp();
  }

  Future<void> getDeviceFirebaseToken() async {
    final tokenFirebase = await FirebaseMessaging.instance.getToken();

    String? token = await TokenManager.getToken();
    if (token != null) {
      sendTokenToBackend(tokenFirebase, token);
    } else {
      debugPrint('Error: Token de autenticación nulo');
    }
  }

  Future<void> sendTokenToBackend(String? tokenFirebase, String token) async {
    if (tokenFirebase != null) {
      final url = Uri.parse('http://10.0.2.2:8080/api/users/firebase');

      try {
        final response = await http.put(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'firebase': tokenFirebase,
          }),
        );

        if (response.statusCode == 200) {
        } else {}
        // ignore: empty_catches
      } catch (error) {}
    } else {}
  }

  void _onMessage() {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _notificationService.showLocalNotification(
          CustomNotification(
            id: android.hashCode,
            title: notification.title!,
            body: notification.body!,
            payload: message.data['route'] ?? '',
          ),
        );
      }
    });
  }

  void _onMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen(_goToPageAfterMessage);
  }

  void _goToPageAfterMessage(RemoteMessage message) {
    final String route = message.data['route'] ?? '';
    if (route.isNotEmpty) {
      Routes.navigatorKey.currentState?.pushNamed(route);
    }
  }
}
