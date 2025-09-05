/// 📦💾 [IRemoteDataBase] — Abstraction to decouple startup logic and enable mocking in tests.
//
abstract interface class IRemoteDataBase {
  ///---------------------------------
  //
  /// Initializes all [IRemoteDataBase] services
  Future<void> init();
  //
}
