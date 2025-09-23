import 'package:core/core.dart';
import 'package:features/features.dart' show PasswordRelatedUseCases;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart'
    show passwordUseCasesProvider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reset_password__provider.g.dart';

/// 🧩 [resetPasswordProvider] — Riverpod Notifier with shared ButtonSubmissionState
/// ✅ Mirrors BLoC submit Cubit semantics (Initial → Loading → Success/Error)
//
@Riverpod(keepAlive: false)
final class ResetPassword extends _$ResetPassword {
  ///----------------------------------------------------
  //
  final _submitDebouncer = Debouncer(AppDurations.ms600);

  /// 🧱 Initial state (idle)
  @override
  ButtonSubmissionState build() => const ButtonSubmissionInitialState();

  /// 📩 Sends reset link to provided email via [PasswordRelatedUseCases]
  /// ✅ Maps result into shared [ButtonSubmissionState]
  Future<void> resetPassword({required String email}) async {
    if (state is ButtonSubmissionLoadingState) return;

    _submitDebouncer.run(() async {
      state = const ButtonSubmissionLoadingState();

      final useCase = ref.read(passwordUseCasesProvider);
      final result = await useCase.callResetPassword(email);

      result.fold(
        // ❌ Failure → error with Consumable<Failure>
        (failure) {
          state = ButtonSubmissionErrorState(failure.asConsumable());
          failure.log();
        },
        // ✅ Success
        (_) => state = const ButtonSubmissionSuccessState(),
      );
    });
  }

  /// ♻️ Reset to initial (e.g., after dialogs/navigation)
  void reset() => state = const ButtonSubmissionInitialState();

  //
}

////
////

/// ⏳ Returns loading state for submission (primitive bool)
//
@riverpod
bool resetPasswordIsLoading(Ref ref) =>
    ref.watch(resetPasswordProvider.select((a) => a.isLoading));
