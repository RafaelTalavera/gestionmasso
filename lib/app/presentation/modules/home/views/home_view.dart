import 'package:flutter/material.dart';
import 'package:gestionmasso/app/presentation/routes/routes.dart';
import 'package:gestionmasso/main.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () async {
            Injector.of(context).authenticationRepository.singOut();
            Navigator.pushReplacementNamed(
              context,
              Routes.signIn,
            );
          },
          child: const Text('Sign out'),
        ),
      ),
    );
  }
}
