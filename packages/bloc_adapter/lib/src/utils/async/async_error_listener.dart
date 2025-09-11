import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ⛑️ [AsyncErrorListener] — reusable listener for any [AsyncState<T>]
/// ✅ Triggers overlay on entering [AsyncStateError]
/// 💡 Accepts optional [onError] hook for custom handling
//
final class AsyncErrorListener<T> extends StatelessWidget {
  ///---------------------------------------------
  const AsyncErrorListener({
    required this.bloc,
    required this.child,
    super.key,
    this.onError,
  });

  /// 🔌 Cubit/Bloc emitting [AsyncState<T>]
  final BlocBase<AsyncState<T>> bloc;

  /// 🖼️ Child widget
  final Widget child;

  /// 🎯 Optional hook for custom error handling
  final void Function(BuildContext context, Failure failure)? onError;

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlocBase<AsyncState<T>>, AsyncState<T>>(
      bloc: bloc,

      /// 🚨 Enter-only: fire only when entering error state
      listenWhen: (prev, curr) =>
          prev is! AsyncStateError<T> && curr is AsyncStateError<T>,

      listener: (context, state) {
        final failure = (state as AsyncStateError<T>).failure;
        if (onError != null) {
          onError!(context, failure);
        } else {
          context.showError(failure.toUIEntity());
        }
      },
      child: child,
    );
  }
}
