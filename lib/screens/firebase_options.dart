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
    apiKey: 'AIzaSyAeYS56_HGB9tdlWnY5qmPgM8KEp29SfZQ',
    appId: '1:517564042901:web:f1e5af415303972f29959c',
    messagingSenderId: '517564042901',
    projectId: 'runningcrew-4fb73',
    authDomain: 'runningcrew-4fb73.firebaseapp.com',
    storageBucket: 'runningcrew-4fb73.appspot.com',
    measurementId: 'G-95XM5EN50W',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCNRAcmwowq1t21csaNS0E8PbWOCN1v0g4',
    appId: '1:517564042901:android:30354cbde691b7e529959c',
    messagingSenderId: '517564042901',
    projectId: 'runningcrew-4fb73',
    storageBucket: 'runningcrew-4fb73.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB2fGOR6yBKd-oFTW1pCIZ2QeHCJ-m4T6c',
    appId: '1:517564042901:ios:50c56a54bf36fd1d29959c',
    messagingSenderId: '517564042901',
    projectId: 'runningcrew-4fb73',
    storageBucket: 'runningcrew-4fb73.appspot.com',
    iosBundleId: 'com.example.runningCrew',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB2fGOR6yBKd-oFTW1pCIZ2QeHCJ-m4T6c',
    appId: '1:517564042901:ios:50c56a54bf36fd1d29959c',
    messagingSenderId: '517564042901',
    projectId: 'runningcrew-4fb73',
    storageBucket: 'runningcrew-4fb73.appspot.com',
    iosBundleId: 'com.example.runningCrew',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAeYS56_HGB9tdlWnY5qmPgM8KEp29SfZQ',
    appId: '1:517564042901:web:ee03e9033f81a39a29959c',
    messagingSenderId: '517564042901',
    projectId: 'runningcrew-4fb73',
    authDomain: 'runningcrew-4fb73.firebaseapp.com',
    storageBucket: 'runningcrew-4fb73.appspot.com',
    measurementId: 'G-K3WRL17MN1',
  );

}