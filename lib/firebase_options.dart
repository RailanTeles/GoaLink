import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAQb8TZMszuzhVDMej_OR4_wmjfRkbg-0k',
    appId: '1:15014301618:android:d40659dbdd0b61fe3e1eab',
    messagingSenderId: '15014301618',
    projectId: 'goalink-67254',
    storageBucket: 'goalink-67254.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyChR3twULqZTJb2ulEq-LfdeH4WGDxHvc8',
    appId: '1:15014301618:ios:a8b2aab08e4c31843e1eab',
    messagingSenderId: '15014301618',
    projectId: 'goalink-67254',
    storageBucket: 'goalink-67254.firebasestorage.app',
    iosBundleId: 'com.example.goalink',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBvacMXZ19gm2UATHfjd0lWgvJ7xy18o4g',
    appId: '1:15014301618:web:28058dc4ad9616e13e1eab',
    messagingSenderId: '15014301618',
    projectId: 'goalink-67254',
    authDomain: 'goalink-67254.firebaseapp.com',
    storageBucket: 'goalink-67254.firebasestorage.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyChR3twULqZTJb2ulEq-LfdeH4WGDxHvc8',
    appId: '1:15014301618:ios:a8b2aab08e4c31843e1eab',
    messagingSenderId: '15014301618',
    projectId: 'goalink-67254',
    storageBucket: 'goalink-67254.firebasestorage.app',
    iosBundleId: 'com.example.goalink',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBvacMXZ19gm2UATHfjd0lWgvJ7xy18o4g',
    appId: '1:15014301618:web:2251f7bfaee93a523e1eab',
    messagingSenderId: '15014301618',
    projectId: 'goalink-67254',
    authDomain: 'goalink-67254.firebaseapp.com',
    storageBucket: 'goalink-67254.firebasestorage.app',
  );

}