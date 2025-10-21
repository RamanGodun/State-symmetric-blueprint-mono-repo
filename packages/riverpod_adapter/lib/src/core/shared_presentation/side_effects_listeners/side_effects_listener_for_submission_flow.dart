import 'package:core/public_api/core.dart';
import 'package:flutter/material.dart' show BuildContext, VoidCallback;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 🧯 [SubmissionEffectsRefX] — Riverpod analogue of BLoC `SubmissionSideEffects`
/// ✅ Listens to `ButtonSubmissionState` provider and handles:
///    - Success → `onSuccess`
///    - Error → `onError` / `onErrorWithRetry` (if failure.isRetryable)
///    - RequiresReauth → `onRequiresReauth`
//
extension SubmissionEffectsRefX on WidgetRef {
  /// 🎧 Universal side-effects listener for submit flows with optional retry
  void listenSubmissionSideEffects(
    ProviderListenable<SubmissionFlowState> provider,
    BuildContext context, {

    /// Custom predicate (default: fires on runtimeType changes)
    bool Function(SubmissionFlowState prev, SubmissionFlowState next)?
    listenWhen,

    /// ✅ Success handler
    void Function(BuildContext context, ButtonSubmissionSuccessState state)?
    onSuccess,

    /// ❌ Error handler (no retry)
    void Function(
      BuildContext context,
      FailureUIEntity ui,
      ButtonSubmissionErrorState state,
    )?
    onError,

    /// 🔄 Requires-reauth handler (optional)
    void Function(
      BuildContext context,
      FailureUIEntity ui,
      ButtonSubmissionRequiresReauthState state,
    )?
    onRequiresReauth,

    /// 🧹 Optional hook to reset form state after error
    void Function(BuildContext context)? onResetForm,

    /// ▶️ Retry action (submit again, resend, etc.)
    void Function(WidgetRef ref)? onRetry,

    /// 🔁 Custom confirm text for Retry dialog (fallback → localized)
    String? retryLabel,

    /// 🎛️ Dialog type for Retry (default: material dialog)
    ShowAs retryShowAs = ShowAs.dialog,

    /// 📲 Custom renderer for Error-with-Retry
    void Function(
      BuildContext context,
      FailureUIEntity ui,
      ButtonSubmissionErrorState state,
      VoidCallback retry,
    )?
    onErrorWithRetry,
  }) {
    listen<SubmissionFlowState>(
      provider,
      (prev, curr) {
        // Default behavior: react when runtimeType changes (like BLoC listener)
        if (listenWhen != null && prev != null) {
          final should = listenWhen(prev, curr);
          if (!should) return;
        } else if (prev != null && prev.runtimeType == curr.runtimeType) {
          return;
        }

        switch (curr) {
          /// ✅ Success
          case ButtonSubmissionSuccessState():
            onSuccess?.call(context, curr);

          /// ❌ Error
          case ButtonSubmissionErrorState(:final failure):
            final consumed = failure?.consume();
            if (consumed == null) return; // already handled elsewhere

            final ui = consumed.toUIEntity();
            final retryable = consumed.isRetryable;

            if (retryable && onRetry != null) {
              void retry() => OverlayUtils.dismissAndRun(
                () => onRetry(this),
                context,
              )();
              if (onErrorWithRetry != null) {
                onErrorWithRetry(context, ui, curr, retry);
              } else {
                // Default retry-aware dialog (symmetry with BLoC)
                context.showError(
                  ui,
                  showAs: retryShowAs,
                  onConfirm: retry,
                  confirmText:
                      retryLabel ??
                      AppLocalizer.translateSafely(LocaleKeys.buttons_retry),
                );
              }
              onResetForm?.call(context);
              return;
            }

            // Passive error (no retry)
            if (onError != null) {
              onError(context, ui, curr);
            } else {
              context.showError(ui);
            }
            onResetForm?.call(context);

          /// 🔄 Requires reauth (optional flow)
          case ButtonSubmissionRequiresReauthState(:final failure):
            final consumed = failure?.consume();
            if (consumed == null) return;
            final ui = consumed.toUIEntity();
            if (onRequiresReauth != null) {
              onRequiresReauth(context, ui, curr);
            } else {
              context.showError(ui);
            }

          /// ⏳ Initial/Loading → no side-effects here
          default:
            break;
        }
      },
      onError: (_, _) {},
    );
  }
}
