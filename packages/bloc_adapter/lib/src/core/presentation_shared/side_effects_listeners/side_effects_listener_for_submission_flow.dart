import 'package:core/public_api/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🧯 [SubmissionStateSideEffects] — BLoC-адаптер поверх ядра сайд-ефектів
/// ✅ Симетрія з Riverpod: реагує на зміни runtimeType (за замовчуванням)
/// ✅ Делегує всю гілкову логіку в `handleSubmissionTransition(...)`
//
final class SubmissionStateSideEffects<
  C extends StateStreamable<SubmissionFlowState>
>
    extends StatelessWidget {
  ///------------------------------------------------------------
  const SubmissionStateSideEffects({
    required this.child,
    this.listenWhen, // опційний фільтр переходів
    this.config =
        const SubmissionSideEffectsConfig(), // єдине місце конфігурації
    super.key,
  });

  /// 🖼️ Піддерево
  final Widget child;

  /// 🧪 Кастомний предикат (дефолт: реагуємо при зміні runtimeType)
  final bool Function(SubmissionFlowState prev, SubmissionFlowState curr)?
  listenWhen;

  /// ⚙️ Налаштування гілок (success / error / reauth / retry / reset)
  final SubmissionSideEffectsConfig config;

  @override
  Widget build(BuildContext context) {
    return BlocListener<C, SubmissionFlowState>(
      // 🔎 За замовчуванням: enter-only по типу стану (як у Riverpod-адаптері)
      listenWhen: listenWhen ?? (p, c) => p.runtimeType != c.runtimeType,
      listener: (ctx, state) => handleSubmissionTransition(
        context: ctx,
        curr: state,
        cfg: config,
      ),
      child: child,
    );
  }
}
