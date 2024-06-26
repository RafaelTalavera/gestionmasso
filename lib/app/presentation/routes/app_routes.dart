import 'package:flutter/material.dart';

import '../../data/services/notification/notificacao_page.dart';
import '../modules/event/form_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/risk/views/risk_form_views.dart';
import '../modules/sign_in/sign_in_view.dart';
import '../modules/splash/views/splash_view.dart';
import 'routes.dart';

Map<String, Widget Function(BuildContext)> get appRoutes {
  return {
    Routes.splash: (context) => const SplashView(),
    Routes.signIn: (context) => const SignInView(),
    Routes.home: (context) => const HomeView(),
    Routes.formularioAccid: (context) => const FormularioAccid(),
    Routes.table: (context) => Table(),
    Routes.riesgo: (context) => const RiskPage(
          initialCompany: '',
          id: '',
          name: '',
        ),
    Routes.notification: (context) => const NotificacaoPage(),
  };
}
