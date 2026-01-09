import 'package:adapters_for_bloc/adapters_for_bloc.dart'
    show AsyncValueForBLoC, CubitWithAsyncValue;
import 'package:features_dd_layers/public_api/auth/auth.dart'
    show SignOutUseCase;

/// 🚪 [SignOutCubit] — sign out through unified [AsyncValueForBLoC] and [CubitWithAsyncValue] as base Cubit
//
final class SignOutCubit extends CubitWithAsyncValue<void> {
  ///------------------------------------------------
  SignOutCubit(this._signOutUseCase) : super();
  //
  final SignOutUseCase _signOutUseCase;

  /// ▶️ Launch sign out with unified Loading/Data/Error.
  /// Keeps default UX (no UI preservation during sign-out).
  Future<void> signOut() {
    return emitGuarded(
      () async {
        final result = await _signOutUseCase();
        // Either<Failure, void> → value or throw Failure to be mapped by emitGuarded
        return result.fold((f) => throw f, (_) => null);
      },
      preserveUi: false,
    );
  }

  /// ♻️ Hard reset back to pure `loading` (for tests).
  void resetState() => resetToLoading();
  //
}
