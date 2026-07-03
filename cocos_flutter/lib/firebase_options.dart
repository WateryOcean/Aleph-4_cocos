// File yang dihasilkan oleh FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// [FirebaseOptions] default untuk digunakan dengan aplikasi Firebase Anda.
///
/// Contoh:
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
    apiKey: 'AIzaSyBYRvBlb0UoDOlarLSof1duWDgFQsAwqSg',
    appId: '1:350431289250:web:0290e0bb7bca6ce2785cfb',
    messagingSenderId: '350431289250',
    projectId: 'cocos-f8c40',
    authDomain: 'cocos-f8c40.firebaseapp.com',
    storageBucket: 'cocos-f8c40.firebasestorage.app',
    measurementId: 'G-26RH63WK82',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBiGoF9HAmvLWHBJbUiCMnlbzae7v23ilM',
    appId: '1:350431289250:android:21b9a2a10dba7b06785cfb',
    messagingSenderId: '350431289250',
    projectId: 'cocos-f8c40',
    storageBucket: 'cocos-f8c40.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCMmb1rn-29lRBSFh7dqA-E8fSQgEjqUP0',
    appId: '1:350431289250:ios:4c213445dbfd4ac3785cfb',
    messagingSenderId: '350431289250',
    projectId: 'cocos-f8c40',
    storageBucket: 'cocos-f8c40.firebasestorage.app',
    iosClientId: '350431289250-bl3qv17meij3a2iui1jqkrtrnjevbar1.apps.googleusercontent.com',
    iosBundleId: 'com.example.cocosFlutter',
  );
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCMmb1rn-29lRBSFh7dqA-E8fSQgEjqUP0',
    appId: '1:350431289250:ios:4c213445dbfd4ac3785cfb',
    messagingSenderId: '350431289250',
    projectId: 'cocos-f8c40',
    storageBucket: 'cocos-f8c40.firebasestorage.app',
    iosClientId: '350431289250-bl3qv17meij3a2iui1jqkrtrnjevbar1.apps.googleusercontent.com',
    iosBundleId: 'com.example.cocosFlutter',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBYRvBlb0UoDOlarLSof1duWDgFQsAwqSg',
    appId: '1:350431289250:web:f070a2258475ff21785cfb',
    messagingSenderId: '350431289250',
    projectId: 'cocos-f8c40',
    authDomain: 'cocos-f8c40.firebaseapp.com',
    storageBucket: 'cocos-f8c40.firebasestorage.app',
    measurementId: 'G-9Q6E57XF0Z',
  );
}
