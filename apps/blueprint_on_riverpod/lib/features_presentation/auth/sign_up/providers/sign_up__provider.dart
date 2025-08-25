import 'package:features/auth/domain/use_cases/use_cases_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:specific_for_riverpod/safe_async_state.dart';

part 'sign_up__provider.g.dart';

/// 🧩 [signupProvider] — async notifier for user registration
/// 🧼 Uses [SafeAsyncState] for lifecycle safety
/// 🧼 Compatible with new declarative error handling (listenFailure)
//
@Riverpod(keepAlive: false)
final class Signup extends _$Signup with SafeAsyncState<void> {
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
