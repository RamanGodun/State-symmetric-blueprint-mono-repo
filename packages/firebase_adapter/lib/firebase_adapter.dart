//
// ignore_for_file: directives_ordering, dangling_library_doc_comments

/// 📦 Firebase Adapter — Public API
/// ✅ Provides bootstrap, references, gateways, typedefs & utils
///

/// --- Bootstrap (init & env options)
export 'src/bootstrap/env_loader.dart';
export 'src/bootstrap/firebase_env_options.dart';
export 'src/bootstrap/firebase_init.dart';

/// --- Auth & Firestore
export 'src/auth_and_firestore/guarded_fb_user.dart';
export 'src/auth_and_firestore/firebase_auth_gateway.dart';
export 'src/auth_and_firestore/firebase_refs.dart';

/// --- Typedefs
export 'src/typedefs.dart'
    show
        CollectionReference,
        FBException,
        FirebaseAuth,
        FirebaseUser,
        UsersCollection;

/// --- Utilities
export 'src/utils/crash_analytics_logger.dart';
