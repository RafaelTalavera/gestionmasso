// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDt14PRzr-a-vkksFTDfBaPm9ika2v3jwI',
    appId: '1:44569320465:web:f7f53baaacc95b7558a5b0',
    messagingSenderId: '44569320465',
    projectId: 'gmasso-bed73',
    authDomain: 'gmasso-bed73.firebaseapp.com',
    storageBucket: 'gmasso-bed73.appspot.com',
    measurementId: 'G-RNQ0GVDHH8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDCfSqV0Un-Ov_LbBYeCaH32T5kgMNL2ug',
    appId: '1:44569320465:android:dc3f04d73b41651458a5b0',
    messagingSenderId: '44569320465',
    projectId: 'gmasso-bed73',
    storageBucket: 'gmasso-bed73.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCwm5cv5DBt_fsu2xFZrddlDBn4NSLNwMs',
    appId: '1:44569320465:ios:bbdbdeada85c46b858a5b0',
    messagingSenderId: '44569320465',
    projectId: 'gmasso-bed73',
    storageBucket: 'gmasso-bed73.appspot.com',
    iosBundleId: 'app.gestionmasso.gestionmasso',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCwm5cv5DBt_fsu2xFZrddlDBn4NSLNwMs',
    appId: '1:44569320465:ios:bbdbdeada85c46b858a5b0',
    messagingSenderId: '44569320465',
    projectId: 'gmasso-bed73',
    storageBucket: 'gmasso-bed73.appspot.com',
    iosBundleId: 'app.gestionmasso.gestionmasso',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDt14PRzr-a-vkksFTDfBaPm9ika2v3jwI',
    appId: '1:44569320465:web:145ce4a03f82177658a5b0',
    messagingSenderId: '44569320465',
    projectId: 'gmasso-bed73',
    authDomain: 'gmasso-bed73.firebaseapp.com',
    storageBucket: 'gmasso-bed73.appspot.com',
    measurementId: 'G-SR27S7XFQT',
  );
}
