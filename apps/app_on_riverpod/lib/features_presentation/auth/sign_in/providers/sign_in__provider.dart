import 'package:core/core.dart';
import 'package:features/features.dart' show SignInUseCase;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart'
    show SafeAsyncState, signInUseCaseProvider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in__provider.g.dart';

/// 🧩 [signInProvider] — async notifier that handles user sign-in
/// 🧼 Uses [SafeAsyncState] to prevent post-dispose state updates
/// 🧼 Wraps logic in [AsyncValue.guard] for robust error handling
//
/// 🧩 [signInProvider] — Riverpod Notifier with shared ButtonSubmissionState
/// ✅ Mirrors BLoC Submit Cubit semantics (Initial → Loading → Success/Error)
//
@Riverpod(keepAlive: false)
final class SignIn extends _$SignIn {
  ///-------------------------------------------------------
  ///
  final _submitDebouncer = Debouncer(AppDurations.ms600);

  /// 🧱 Initial state (idle)
  @override
  ButtonSubmissionState build() => const ButtonSubmissionInitialState();

  /// 🔐 Signs in user with provided email and password
  /// - Delegates auth to [SignInUseCase]
  Future<void> signin({required String email, required String password}) async {
    if (state is ButtonSubmissionLoadingState) return;
    //
    _submitDebouncer.run(() async {
      state = const ButtonSubmissionLoadingState();
      //
      final useCase = ref.watch(signInUseCaseProvider);
      final result = await useCase(email: email, password: password);

      result.fold(
        // ❌ Failure branch → emit error with Consumable<Failure>
        (failure) {
          state = ButtonSubmissionErrorState(failure.asConsumable());
          failure.log();
        },
        // ✅ Success branch
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
bool signInSubmitIsLoading(Ref ref) =>
    ref.watch(signInProvider.select((a) => a.isLoading));
