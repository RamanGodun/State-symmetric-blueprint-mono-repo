part of '../../core_of_module/_errors_handling_entry_point.dart';

/// 📦 [ExceptionToFailureX] — Extension to map any [Object] (Exception/Error) to a domain-level [Failure]
/// ✅ Handles known exceptions and maps them declaratively via [mapToFailure]
/// ✅ Clean, centralized, consistent fallback logic
//
extension ExceptionToFailureX on Object {
  ///
  //
  Failure mapToFailure([StackTrace? stackTrace]) => switch (this) {
    //
    /// 🌐 No internet connection
    final SocketException error => Failure(
      type: const NetworkFailureType(),
      message: error.message,
    ),

    /// 🔢 JSON encoding/decoding error
    final JsonUnsupportedObjectError error => Failure(
      type: const JsonErrorFailureType(),
      message: error.toString(),
    ),

    /// 🔌 Dio error handler
    // final DioException error => _mapDioError(error),

    /// 🔥 Firebase error code handling
    final FBException error =>
      firebaseFailureMap[error.code]?.call(error.message) ??
          () {
            final failure =
                Failure(
                    type: const GenericFirebaseFailureType(),
                    message: error.message,
                  )
                  // Fallback's logging
                  ..log(stackTrace);
            return failure;
          }(),

    /// 📄 Firestore-specific malformed data
    final FormatException error when error.message.contains('document') =>
      Failure(
        type: const DocMissingFirebaseFailureType(),
        message: error.message,
      ),

    /// 🧩 Plugin missing
    final MissingPluginException error => Failure(
      type: const MissingPluginFailureType(),
      message: error.toString(),
    ),

    /// 🧾 Format parsing error
    final FormatException error => Failure(
      type: const FormatFailureType(),
      message: error.message,
    ),

    /// 💾  Cache-related error local storage failure
    final FileSystemException error => Failure(
      type: const CacheFailureType(),
      message: error.message,
    ),

    /// ⏳ Timeout reached
    final TimeoutException error => Failure(
      type: const NetworkTimeoutFailureType(),
      message: error.message,
    ),
    //

    /// ⚙️ Platform channel errors
    final PlatformException e =>
      platformFailureMap[e.code]?.call(e.message) ??
          // Fallback: treat as malformed/unsupported platform payload.
          Failure(type: const FormatFailureType(), message: e.message),

    /// ❓ Unknown fallback (use toString() if message absent)
    _ => () {
      final failure = Failure(
        type: const UnknownFailureType(),
        message: toString(),
      )..log(stackTrace);
      return failure;
    }(),

    //
  };
}
