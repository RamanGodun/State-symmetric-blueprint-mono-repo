import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 📦 [DotenvFirebaseOptions] — platform-aware FirebaseOptions from .env
/// ✅ Works across apps as long as .env keys are standardized.
/// 🔐 Make sure to call `await dotenv.load(fileName: ...)` before using.
//
final class DotenvFirebaseOptions {
  ///---------------------------
  const DotenvFirebaseOptions._();
  // /

  /// Chooses correct [FirebaseOptions] based on platform.
  static FirebaseOptions get currentPlatform {
    // if (kIsWeb) return _web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _android;
      case TargetPlatform.iOS:
        return _ios;
      case TargetPlatform.macOS:
        throw UnsupportedError('macOS not supported via DotenvFirebaseOptions');
      case TargetPlatform.windows:
        throw UnsupportedError(
          'Windows not supported via DotenvFirebaseOptions',
        );
      case TargetPlatform.linux:
        throw UnsupportedError('Linux not supported via DotenvFirebaseOptions');
      case TargetPlatform.fuchsia:
        throw UnimplementedError(
          'Fuchsia not supported via DotenvFirebaseOptions',
        );
    }
  }

  // Reads first non-empty value among provided keys, otherwise throws clear error.
  static String _require(String what, List<String> keys) {
    for (final k in keys) {
      final v = dotenv.env[k];
      if (v != null && v.isNotEmpty) return v;
    }
    throw StateError(
      'Missing $what in .env. Tried keys: ${keys.join(', ')}.\n'
      'Make sure you loaded the correct .env BEFORE accessing FirebaseOptions.',
    );
  }

  // 🤖 Android from .env
  @pragma('vm:prefer-inline')
  static FirebaseOptions get _android => FirebaseOptions(
    apiKey: _require('FIREBASE API KEY (Android)', [
      'FIREBASE_API_KEY_ANDROID',
      'FIREBASE_API_KEY',
    ]),
    appId: _require('FIREBASE APP ID (Android)', [
      'FIREBASE_APP_ID_ANDROID',
      'FIREBASE_APP_ID',
    ]),
    projectId: _require('FIREBASE PROJECT ID', ['FIREBASE_PROJECT_ID']),
    messagingSenderId: _require('FIREBASE MESSAGING SENDER ID', [
      'FIREBASE_MESSAGING_SENDER_ID',
    ]),
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'],
  );

  // 🍏 iOS from .env
  @pragma('vm:prefer-inline')
  static FirebaseOptions get _ios => FirebaseOptions(
    apiKey: _require('FIREBASE API KEY (iOS)', [
      'FIREBASE_API_KEY_IOS',
      'FIREBASE_API_KEY',
    ]),
    appId: _require('FIREBASE APP ID (iOS)', [
      'FIREBASE_APP_ID_IOS',
      'FIREBASE_APP_ID',
    ]),
    projectId: _require('FIREBASE PROJECT ID', ['FIREBASE_PROJECT_ID']),
    messagingSenderId: _require('FIREBASE MESSAGING SENDER ID', [
      'FIREBASE_MESSAGING_SENDER_ID',
    ]),
    iosBundleId: dotenv.env['FIREBASE_IOS_BUNDLE_ID'],
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'],
  );

  /*
  ? Optional web:
  @pragma('vm:prefer-inline')
  static FirebaseOptions get _web => FirebaseOptions(
    apiKey: _require('FIREBASE API KEY (Web)', ['FIREBASE_API_KEY_WEB', 'FIREBASE_API_KEY']),
    appId: _require('FIREBASE APP ID (Web)', ['FIREBASE_APP_ID_WEB', 'FIREBASE_APP_ID']),
    projectId: _require('FIREBASE PROJECT ID', ['FIREBASE_PROJECT_ID']),
    messagingSenderId: _require('FIREBASE MESSAGING SENDER ID', ['FIREBASE_MESSAGING_SENDER_ID']),
    authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'],
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'],
  );
 */

  //
}
