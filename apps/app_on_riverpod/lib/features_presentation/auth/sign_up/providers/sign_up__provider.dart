import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart'
    show signUpUseCaseProvider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up__provider.g.dart';

/// 🧩 [signUpProvider] — Riverpod Notifier with shared ButtonSubmissionState
/// ✅ Mirrors BLoC submit Cubit semantics (Initial → Loading → Success/Error)
//
@Riverpod(keepAlive: false)
final class SignUp extends _$SignUp {
  ///-----------------------------
  //
  final _submitDebouncer = Debouncer(AppDurations.ms600);

  /// 🧱 Initial state (idle)
  @override
  ButtonSubmissionState build() => const ButtonSubmissionInitialState();

  /// 📝 Signs up user with name, email and password
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    if (state is ButtonSubmissionLoadingState) return;
    //
    _submitDebouncer.run(() async {
      state = const ButtonSubmissionLoadingState();

      final useCase = ref.read(signUpUseCaseProvider);
      final result = await useCase(
        name: name,
        email: email,
        password: password,
      );

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

  /// 🧼 Resets state after UI has handled error
  void reset() => state = const ButtonSubmissionInitialState();

  //
}

////
////

/// ⏳ Returns loading state for submission (primitive bool)
//
@riverpod
bool signUpSubmitIsLoading(Ref ref) =>
    ref.watch(signUpProvider.select((a) => a.isLoading));
