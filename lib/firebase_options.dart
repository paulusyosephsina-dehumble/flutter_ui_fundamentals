// File generated manually for Firebase configuration
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
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDfaKx6FvmprWIQT0KqV9vHMOT-36zEE38',
    appId: '1:365104189891:web:4be85294cbd0d70a80ad76',
    messagingSenderId: '365104189891',
    projectId: 'kosfinder-app',
    authDomain: 'kosfinder-app.firebaseapp.com',
    storageBucket: 'kosfinder-app.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDfaKx6FvmprWIQT0KqV9vHMOT-36zEE38',
    appId: '1:365104189891:android:4be85294cbd0d70a80ad76',
    messagingSenderId: '365104189891',
    projectId: 'kosfinder-app',
    storageBucket: 'kosfinder-app.firebasestorage.app',
  );
}
