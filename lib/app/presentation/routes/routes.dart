import 'package:flutter/material.dart';

class Routes {
  Routes._(); //constructor privado no se instancia.

  static const splash = '/splash';
  static const signIn = '/sign-in';
  static const home = '/home';
  static const formularioAccid = '/formulario';
  static const riesgo = '/riesgo';
  static const causa = '/causa';
  static const table = '/table';

  static const notification = '/notification';

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
