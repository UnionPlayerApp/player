// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBhblIe4qqGPr-OyoxgZWdenstv0FShZB4',
    appId: '1:272934751386:android:8cca5a1574cef503486323',
    messagingSenderId: '272934751386',
    projectId: 'union-player-22857',
    storageBucket: 'union-player-22857.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDLjai35bThNW8yB73O5_xnIyQXSlwhCdY',
    appId: '1:272934751386:ios:3b6965125d627d1f486323',
    messagingSenderId: '272934751386',
    projectId: 'union-player-22857',
    storageBucket: 'union-player-22857.appspot.com',
    androidClientId: '272934751386-9a640u2rkrehhrf9u0ng6vqurpp4ahfg.apps.googleusercontent.com',
    iosClientId: '272934751386-musemj7ebpkml2mcgpl8dac29tlgk5qm.apps.googleusercontent.com',
    iosBundleId: 'com.chplalex.unionPlayerApp',
  );
}
