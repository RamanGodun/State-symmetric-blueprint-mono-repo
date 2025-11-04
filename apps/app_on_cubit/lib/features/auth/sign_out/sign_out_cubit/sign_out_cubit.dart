import 'package:bloc_adapter/bloc_adapter.dart';
import 'package:features/features.dart' show SignOutUseCase;

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
