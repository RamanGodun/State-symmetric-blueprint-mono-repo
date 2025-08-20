import 'package:blueprint_on_riverpod/features/change_or_reset_password/domain/password_actions_use_case.dart'
    show PasswordRelatedUseCases;
// import '../../../../../core/base_modules/errors_handling/extensible_part/failure_types/_failure_codes.dart';
import 'package:blueprint_on_riverpod/features/change_or_reset_password/domain/provider/use_cases_provider.dart';
import 'package:core/base_modules/errors_handling/core_of_module/failure_entity.dart'
    show Failure;
import 'package:core/base_modules/errors_handling/core_of_module/failure_type.dart'
    show RequiresRecentLoginFirebaseFailureType;
import 'package:core/base_modules/localization/generated/locale_keys.g.dart'
    show LocaleKeys;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'change_password__state.dart';

/// 🧩 [changePasswordProvider] — Manages the state and logic for password change flow.
/// Handles password update process, error mapping, and reauthentication scenarios.
//
final changePasswordProvider =
    StateNotifierProvider<ChangePasswordNotifier, ChangePasswordState>(
      ChangePasswordNotifier.new,
    );

/// 🛡️ [ChangePasswordNotifier] — StateNotifier handling password change process.
/// Updates state for loading, success, error, and reauth cases.
//
final class ChangePasswordNotifier extends StateNotifier<ChangePasswordState> {
  ///-------------------------------------------------------------------------
  /// 🧱 Initializes with [ChangePasswordInitial] state
  ChangePasswordNotifier(this.ref) : super(const ChangePasswordInitial());

  ///
  final Ref ref;
  String? _pendingPassword;

  /// 🔁 Attempts to update the user password via [PasswordRelatedUseCases].
  /// Emits [ChangePasswordLoading], then [ChangePasswordSuccess], [ChangePasswordError], or [ChangePasswordRequiresReauth].
  Future<void> changePassword(String newPassword) async {
    state = const ChangePasswordLoading();

    final useCase = ref.read(passwordUseCasesProvider);
    final result = await useCase.callChangePassword(newPassword);

    result.fold(
      (failure) {
        // if (failure.type.code == FailureCodes.requiresRecentLogin
        if (failure is RequiresRecentLoginFirebaseFailureType)
        // 'requires-recent-login')
        {
          state = const ChangePasswordRequiresReauth();
        } else {
          state = ChangePasswordError(failure);
        }
      },
      (_) => state = ChangePasswordSuccess(
        LocaleKeys.reauth_password_updated.tr(),
      ),
    );
  }

  /// ♻️ Retries password update after user reauthenticates.
  /// Uses stored [_pendingPassword] for retry logic.
  Future<void> retryAfterReauth() async {
    final pwd = _pendingPassword;
    if (pwd == null) return;
    state = const ChangePasswordLoading();

    final useCase = ref.read(passwordUseCasesProvider);
    final result = await useCase.callChangePassword(pwd);

    result.fold(
      (failure) {
        state = ChangePasswordError(failure);
      },
      (_) => state = ChangePasswordSuccess(
        LocaleKeys.reauth_password_updated.tr(),
      ),
    );
  }
}
