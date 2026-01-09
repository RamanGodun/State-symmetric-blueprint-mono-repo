import 'package:get_it/get_it.dart' show GetIt;

/// 💠 Global [GetIt] instance used as service locator across all apps
//
final GetIt di = GetIt.instance;

/// ♻️ Test/Hot-reload helper: clears the container (optional)
Future<void> resetDI() async => di.reset();
