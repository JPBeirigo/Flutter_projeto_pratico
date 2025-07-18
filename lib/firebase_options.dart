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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCkTyCZXvUWPDHWUSVHCsebcvjkxYC3UwA',
    appId: '1:607055345150:web:ad67b721ac5939f97b7caf',
    messagingSenderId: '607055345150',
    projectId: 'projeto-final-997de',
    authDomain: 'projeto-final-997de.firebaseapp.com',
    storageBucket: 'projeto-final-997de.firebasestorage.app',
    measurementId: 'G-2VTKV546ZW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAt0DRsq_awmVjGCU6XRk0TB8H-2hV0his',
    appId: '1:607055345150:android:0c1f4a67fb00966f7b7caf',
    messagingSenderId: '607055345150',
    projectId: 'projeto-final-997de',
    storageBucket: 'projeto-final-997de.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCq_nI6Ht57UCRLVEEVYq2jG2Y4YebvftM',
    appId: '1:607055345150:ios:fc513da864e8fed27b7caf',
    messagingSenderId: '607055345150',
    projectId: 'projeto-final-997de',
    storageBucket: 'projeto-final-997de.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

}