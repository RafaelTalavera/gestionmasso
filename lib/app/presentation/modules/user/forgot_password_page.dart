import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Please enter your email address to reset your password:',
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendEmail,
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }

  void _sendEmail() async {
    final email = _emailController.text;

    // Configura el servidor SMTP de Hostinger
    final smtpServer = SmtpServer(
      'smtp.hostinger.com',
      username: 'recuperaciondeclave@gestionmasso.com',
      password: 'Lavoluntad2024*',
      port: 465,
      ssl: true,
    );

    // Crea el mensaje de correo electrónico
    final message = Message()
      ..from =
          const Address('recuperaciondeclave@gestionmasso.com', 'Gestión MASSO')
      ..recipients.add(email)
      ..subject = 'Password Reset'
      ..text =
          'Aquí está el enlace para restablecer tu contraseña'; // Personaliza el mensaje según sea necesario

    try {
      // Envía el correo electrónico
      final sendReport = await send(message, smtpServer);
      print('Correo electrónico enviado: ${sendReport.toString()}');

      // Muestra un mensaje de éxito en la interfaz de usuario
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Correo electrónico para restablecer la contraseña enviado exitosamente.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Si ocurre un error al enviar el correo electrónico, muestra un mensaje de error
      print('Error al enviar el correo electrónico: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Error al enviar el correo electrónico para restablecer la contraseña.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
