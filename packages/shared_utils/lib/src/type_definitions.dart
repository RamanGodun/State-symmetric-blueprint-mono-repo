import 'package:shared_core_modules/public_api/base_modules/errors_management.dart'
    show Failure;

/// 📦 [DataMap] — For JSON-style dynamic map (used for DTO, serialization, Firestore docs...)
typedef DataMap = Map<String, dynamic>;

//------------- Errors management module ----------------

/// 📡 [ListenFailureCallback] — Optional handler when failure is caught
typedef ListenFailureCallback = void Function(Failure failure);

/// 🔧 [RefAction] — Executes an action without returning value, using Riverpod context
typedef RefAction = void Function();

/// Cancel function signature for overlay subscriptions.
typedef Cancel = void Function();

/// Syntactic sugar for a getter that returns a `bool`.
typedef BoolGetter = bool Function();
