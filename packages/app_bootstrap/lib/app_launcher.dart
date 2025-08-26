import 'dart:async';
import 'dart:developer';
import 'package:app_bootstrap/bootstrap_contracts/_bootstrap.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// 🏗️ [AppBuilder] — Factory typedef for building the root [Widget]
//
typedef AppBuilder = FutureOr<Widget> Function();

////
////

/// 🚀 [AppLauncher] — Orchestrates bootstrap, error handling, and final runApp
//
///   Responsibilities:
///     - Setup framework / async / platform error handlers
///     - Run app inside [runZonedGuarded] to catch uncaught errors
///     - Call [IAppBootstrap] to initialize all core services
///     - Launch the root [AppBuilder]
//
final class AppLauncher {
  ///-----------------
  const AppLauncher._();
  //

  /// Main entrypoint: runs initialization and launches the app
  static Future<void> run({
    ///
    required IAppBootstrap bootstrap,
    required AppBuilder builder,
    void Function(Object error, StackTrace stack)? onZoneError,
    void Function(FlutterErrorDetails details)? onFlutterError,
    bool Function(Object error, StackTrace stack)? onPlatformError,
    //
  }) async {
    /// 🛑 Capture framework-level errors (FlutterError)
    FlutterError.onError =
        onFlutterError ??
        (details) {
          /// Keep Flutter’s default error presentation (stacktrace, hints)
          FlutterError.presentError(details);
          //
          /// Additional logging (console, Crashlytics, etc.)
          log(details.exceptionAsString(), stackTrace: details.stack);
        };

    /// 🛑 Capture uncaught platform/async errors
    PlatformDispatcher.instance.onError =
        onPlatformError ??
        (error, stack) {
          /// In debug: print stacktrace and crash loudly
          assert(() {
            FlutterError.dumpErrorToConsole(
              FlutterErrorDetails(exception: error, stack: stack),
            );
            return false; // assert false → stops in debug mode
          }(), 'Uncaught platform error (see console for details)');
          //
          /// In release: log instead of crashing
          log('Uncaught (platform): $error', stackTrace: stack);
          return true; // prevents crash in production
        };
    //

    /// 🛡️ Guarded zone for full bootstrap + app launch
    await runZonedGuarded(
      () async {
        /// 🚀 Initialize all core services (localization, Firebase, DI, storage, etc.)
        await bootstrap.initAllServices();

        /// 🏁 Finally, launch the application
        runApp(await builder());
      },
      //

      /// 🛑
      onZoneError ??
          (error, stack) {
            /// Show in Flutter’s default error format
            FlutterError.dumpErrorToConsole(
              FlutterErrorDetails(exception: error, stack: stack),
            );
            //
            /// Additional logging
            log('Uncaught (zoned): $error', stackTrace: stack);
          },

      //
    );
  }
}
