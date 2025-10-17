import 'package:bloc_adapter/bloc_adapter.dart';
import 'package:features/features.dart' show SignOutUseCase;

/// 🚪 [SignOutCubit] — sign out through unified [AsyncValueForBLoC] and [CubitWithAsyncValue] as base Cubit
//
final class SignOutCubit extends CubitWithAsyncValue<void> {
  ///------------------------------------------------
  SignOutCubit(this._signOutUseCase) : super();
  //
  final SignOutUseCase _signOutUseCase;

  /// ▶️ Launch sign out with unified scheme Loading/Data/Error
  Future<void> signOut() async {
    await loadTask(() async {
      final result = await _signOutUseCase();
      return result.fold((f) => throw f, (_) => null); // Right<void> → null
    });
  }

  /// ♻️ Hard reset back to pure `loading` (for tests).
  void resetState() => resetToLoading();
  //
}
