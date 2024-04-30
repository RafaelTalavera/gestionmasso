import 'package:flutter/material.dart';
import '../../../../main.dart';
import 'notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool valor = false;
  late NotificationService notificationService;

  @override
  void initState() {
    super.initState();
    notificationService = NotificationService(); // Pasar el contexto aquí
  }

  showNotification(NotificationService notificationService) {
    setState(() {
      valor = !valor;
      if (valor) {
        notificationService.showLocalNotification(
          CustomNotification(
            id: 1,
            title: 'Teste',
            body: 'Acesse o app!',
            payload: '/notificacion',
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final injector = Injector.of(context, listen: false);
    final notificationService = injector.notificationService;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 254, 174),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            child: ListTile(
              title: const Text('Lembrar-me mais tarde'),
              trailing: valor
                  ? Icon(Icons.check_box, color: Colors.amber.shade600)
                  : const Icon(Icons.check_box_outline_blank),
              onTap: () => showNotification(notificationService),
            ),
          ),
        ),
      ),
    );
  }
}
