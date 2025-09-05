import 'package:core/utils_shared/auth/auth_gateway.dart';
import 'package:core/utils_shared/auth/auth_snapshot.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_stream_adapter.g.dart';

/// 🔌 [authGatewayProvider] — DI-токен для [AuthGateway] (override в app-шарі)
//
@Riverpod(keepAlive: true)
AuthGateway authGateway(Ref ref) => throw UnimplementedError();

/// 🌐 Стрім [AuthSnapshot] із gateway (може знадобитись у відж.)
@Riverpod(keepAlive: true)
Stream<AuthSnapshot> authSnapshots(Ref ref) =>
    ref.watch(authGatewayProvider).snapshots$;
