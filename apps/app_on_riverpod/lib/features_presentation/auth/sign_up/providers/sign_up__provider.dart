import 'package:app_on_riverpod/features_presentation/auth/sign_up/providers/sign_up_form_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart'
    show SafeAsyncState, signUpUseCaseProvider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up__provider.g.dart';

/// 🧩 [signUpProvider] — async notifier for user registration
/// 🧼 Uses [SafeAsyncState] to prevent post-dispose state updates
/// 🧼 Wraps logic in [AsyncValue.guard] for robust error handling
//
@Riverpod(keepAlive: false)
final class SignUp extends _$SignUp with SafeAsyncState<void> {
  ///------------------------------------------------------

  /// 🧱 Initializes safe lifecycle mechanism
  @override
  FutureOr<void> build() {
    initSafe();
  }

  /// 📝 Signs up user with name, email and password
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final useCase = ref.read(signUpUseCaseProvider);

    await updateSafely(() async {
      final result = await useCase(
        name: name,
        email: email,
        password: password,
      );
      return result.fold((f) => throw f, (_) => null);
    });
  }

  /// 🧼 Resets state after UI has handled error
  void reset() => state = const AsyncData(null);

  //
}

////
////

/// ✅ Returns form validity as primitive bool (minimal rebuilds)
//
@riverpod
bool signUpFormIsValid(Ref ref) =>
    ref.watch(signUpFormProvider.select((f) => f.isValid));

////
////

/// ⏳ Returns loading state for submission (primitive bool)
//
@riverpod
bool signUpSubmitIsLoading(Ref ref) =>
    ref.watch(signUpProvider.select((a) => a.isLoading));
