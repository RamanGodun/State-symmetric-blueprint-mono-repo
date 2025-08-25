import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// 🧩 [SafeRegistration] — Extension on [GetIt] for safe DI registration
/// ✅ Prevents double registration crashes in shared or reloaded environments (like tests, hot reload)
//
extension SafeRegistration on GetIt {
  ///-------------------------------

  /// 💤 Registers a lazy singleton if not already registered
  /// - `T`: the type to register
  void registerLazySingletonIfAbsent<T extends Object>(
    T Function() factory, {
    String? instanceName,
  }) {
    if (!isRegistered<T>(instanceName: instanceName)) {
      registerLazySingleton<T>(factory, instanceName: instanceName);
    }
  }

  /// 🏭 Registers a factory if not already registered
  /// - Use when a new instance is needed on each `get<T>()` call
  void registerFactoryIfAbsent<T extends Object>(
    T Function() factory, {
    String? instanceName,
  }) {
    if (!isRegistered<T>(instanceName: instanceName)) {
      registerFactory<T>(factory, instanceName: instanceName);
    }
  }

  /// 📦 Registers a singleton instance if not already registered
  /// - Use for immutable/global services
  void registerSingletonIfAbsent<T extends Object>(
    T instance, {
    String? instanceName,
  }) {
    if (!isRegistered<T>(instanceName: instanceName)) {
      registerSingleton<T>(instance, instanceName: instanceName);
    }
  }

  //
}

////
////

/// 🧩 [SafeDispose] — Extension on [GetIt] for safe disposal/unregistration
/// Disposes and unregisters any registered singleton that implements 'Closeable'
///   - T: Type of singleton (cubit, Bloc, StreamController, etc.)
///   - If instance has .close(), calls it and unregisters
///   - Safe to call even there was no registration
//
extension SafeDispose on GetIt {
  ///
  Future<void> safeDispose<T extends Object>({String? instanceName}) async {
    if (isRegistered<T>(instanceName: instanceName)) {
      final instance = get<T>(instanceName: instanceName);

      if (instance is Cubit) {
        await instance.close();
      } else if (instance is BlocBase) {
        await instance.close();
      }
      unregister<T>(instanceName: instanceName);
    }
  }
}

/*
	•	Коментар про “implements Closeable” не відповідає реалізації: закривається лише cubit/BlocBase. Інші типи (наприклад, StreamController, ChangeNotifier, власні dispose()) не покриті.
	•	Зафіксувати: або розширити на загальний інтерфейс (наприклад, власний Disposable { FutureOr<void> dispose(); }) і перевіряти через is Disposable, або явно документувати, що це тільки для Bloc/cubit.
 */
