import 'package:core/public_api/core.dart';
import 'package:flutter/material.dart' show BuildContext;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 🧯 [SubmissionEffectsRefX] — Riverpod-адаптер поверх ядра сайд-ефектів
/// ✅ Симетрія з BLoC: дефолтно реагує на зміну runtimeType
/// ✅ Вся гілкова логіка в `handleSubmissionTransition(...)`
//
extension SubmissionEffectsRefX on WidgetRef {
  /// 🎧 Підписка на submit-флоу з єдиним конфігом
  void listenSubmissionSideEffects(
    ProviderListenable<SubmissionFlowState> provider,
    BuildContext context, {
    bool Function(SubmissionFlowState prev, SubmissionFlowState next)?
    listenWhen,
    SubmissionSideEffectsConfig config = const SubmissionSideEffectsConfig(),
  }) {
    // SubmissionFlowState? prev;
    listen<SubmissionFlowState>(
      provider,
      (prev, curr) {
        // 🔎 Дефолт: реагуємо тільки коли змінюється runtimeType
        if (listenWhen != null && prev != null && !listenWhen(prev, curr)) {
          prev = curr;
          return;
        }
        if (listenWhen == null &&
            prev != null &&
            prev.runtimeType == curr.runtimeType) {
          prev = curr;
          return;
        }

        // 🧩 Якщо onRetry заданий у вигляді (BuildContext) — просто прокидаємо як є
        final adapted = (config.onRetry == null)
            ? config
            : SubmissionSideEffectsConfig(
                onSuccess: config.onSuccess,
                onError: config.onError,
                onRequiresReauth: config.onRequiresReauth,
                onResetForm: config.onResetForm,
                onRetry: (ctx) => config.onRetry!.call(ctx),
                retryLabel: config.retryLabel,
                retryShowAs: config.retryShowAs,
                onErrorWithRetry: config.onErrorWithRetry,
              );

        handleSubmissionTransition(
          context: context,
          curr: curr,
          prev: prev,
          cfg: adapted,
        );

        prev = curr;
      },
      onError: (_, _) {}, // уникнути шуму в логах
    );
  }
}
