import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🔄 [BlocWatchSelectX] — extension to mimic Riverpod’s `ref.watch(select(...))`.
/// ✅ Gives BLoC the same expressive, minimal API (perfect symmetry).
//
extension BlocWatchSelectX on BuildContext {
  ///------------------------------------
  //

  /// 🎯 Watch + select a slice of [B]’s state (clean & efficient rebuilds).
  R watchSelect<B extends StateStreamable<S>, S, R>(R Function(S) selector) {
    return select<B, R>((b) => selector((b as dynamic).state as S));
  }

  /// 📖 Read a BLoC instance without listening (parity to `ref.read`).
  B readBloc<B extends StateStreamable<Object?>>() => read<B>();

  //
}
