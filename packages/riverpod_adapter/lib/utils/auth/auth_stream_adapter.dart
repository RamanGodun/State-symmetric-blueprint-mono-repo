import 'package:core/utils_shared/auth/auth_gateway.dart';
import 'package:core/utils_shared/auth/auth_snapshot.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_stream_adapter.g.dart';

/// 🔌 [authGatewayProvider] — DI token for [AuthGateway] (overridden in app layer)
//
@riverpod
AuthGateway authGateway(Ref ref) => throw UnimplementedError();

////
////

/// 🌐 [authSnapshotsProvider] — reactive stream of [AuthSnapshot] from [AuthGateway]
//
@riverpod
Stream<AuthSnapshot> authSnapshots(Ref ref) =>
    ref.watch(authGatewayProvider).snapshots$;

////
////

/// 🧭 Tracks whether auth has resolved at least once (Ready/Failure)
//
final authResolvedOnceProvider = StateProvider<bool>((_) => false);
