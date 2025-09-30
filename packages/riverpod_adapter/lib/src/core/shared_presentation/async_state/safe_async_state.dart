import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 🧩 [SafeAsyncState] — lifecycle-safe helper for `AsyncNotifier`
/// ✅ Prevents calling `state =` after the notifier is disposed
/// ✅ Must be mixed into `AutoDisposeAsyncNotifier<T>`
//
mixin SafeAsyncState<T> on AutoDisposeAsyncNotifier<T> {
  /// ─────--------------------------------------------
  //
  /// 🧬 Lifecycle token to track whether notifier is still active
  Object? _key;

  /// 🏁 Initializes the lifecycle token
  /// Should be called inside the `build()` method
  void initSafe() {
    _key = Object();
    ref.onDispose(() => _key = null);
  }

  /// 🔄 Returns true if notifier is still alive
  bool get isAlive => _key != null;

  /// 🔐 Validates the operation against the active token
  bool _matches(Object? key) => _key == key;

  /// 🔁 Executes guarded update and applies result only if still active
  /// ✅ Prevents "setState after dispose" errors
  Future<void> updateSafely(Future<T> Function() body) async {
    final currentKey = _key;
    final result = await AsyncValue.guard(body);

    if (_matches(currentKey)) {
      state = result;
    }
  }

  /// ⏳ Sets loading state safely
  void setLoadingSafe() {
    if (isAlive) state = const AsyncLoading();
  }

  /// ✅ Sets success state safely
  void setDataSafe(T value) {
    if (isAlive) state = AsyncData(value);
  }

  /// ❌ Sets error state safely
  void setErrorSafe(Object error, [StackTrace? stackTrace]) {
    if (isAlive) state = AsyncError(error, stackTrace ?? StackTrace.current);
  }

  //
}
