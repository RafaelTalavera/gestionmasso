import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/timezone.dart' as tz;

import '../../../../data/services/notification/notification_service.dart';
import '../../../../data/services/remote/token_manager.dart';
import '../../../routes/routes.dart';
import '../sources/extimguisher_table.dart';

class DataFetcher {
  DataFetcher(GlobalKey<NavigatorState> navigatorKey);

  Future<void> fetchDataAndNotify() async {
    try {
      String? token = await TokenManager.getToken();

      final url = Uri.parse('http://10.0.2.2:8080/api/extinguishers/list');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData =
            json.decode(utf8.decode(response.bodyBytes));

        List<Extimguisher> extimguishers =
            jsonData.map((json) => Extimguisher.fromJson(json)).toList();

        // Verificar el vencimiento de cada extintor
        for (Extimguisher extimguisher in extimguishers) {
          if (extimguisher.diferenciaEnDias <= 0) {
            // Si el vencimiento es posterior a la fecha actual, emitir una notificación
            emitNotification(extimguisher);
          }
        }
      } else {
        throw Exception('Error al cargar datos desde el backend');
      }
    } catch (error) {}
  }

  void emitNotification(Extimguisher extimguisher) {
    const androidDetails = AndroidNotificationDetails(
      'lembretes_notifications_details',
      'Lembretes',
      channelDescription: 'Este canal é para lembretes!',
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const InitializationSettings android = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    flutterLocalNotificationsPlugin.initialize(
      android,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          // Si el payload es Routes.notification, navegar a la página de notificación
          if (payload == Routes.notification) {
            // Obtener el contexto del navigatorKey

            // Navegar a la página de notificación
            Routes.navigatorKey.currentState!.pushNamed(payload);
          }
        }
      },
    );

    final notification = CustomNotification(
      id: extimguisher.extId.hashCode,
      title: 'Extintor Vencido',
      body:
          'El extintor de ${extimguisher.nameOrganization} en el sector ${extimguisher.sector} con ID ${extimguisher.extId} está vencido.',
      payload: Routes.home,
    );

    final date = DateTime.now().add(const Duration(seconds: 5));

    flutterLocalNotificationsPlugin.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      tz.TZDateTime.from(date, tz.local),
      const NotificationDetails(
        android: androidDetails,
      ),
      payload: notification.payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
