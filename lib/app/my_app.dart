import 'package:flutter/material.dart';
import '../main.dart';
import 'presentation/routes/app_routes.dart';
import 'presentation/routes/routes.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _AppState();
}

class _AppState extends State<MyApp> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      initilizeFirebaseMessaging();
      checkNotifications();
      _initialized = true;
    }
  }

  initilizeFirebaseMessaging() async {
    final firebaseMessagingService =
        Injector.of(context, listen: false).firebaseMessagingService;
    await firebaseMessagingService.initialize();
  }

  checkNotifications() async {
    final notificationService =
        Injector.of(context, listen: false).notificationService;
    await notificationService.checkForNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        initialRoute: Routes.splash,
        routes: appRoutes,
      ),
    );
  }
}
