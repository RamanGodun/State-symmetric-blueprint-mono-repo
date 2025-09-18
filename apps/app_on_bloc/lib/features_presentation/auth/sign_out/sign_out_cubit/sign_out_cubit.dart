import 'package:bloc_adapter/bloc_adapter.dart';
import 'package:core/core.dart' show AsyncState;
import 'package:features/features.dart' show SignOutUseCase;

/// 🚪 [SignOutCubit] — sign out through unified [AsyncState]
///     ✅ success => AsyncState.data(null)
///     ✅ error   => AsyncState.error(Failure)
///     ✅ loading => AsyncState.loading()
//
final class SignOutCubit extends CubitWithAsyncState<void> {
  ///------------------------------------------------
  SignOutCubit(this._signOutUseCase) : super();
  //
  final SignOutUseCase _signOutUseCase;

  /// ▶️ Launch sign out with unified scheme Loading/Data/Error
  Future<void> signOut() async {
    await loadTask(() async {
      final result = await _signOutUseCase();
      // converts Either → throw/return for loadTask
      return result.fold((f) => throw f, (_) => null);
    });
  }

  //
}
