import 'package:core/public_api/core.dart';
import 'package:flutter/widgets.dart';

/// 🧩 [SubmissionSideEffectsConfig] — callbacks bundle for submit-flow side effects
/// ✅ Centralizes handlers for success / error / requires-reauth / retry
/// ✅ Reusable across BLoC & Riverpod adapters
//
class SubmissionSideEffectsConfig {
  ///----------------------------
  const SubmissionSideEffectsConfig({
    this.onSuccess,
    this.onError,
    this.onRequiresReauth,
    this.onResetForm,
    this.onRetry,
    this.retryLabel,
    this.retryShowAs = ShowAs.dialog,
    this.onErrorWithRetry,
  });

  /// ✅ Success branch
  final void Function(BuildContext context, ButtonSubmissionSuccessState state)?
  onSuccess;

  /// ❌ Error branch (non-retry)
  final void Function(
    BuildContext context,
    FailureUIEntity ui,
    ButtonSubmissionErrorState state,
  )?
  onError;

  /// 🔄 Requires re-auth branch (optional)
  final void Function(
    BuildContext context,
    FailureUIEntity ui,
    ButtonSubmissionRequiresReauthState state,
  )?
  onRequiresReauth;

  /// 🧼 Optional form reset hook (e.g., after error)
  final void Function(BuildContext context)? onResetForm;

  /// ▶️ Retry action.
  /// For Riverpod it’s convenient to have `(WidgetRef)`, but core is UI-agnostic.
  /// Wrap it in the adapter: `(ctx) => onRetry(ref)`.
  final void Function(BuildContext context)? onRetry;

  /// 🔁 Confirm button text for retry dialog (fallback → localized default)
  final String? retryLabel;

  /// 🎛️ Dialog presentation for retry (default: material dialog)
  final ShowAs retryShowAs;

  /// 📲 Custom renderer for “error with retry”
  final void Function(
    BuildContext context,
    FailureUIEntity ui,
    ButtonSubmissionErrorState state,
    VoidCallback retry,
  )?
  onErrorWithRetry;
}

/// 🔁 Single entry point to handle submit-flow transitions (BLoC & Riverpod)
/// ✅ Enter-only semantics are enforced at adapter level (runtimeType change)
//
void handleSubmissionTransition({
  required BuildContext context,
  required SubmissionFlowState curr,
  required SubmissionSideEffectsConfig cfg,
  SubmissionFlowState? prev,
}) {
  // ⛔️ Guard: react only when runtimeType changes (mirrors existing listeners)
  if (prev != null && prev.runtimeType == curr.runtimeType) return;

  switch (curr) {
    /// ✅ Success
    case ButtonSubmissionSuccessState():
      cfg.onSuccess?.call(context, curr);
      return;

    /// ❌ Error (with optional retry)
    case ButtonSubmissionErrorState(:final failure):
      final consumed = failure?.consume();
      if (consumed == null) return; // already handled elsewhere

      final ui = consumed.toUIEntity();
      final retryable = consumed.isRetryable;

      if (retryable && cfg.onRetry != null) {
        void retry() => OverlayUtils.dismissAndRun(
          () => cfg.onRetry!.call(context),
          context,
        )();

        if (cfg.onErrorWithRetry != null) {
          cfg.onErrorWithRetry!(context, ui, curr, retry);
        } else {
          context.showError(
            ui,
            showAs: cfg.retryShowAs,
            onConfirm: retry,
            confirmText:
                cfg.retryLabel ??
                AppLocalizer.translateSafely(LocaleKeys.buttons_retry),
          );
        }

        cfg.onResetForm?.call(context);
        return;
      }

      // Passive error (no retry)
      if (cfg.onError != null) {
        cfg.onError!(context, ui, curr);
      } else {
        context.showError(ui);
      }
      cfg.onResetForm?.call(context);
      return;

    /// 🔄 Requires re-auth
    case ButtonSubmissionRequiresReauthState(:final failure):
      final consumed = failure?.consume();
      if (consumed == null) return;

      final ui = consumed.toUIEntity();
      if (cfg.onRequiresReauth != null) {
        cfg.onRequiresReauth!(context, ui, curr);
      } else {
        context.showError(ui);
      }
      return;

    /// ⏳ Initial/Loading/others → no side-effects
    default:
      return;
  }
}
