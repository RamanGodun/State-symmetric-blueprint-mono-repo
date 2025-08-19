import 'dart:async';
import 'dart:developer';
import 'package:blueprint_on_riverpod/app_bootstrap_and_config/app_bootstrap.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// VGV-style bootstrap adapter that delegates to your AppBootstrap.
//
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  //
  /// Capture framework errors.
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  /// Capture uncaught async errors.
  PlatformDispatcher.instance.onError = (error, stack) {
    log('Uncaught (platform): $error', stackTrace: stack);
    return true;
  };

  ///
  await runZonedGuarded(
    () async {
      // Run initialization pipeline
      const appBootstrap = AppBootstrap(
        // ? Here can be plugged in custom dependencies (e.g.  "localStorage: IsarLocalStorage()," )
      );

      /// 🚀 Runs all startup logic (localization, Firebase, DI container, debug tools, local storage, etc).
      await appBootstrap.initAllServices();

      runApp(await builder());
    },

    (error, stack) {
      log('Uncaught (zoned): $error', stackTrace: stack);
    },
    //
  );

  //
}
