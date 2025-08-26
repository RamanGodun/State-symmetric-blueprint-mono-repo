//
// ignore_for_file: directives_ordering
//
// ---- bootstrap
export 'bootstrap/dotenv_options.dart';
export 'bootstrap/firebase_initializer.dart';

// ---- constants
export 'constants/firebase_constants.dart';

// ---- gateways
export 'gateways/firebase_auth_gateway.dart';

// ---- typedefs (див. пункт 2 нижче)
export 'firebase_typedefs.dart'
    show
        CollectionReference,
        FBException,
        FirebaseAuth,
        FirebaseUser,
        UsersCollection;

// ---- utils
export 'utils/auth_user_utils.dart';
export 'utils/crash_analytics_logger.dart';
