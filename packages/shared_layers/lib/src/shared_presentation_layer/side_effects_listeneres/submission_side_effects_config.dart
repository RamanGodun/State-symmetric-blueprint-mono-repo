import 'package:flutter/widgets.dart';
import 'package:shared_core_modules/shared_core_modules.dart'
    show
        AppLocalizer,
        CoreLocaleKeys,
        FailureRetryX,
        FailureToUIEntityX,
        FailureUIEntity,
        OverlayAfterFrameX,
        OverlayUtils,
        ShowAs;
import 'package:shared_layers/public_api/presentation_layer_shared.dart'
    show
        ButtonSubmissionErrorState,
        ButtonSubmissionRequiresReauthState,
        ButtonSubmissionSuccessState,
        SubmissionFlowStateModel;

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
  final void Function(BuildContext, ButtonSubmissionSuccessState)? onSuccess;

  /// ❌ Error branch (no retry)
  final void Function(
    BuildContext,
    FailureUIEntity,
    ButtonSubmissionErrorState,
  )?
  onError;

  /// 🔄 Requires re-auth branch (optional)
  final void Function(
    BuildContext,
    FailureUIEntity,
    ButtonSubmissionRequiresReauthState,
  )?
  onRequiresReauth;

  /// 🧼 Optional form reset hook
  final void Function(BuildContext)? onResetForm;

  /// ▶️ Retry action (wrap `(ref)` at adapter level if needed)
  final void Function(BuildContext)? onRetry;

  /// 🔁 Confirm label for retry dialog (fallback → localized)
  final String? retryLabel;

  /// 🎛️ Presentation for retry dialog
  final ShowAs retryShowAs;

  /// 📲 Custom renderer for “error with retry”
  final void Function(
    BuildContext,
    FailureUIEntity,
    ButtonSubmissionErrorState,
    VoidCallback retry,
  )?
  onErrorWithRetry;
}

/// 🔁 Single entry point to handle submit-flow transitions (BLoC & Riverpod)
/// ✅ Adapters enforce enter-only semantics by default (runtimeType change)
void handleSubmissionTransition({
  required BuildContext context,
  required SubmissionFlowStateModel curr,
  required SubmissionSideEffectsConfig cfg,
  SubmissionFlowStateModel? prev,
}) {
  // ⛔️ Guard: react only when runtimeType changes (mirrors adapters)
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
          // ✅ After-frame, global-overlay, queued, debounced, priority-aware
          context.showErrorAfterFrameCustom(
            ui: ui,
            showAs: cfg.retryShowAs,
            onConfirm: retry,
            confirmText:
                cfg.retryLabel ??
                AppLocalizer.translateSafely(CoreLocaleKeys.buttons_retry),
          );
        }
        cfg.onResetForm?.call(context);
        return;
      }

      // Passive error (no retry)
      if (cfg.onError != null) {
        cfg.onError!(context, ui, curr);
      } else {
        context.showErrorAfterFrame(ui); // ✅ after-frame safe
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
        context.showErrorAfterFrame(ui); // ✅ after-frame safe
      }
      return;

    /// ⏳ Initial/Loading/others → no side-effects
    default:
      return;
  }
  //
}
