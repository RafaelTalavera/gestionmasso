import 'package:flutter/material.dart';
import 'package:gestionmasso/app/presentation/modules/splash/views/splash_view.dart';
import 'package:gestionmasso/app/presentation/routes/routes.dart';

Map<String, Widget Function(BuildContext)> get appRoutes {
  return {
    Routes.splash: (context) => const SplashView(),
  };
}
