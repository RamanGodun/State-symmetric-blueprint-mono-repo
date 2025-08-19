/// 💾 [ILocalStorage] — Abstraction to decouple startup logic and enable mocking in tests.
//
abstract interface class ILocalStorage {
  ///--------------------------------
  //
  /// Initializes all local storage services
  Future<void> init();
  //
}
