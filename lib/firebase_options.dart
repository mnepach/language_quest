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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for iOS - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBJN2cvccyojqVirGUHBaDV-xloPAmmGNw',
    appId: '1:994019244347:web:734b2f91dd2fc09ada1f1e',
    messagingSenderId: '994019244347',
    projectId: 'language-quest-d7abc',
    authDomain: 'language-quest-d7abc.firebaseapp.com',
    storageBucket: 'language-quest-d7abc.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDLlm80bca88lX1ekhUvSdEs0wTrPXtSzw',
    appId: '1:994019244347:android:ebaf1f316c75a4dcda1f1e',
    messagingSenderId: '994019244347',
    projectId: 'language-quest-d7abc',
    storageBucket: 'language-quest-d7abc.firebasestorage.app',
  );
}