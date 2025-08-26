part of '../../core_of_module/_errors_handling_entry_point.dart';

/*

/// 🧩 [_mapDioError] — maps [DioException] to specific [Failure]s
/// ✅ Handles timeouts, HTTP errors, and default cases
//
Failure _mapDioError(DioException error) => switch (error.type) {
  // ⏱️ Timeout-related Dio errors
  DioExceptionType.connectionTimeout ||
  DioExceptionType.receiveTimeout ||
  DioExceptionType.sendTimeout => Failure(
    type: const NetworkTimeoutFailureType(),
    message: error.message,
  ),

  // 📡 HTTP response errors
  DioExceptionType.badResponse => switch (error.response?.statusCode) {
    // 🛡️ Unauthorized (401)
    final code? when code == 401 => Failure(
      type: const UnauthorizedFailureType(),
      statusCode: 401,
      message: error.message,
    ),

    // 🔢 Інші HTTP помилки
    final code? when code >= 400 && code < 600 => Failure(
      type: const ApiFailureType(),
      statusCode: code,
      message: error.message,
    ),

    // ❓ Unknown HTTP status
    _ => Failure(
      type: const ApiFailureType(),
      statusCode: error.response?.statusCode ?? 0,
      message: error.message,
    ),
  },

  // 🌐 Others Dio cases
  _ => Failure(type: const NetworkFailureType(), message: error.message),
};

 */
