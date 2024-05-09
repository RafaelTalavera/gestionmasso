import 'package:flutter/material.dart';

class NotificacaoPage extends StatelessWidget {
  const NotificacaoPage({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 254, 174),
      appBar: AppBar(
        title: const Text('Novidades'),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.message_outlined,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Novidades após a Notificação Push! ',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes llamar a la función showNotification
              },
              child: const Text('Mostrar notificación'),
            ),
          ],
        ),
      ),
    );
  }
}
