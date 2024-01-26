import 'package:flutter/material.dart';
import 'package:gestionmasso/app/presentation/routes/routes.dart';

import 'package:gestionmasso/main.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPersistentFrameCallback(
      (_) {
        _init();
      },
    );
  }

  Future<void> _init() async {
    final injector = Injector.of(context);
    final connetivityRepository = injector.connectivityRepository;
    final hasInternet = await connetivityRepository.hasInternet;
    print(' 😃 hasInternet $hasInternet');

    if (hasInternet) {
      final authenticationRepository = injector.authenticationRepository;
      final isSignedIn = await authenticationRepository.isSignedIn;
      if (isSignedIn) {
        final user = await authenticationRepository.getUserData();
        if (mounted) {
          if (user != null) {
            //home
            _doTo(Routes.home);
          } else {
            _doTo(Routes.signIn);
          }
        }
      } else if (mounted) {
        _doTo(Routes.signIn);
      }
    } else {}
  }

  void _doTo(String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(),
        ), //indicador de carga
      ),
    );
  }
}
