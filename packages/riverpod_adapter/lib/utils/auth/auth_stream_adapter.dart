// packages/core/lib/utils_shared/riverpod_specific/auth_stream_adapter.dart
import 'package:core/utils_shared/auth/auth_gateway.dart';
import 'package:core/utils_shared/auth/auth_snapshot.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_stream_adapter.g.dart';

///
@riverpod
AuthGateway authGateway(Ref ref) => throw UnimplementedError(); // ! override in DI
///
@riverpod
Stream<AuthSnapshot> authSnapshots(Ref ref) =>
    ref.watch(authGatewayProvider).snapshots$;
