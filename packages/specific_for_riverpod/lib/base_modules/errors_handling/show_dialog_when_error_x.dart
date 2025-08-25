import 'package:core/base_modules/errors_handling/core_of_module/failure_entity.dart';
import 'package:core/base_modules/errors_handling/core_of_module/failure_ui_mapper.dart';
import 'package:core/base_modules/errors_handling/extensible_part/failure_extensions/failure_led_retry_x.dart';
import 'package:core/base_modules/localization/core_of_module/init_localization.dart'
    show AppLocalizer;
import 'package:core/base_modules/localization/generated/locale_keys.g.dart'
    show LocaleKeys;
import 'package:core/base_modules/overlays/core/_context_x_for_overlays.dart';
import 'package:core/base_modules/overlays/core/enums_for_overlay_module.dart'
    show ShowAs;
import 'package:core/base_modules/overlays/utils/overlay_utils.dart'
    show OverlayUtils;
import 'package:core/utils_shared/type_definitions.dart';
import 'package:flutter/material.dart' show BuildContext, VoidCallback;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 🧩 [FailureListenerRefX] — extension for showing [Failure]s from [AsyncValue]
//
extension FailureListenerRefX on WidgetRef {
  ///--------------------------------------

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

  ///

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

////

////

/// 🧩 [AsyncValueX] — extension for extracting [Failure] from [AsyncError]
/// ✅ Enables typed access to domain failures in async state
//
extension AsyncValueX<T> on AsyncValue<T> {
  /// ─────-------------------------------

  /// ❌ Returns [Failure] if this is an [AsyncError] containing a domain failure
  Failure? get asFailure {
    final error = this;
    if (error is AsyncError && error.error is Failure) {
      return error.error! as Failure;
    }
    return null;
  }

  // /
}
