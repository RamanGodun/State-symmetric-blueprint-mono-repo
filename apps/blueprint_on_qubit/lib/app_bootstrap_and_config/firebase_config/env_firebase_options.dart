import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 📦 [EnvFirebaseOptions] — Platform-aware Firebase config via .env variables
/// ✅ Uses `flutter_dotenv` to inject Firebase credentials at runtime
/// 🔐 Reads secrets securely from environment-specific .env files

final class EnvFirebaseOptions {
  ///-------------------------
  EnvFirebaseOptions._();
  //

  /// 🧠 Chooses correct [FirebaseOptions] based on platform
  static FirebaseOptions get currentPlatform {
    // if (kIsWeb) return _web;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _android;
      case TargetPlatform.iOS:
        return _ios;
      case TargetPlatform.macOS:
        throw UnsupportedError('macOS not supported via EnvFirebaseOptions');
      case TargetPlatform.windows:
        throw UnsupportedError('Windows not supported via EnvFirebaseOptions');
      case TargetPlatform.linux:
        throw UnsupportedError('Linux not supported via EnvFirebaseOptions');
      case TargetPlatform.fuchsia:
        throw UnimplementedError(
          'Fuchsia not supported via EnvFirebaseOptions',
        );
    }
  }

  // helpers: prefer platform-specific -> fallback to generic
  static String? _get(List<String> keys) {
    for (final k in keys) {
      final v = dotenv.env[k];
      if (v != null && v.isNotEmpty) return v;
    }
    return null;
  }

  /// 🤖 Android config from .env
  @pragma('vm:prefer-inline')
  static FirebaseOptions get _android => FirebaseOptions(
    apiKey: _get(['FIREBASE_API_KEY_ANDROID', 'FIREBASE_API_KEY'])!,
    appId: _get(['FIREBASE_APP_ID_ANDROID', 'FIREBASE_APP_ID'])!,
    projectId: _get(['FIREBASE_PROJECT_ID'])!,
    messagingSenderId: _get(['FIREBASE_MESSAGING_SENDER_ID'])!,
    storageBucket: _get(['FIREBASE_STORAGE_BUCKET']),
  );

  /// 🍏 iOS config from .env
  @pragma('vm:prefer-inline')
  static FirebaseOptions get _ios => FirebaseOptions(
    apiKey: _get(['FIREBASE_API_KEY_IOS', 'FIREBASE_API_KEY'])!,
    appId: _get(['FIREBASE_APP_ID_IOS', 'FIREBASE_APP_ID'])!,
    projectId: _get(['FIREBASE_PROJECT_ID'])!,
    messagingSenderId: _get(['FIREBASE_MESSAGING_SENDER_ID'])!,
    iosBundleId: _get(['FIREBASE_IOS_BUNDLE_ID']),
    storageBucket: _get(['FIREBASE_STORAGE_BUCKET']),
  );

  /*
 /// 🌐 Web config from .env
  @pragma('vm:prefer-inline')
  static FirebaseOptions get _web => FirebaseOptions(
        apiKey: _get(['FIREBASE_API_KEY_WEB', 'FIREBASE_API_KEY'])!,
        appId: _get(['FIREBASE_APP_ID_WEB', 'FIREBASE_APP_ID'])!,
        projectId: _get(['FIREBASE_PROJECT_ID'])!,
        messagingSenderId: _get(['FIREBASE_MESSAGING_SENDER_ID'])!,
        authDomain: _get(['FIREBASE_AUTH_DOMAIN']),
        storageBucket: _get(['FIREBASE_STORAGE_BUCKET']),
      );

 */

  //
}
