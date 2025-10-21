import 'package:core/public_api/base_modules/localization.dart'
    show AppLocalizer, LocaleKeys;
import 'package:core/public_api/core.dart'
    show OverlayActivityWatcher, SubmitCompletionLockController;
import 'package:core/public_api/shared_layers/presentation.dart'
    show CustomFilledButton;
import 'package:core/public_api/utils.dart' show BoolGetter;
import 'package:flutter/widgets.dart';

/// 🧩 [SubmitButton] — Core submit button with anti-flicker logic.
/// Pure UI layer with injected state getters.
/// State-manager adapters (Riverpod/BLoC) supply the [overlayWatcher].
//
final class SubmitButton extends StatefulWidget {
  ///-----------------------------------------
  const SubmitButton({
    required this.label,
    required this.isValid,
    required this.isLoading,
    required this.isOverlayActive,
    required this.onPressed,
    required this.overlayWatcher,
    this.loadingLabel,
    super.key,
  });

  /// Default static label.
  final String label;
  //
  /// Optional label shown during loading (raw text or localization key).
  final String? loadingLabel;
  //
  /// Getter for form validity.
  final BoolGetter isValid;
  //
  /// Getter for loading state.
  final BoolGetter isLoading;
  //
  /// Getter for global overlay state.
  final BoolGetter isOverlayActive;
  //
  /// Callback on tap (enabled only when button is active).
  final VoidCallback onPressed;
  //
  /// Watcher for global overlay (injected via adapter).
  final OverlayActivityWatcher overlayWatcher;

  ///
  @override
  State<SubmitButton> createState() => _SubmitButtonState();
  //
}

////
////

/// 🛠️ Internal state for [SubmitButton].
/// Owns the lock controller and handles transition detection (loading true → false).
//
final class _SubmitButtonState extends State<SubmitButton> {
  ///-----------------------------------------------------
  //
  /// 🕓 Tracks previous loading state to detect transitions (true → false).
  bool _prevLoading = false;
  //
  /// 🔒 Lock controller that prevents flicker after submit completion.
  late final SubmitCompletionLockController _lock;

  /// ⚡ Initialize lock controller with the provided overlay watcher.
  @override
  void initState() {
    super.initState();
    _lock = SubmitCompletionLockController(
      overlayWatcher: widget.overlayWatcher,
    );
  }

  @override
  Widget build(BuildContext context) {
    //
    final isValid = widget.isValid();
    final isLoading = widget.isLoading();
    final isOverlayActive = widget.isOverlayActive();

    // 🚦 Arm lock immediately after submit completes (loading: true → false).
    if (_prevLoading && !isLoading && !_lock.isLocked) {
      _lock.arm();
    }
    _prevLoading = isLoading;

    final enabled =
        isValid && !isLoading && !isOverlayActive && !_lock.isLocked;

    // 🌐 Resolve loading label (uses localization if key-like).
    final loadingText = _resolveText(
      widget.loadingLabel ?? LocaleKeys.buttons_loading,
      'Loading...',
    );
    final displayLabel = isLoading ? loadingText : widget.label;

    return CustomFilledButton(
      label: displayLabel,
      isEnabled: enabled,
      isValidated: isValid,
      isLoading: isLoading,
      onPressed: enabled ? widget.onPressed : null,
    );
  }

  ////

  /// 🌐 Resolves [raw] as localization key if possible.
  /// Falls back to [fallback] or [raw] if translation unavailable.
  String _resolveText(String raw, String? fallback) {
    final looksLikeKey = raw.contains('.');
    if (looksLikeKey && AppLocalizer.isInitialized) {
      return AppLocalizer.translateSafely(raw, fallback: fallback ?? raw);
    }
    return raw;
  }

  /// 🧼 Cleanup: dispose lock controller and release resources.
  @override
  void dispose() {
    _lock.dispose();
    super.dispose();
  }

  //
}
