import 'package:flutter/material.dart';
import 'package:gestionmasso/app/data/repositories_implementation/authentication_repository_impl.dart';
import 'package:gestionmasso/app/data/repositories_implementation/connectivity_repostory_impl.dart';
import 'package:gestionmasso/app/domain/repositories/authentication_repositoty.dart';
import 'package:gestionmasso/app/my_app.dart';
import 'package:gestionmasso/app/domain/repositories/connectivity_repository.dart';

void main() {
  runApp(
    Injector(
      connectivityRepository: ConnectivityRepositoryImpl(),
      authenticationRepository: AuthenticationRepositoryImpl(),
      child: const MyApp(),
    ),
  );
}

class Injector extends InheritedWidget {
  const Injector({
    super.key,
    required super.child,
    required this.connectivityRepository,
    required this.authenticationRepository,
  });

  final ConnetivityRepository connectivityRepository;
  final AuthenticationRepository authenticationRepository;

  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(_) => false;

  static Injector of(BuildContext context) {
    final injector = context.dependOnInheritedWidgetOfExactType<Injector>();
    assert(injector != null, 'Injector could not be found');
    return injector!;
  }
}
