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
    apiKey: 'AIzaSyCGMOsjt7OTvMLq7YXd6Gwi_EUne040HYE',
    appId: '1:209293867042:android:096a585be144cb9929b27b',
    messagingSenderId: '209293867042',
    projectId: 'chatter-app-1fd07',
    storageBucket: 'chatter-app-1fd07.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCbikqervP6aLe8pa3xoNGfpyEgcqXEXcE',
    appId: '1:209293867042:ios:407f25bbba76a9dc29b27b',
    messagingSenderId: '209293867042',
    projectId: 'chatter-app-1fd07',
    storageBucket: 'chatter-app-1fd07.appspot.com',
    androidClientId: '209293867042-79vsr4vhupa4e7s1nc4d07bf4m8bdl2j.apps.googleusercontent.com',
    iosClientId: '209293867042-mra8a3ta3cnqvq23gednumq8lmmsu06i.apps.googleusercontent.com',
    iosBundleId: 'com.example.mapWater',
  );
}
