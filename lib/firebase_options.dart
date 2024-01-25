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
    apiKey: 'AIzaSyAtnmQLbFIUaJW_j0bHJKP5XpcYhaMr26M',
    appId: '1:246117889740:android:e656212e1cf3c57d387469',
    messagingSenderId: '246117889740',
    projectId: 'project-1-d9f81',
    storageBucket: 'project-1-d9f81.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCLrSLulc5J3hcHhgYWSfHP8WEh2X8zE1I',
    appId: '1:246117889740:ios:a0feda9bb8af692b387469',
    messagingSenderId: '246117889740',
    projectId: 'project-1-d9f81',
    storageBucket: 'project-1-d9f81.appspot.com',
    androidClientId: '246117889740-vgm2v3psqiljacd3h6qe7i6j6l799e6l.apps.googleusercontent.com',
    iosClientId: '246117889740-73mku638do9iaba9gj559ilndefvna1t.apps.googleusercontent.com',
    iosBundleId: 'com.asiayeshit.booktheraCustomer',
  );
}
