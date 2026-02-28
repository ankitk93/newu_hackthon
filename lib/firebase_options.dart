import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Firebase configuration options for each platform.
/// Generated from your Firebase project settings.
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Android config — from google-services.json
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCUBsRAhCcrUhvUygqnIw6jpZVppkGpNPg',
    appId: '1:113233820973:android:f0367725425903b30867a4',
    messagingSenderId: '113233820973',
    projectId: 'newu-hackathon-78542',
    storageBucket: 'newu-hackathon-78542.firebasestorage.app',
  );

  // iOS config — update these after adding iOS app in Firebase Console
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: '113233820973',
    projectId: 'newu-hackathon-78542',
    storageBucket: 'newu-hackathon-78542.firebasestorage.app',
    iosBundleId: 'com.newu.newuHealth',
  );

  // Web config — update after adding Web app in Firebase Console
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: 'YOUR_WEB_APP_ID',
    messagingSenderId: '113233820973',
    projectId: 'newu-hackathon-78542',
    storageBucket: 'newu-hackathon-78542.firebasestorage.app',
    authDomain: 'newu-hackathon-78542.firebaseapp.com',
  );
}
