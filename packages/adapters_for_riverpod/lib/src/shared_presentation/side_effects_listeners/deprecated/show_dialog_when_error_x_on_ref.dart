/*


import 'package:core/public_api/core.dart';
import 'package:flutter/material.dart' show BuildContext, VoidCallback;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/src/core/base_modules/errors_handling_module/async_value_failure_x.dart';

/// 🧩 [RefFailureDialogsX] — extension for showing [Failure]s from [AsyncValue]
/// 🧩 Helps to listen `AsyncValue<T>` and surface `Failure` as overlays.
//
extension RefFailureDialogsX on WidgetRef {
  ///--------------------------------------

  /// Show error dialog whenever provider emits `AsyncError(Failure)`.
  void listenFailure<T>(
    ProviderListenable<AsyncValue<T>> provider,
    BuildContext context, {
    ListenFailureCallback? onFailure,
  }) {
    listen<AsyncValue<T>>(provider, (prev, next) {
      final failure = next.asFailure;
      if (failure != null) {
        onFailure?.call(failure);
        context.showError(failure.toUIEntity());
      }
    });
  }

  ////

  /// 📦 Listen and shows errors dialog with custom onConfirm action
  void listenFailureWithAction<T>(
    ProviderListenable<AsyncValue<T>> provider,
    BuildContext context, {
    required VoidCallback onConfirmed,
    bool Function(Failure failure)? shouldHandle,
    VoidCallback? onCancelled,
    ShowAs showAs = ShowAs.infoDialog,
  }) {
    listen<AsyncValue<T>>(provider, (prev, next) {
      final failure = next.asFailure;
      if (failure != null && (shouldHandle?.call(failure) ?? true)) {
        context.showError(
          failure.toUIEntity(),
          onConfirm: onConfirmed,
          onCancel: onCancelled,
        );
      }
    });
  }

  ////

  /// 🧠 [listenRetryAwareFailure] — adaptive listener for retryable vs non-retryable [Failure]s
  /// ✅ Automatically chooses appropriate handling strategy
  ///
  void listenRetryAwareFailure<T>(
    ProviderListenable<AsyncValue<T>> provider,
    BuildContext context, {
    required WidgetRef ref,
    required VoidCallback onRetry,
    ShowAs showAs = ShowAs.infoDialog,
    ListenFailureCallback? onFailure,
  }) {
    ref.listen<AsyncValue<T>>(provider, (prev, next) {
      final failure = next.asFailure;
      if (failure == null) return;

      // Optional failure-specific hook
      onFailure?.call(failure);

      // 🔁 If retryable — show dialog with retry
      if (failure.isRetryable) {
        context.showError(
          showAs: ShowAs.dialog,
          failure.toUIEntity(),
          onConfirm: OverlayUtils.dismissAndRun(onRetry, context),
          confirmText: AppLocalizer.translateSafely(LocaleKeys.buttons_retry),
        );
      }
      // ❌ Otherwise — just show passive error info dialog
      else {
        context.showError(failure.toUIEntity());
      }
    });
  }

  //
}




 */
