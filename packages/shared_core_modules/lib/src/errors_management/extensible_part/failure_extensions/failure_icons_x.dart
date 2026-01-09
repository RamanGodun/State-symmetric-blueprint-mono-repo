import 'package:flutter/material.dart' show IconData, Icons, debugPrint;
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart'
    show
        AccountExistsWithDifferentCredentialFirebaseFailureType,
        ApiFailureType,
        CacheFailureType,
        DocMissingFirebaseFailureType,
        EmailAlreadyInUseFirebaseFailureType,
        EmailVerificationTimeoutFailureType,
        FailureType,
        FormatFailureType,
        GenericFirebaseFailureType,
        InvalidCredentialFirebaseFailureType,
        JsonErrorFailureType,
        MissingPluginFailureType,
        NetworkFailureType,
        NetworkTimeoutFailureType,
        OperationNotAllowedFirebaseFailureType,
        RequiresRecentLoginFirebaseFailureType,
        TooManyRequestsFirebaseFailureType,
        UnauthorizedFailureType,
        UnknownFailureType,
        UserDisabledFirebaseFailureType,
        UserMissingFirebaseFailureType,
        UserNotFoundFirebaseFailureType;

/// 🎨 [FailureIconX] — Declaratively maps [FailureType] to an [IconData]
/// ✅ Keeps UI concerns out of domain-layer entities
/// ✅ Declares logic directly on instance
///
extension FailureIconX on FailureType {
  //
  /// 🎨 [icon] — Resolves icon based on concrete [FailureType]
  IconData get icon {
    if (this is NetworkFailureType)
      return Icons
          .signal_wifi_connected_no_internet_4; // No internet connection
    if (this is NetworkTimeoutFailureType)
      return Icons.schedule; // Request timed out
    if (this is GenericFirebaseFailureType)
      return Icons.local_fire_department; // Generic Firebase
    if (this is UserMissingFirebaseFailureType)
      return Icons.no_accounts; // No current user
    if (this is DocMissingFirebaseFailureType)
      return Icons.insert_drive_file; // Missing Firestore doc
    if (this is UnauthorizedFailureType) return Icons.lock; // Unauthorized
    if (this is CacheFailureType) return Icons.sd_storage; // Cache issues
    if (this is EmailVerificationTimeoutFailureType)
      return Icons.mark_email_unread; // Email verification
    if (this is FormatFailureType)
      return Icons.format_align_justify; // Format error
    if (this is JsonErrorFailureType) return Icons.code; // JSON error
    if (this is MissingPluginFailureType)
      return Icons.extension_off; // Plugin missing
    if (this is ApiFailureType) return Icons.cloud_off; // API error
    if (this is UnknownFailureType) return Icons.error_outline; // Unknown error
    if (this is EmailAlreadyInUseFirebaseFailureType)
      return Icons.mark_email_read; // Email already in use
    if (this is UserNotFoundFirebaseFailureType)
      return Icons.person_search; // User not found
    if (this is UserDisabledFirebaseFailureType)
      return Icons.block; // User disabled
    if (this is OperationNotAllowedFirebaseFailureType)
      return Icons.do_not_disturb_alt; // Operation not allowed
    if (this is AccountExistsWithDifferentCredentialFirebaseFailureType)
      return Icons.account_circle; // Account exists with other credential
    if (this is TooManyRequestsFirebaseFailureType)
      return Icons.timer; // Rate limit
    if (this is InvalidCredentialFirebaseFailureType)
      return Icons.vpn_key_off; // Invalid credential
    if (this is RequiresRecentLoginFirebaseFailureType)
      return Icons.login; // Requires recent login

    ///
    debugPrint(
      '❗️ [FailureIconX] No icon found for type: $runtimeType',
    );
    return Icons.error; // 🔒 Fallback UI icon
  }
}
