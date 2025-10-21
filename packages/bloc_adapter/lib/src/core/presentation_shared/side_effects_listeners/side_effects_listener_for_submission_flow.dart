import 'package:core/public_api/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🧯 [SubmissionStateSideEffects] — BLoC adapter over the core
/// ✅ Default: reacts on `runtimeType` change (symmetry with Riverpod)
/// ✅ No local postFrame/mounted guards — dispatcher owns lifecycle
//
final class SubmissionStateSideEffects<
  C extends StateStreamable<SubmissionFlowState>
>
    extends StatelessWidget {
  ///--------------------------------------------------------------------------------------------------------
  const SubmissionStateSideEffects({
    required this.child,
    this.listenWhen, // optional filter
    this.config = const SubmissionSideEffectsConfig(),
    super.key,
  });

  /// 🖼️ Child subtree to wrap
  final Widget child;

  /// 🧪 Custom predicate (default: react on runtimeType change)
  final bool Function(SubmissionFlowState prev, SubmissionFlowState curr)?
  listenWhen;

  /// ⚙️ Branch config (success / error / reauth / retry / reset)
  final SubmissionSideEffectsConfig config;

  @override
  Widget build(BuildContext context) {
    return BlocListener<C, SubmissionFlowState>(
      // 🔎 Default enter-only by runtimeType (keeps parity with Riverpod)
      listenWhen: listenWhen ?? (p, c) => p.runtimeType != c.runtimeType,
      listener: (ctx, state) => handleSubmissionTransition(
        context: ctx,
        curr: state,
        cfg: config,
      ),
      child: child,
    );
  }

  //
}
