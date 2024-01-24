import 'package:flutter/material.dart';
import 'package:gestionmasso/app/presentation/routes/app_routes.dart';
import 'package:gestionmasso/app/presentation/routes/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Routes.splash,
      routes: appRoutes,
    );
  }
}
