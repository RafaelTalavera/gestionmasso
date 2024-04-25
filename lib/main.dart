import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'app/data/repositories_implementation/authentication_repository_impl.dart';
import 'app/data/repositories_implementation/connectivity_repostory_impl.dart';
import 'app/data/services/remote/internet_checker.dart';
import 'app/domain/repositories/authentication_repository.dart';
import 'app/my_app.dart';
import 'app/domain/repositories/connectivity_repository.dart';

void main() {
  runApp(
    Injector(
      connectivityRepository: ConnectivityRepositoryImpl(
        Connectivity(),
        InternetChecker(),
      ),
      authenticationRepository: AuthenticationRepositoryImpl(
        const FlutterSecureStorage(),
      ),
      autoOpenKeyboard: true, 
      child: const MyApp(),
    ),
  );
}

class Injector extends InheritedWidget {
  const Injector({
    super.key,
    required super.child, // Cambiar el nombre del parámetro a 'child'
    required this.connectivityRepository,
    required this.authenticationRepository,
    required this.autoOpenKeyboard, // Agregar la variable global aquí
  }); // Cambiar el nombre del parámetro a 'child'

  final ConnetivityRepository connectivityRepository;
  final AuthenticationRepository authenticationRepository;
  final bool autoOpenKeyboard; // Agregar la variable global aquí

  @override
  bool updateShouldNotify(_) => false;

  static Injector of(BuildContext context) {
    final injector = context.dependOnInheritedWidgetOfExactType<Injector>();
    assert(injector != null, 'Injector could not be found');
    return injector!;
  }
}
