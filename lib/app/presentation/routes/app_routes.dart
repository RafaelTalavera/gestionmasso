import 'package:flutter/material.dart';

import '../modules/formulario/views/formulario_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/sign_in/sign_in_view.dart';
import '../modules/splash/views/splash_view.dart';
import 'routes.dart';

Map<String, Widget Function(BuildContext)> get appRoutes {
  return {
    Routes.splash: (context) => const SplashView(),
    Routes.signIn: (context) => const SignInView(),
    Routes.home: (context) => const HomeView(),
    Routes.formularioAccid: (context) => const FormularioAccid(),
    Routes.table: (contetx) => Table(),
  };
}
