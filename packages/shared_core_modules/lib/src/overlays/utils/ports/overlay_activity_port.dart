/// 🔌 [OverlayActivityPort] — абстракція каналу активності оверлеїв (state-agnostic)
abstract interface class OverlayActivityPort {
  /// 🔁 Pushes current overlay activity to UI layer
  void setActive({required bool isActive});
}
