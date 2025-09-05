import 'package:core/utils.dart' show AuthGateway, AuthSnapshot;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_stream_adapter.g.dart';

/// 🔌 [authGatewayProvider] — DI token for [AuthGateway]
/// ✅ Overridden in the application layer with a concrete implementation (e.g. FirebaseAuthGateway)
//
@Riverpod(keepAlive: true)
AuthGateway authGateway(Ref ref) => throw UnimplementedError();

////
////

/// 🌐 [authSnapshotsProvider] — stream of [AuthSnapshot] from the gateway
/// ✅ Can be consumed directly in widgets to react to authentication changes
//
@Riverpod(keepAlive: true)
Stream<AuthSnapshot> authSnapshots(Ref ref) =>
    ref.watch(authGatewayProvider).snapshots$;
