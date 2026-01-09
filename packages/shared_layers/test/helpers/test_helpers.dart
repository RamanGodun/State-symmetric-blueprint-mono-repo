/// Test helpers and utilities for shared_layers_and_utils package tests
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Extensions for WidgetTester to simplify common test operations
extension WidgetTesterX on WidgetTester {
  /// Pump widget wrapped in MaterialApp
  Future<void> pumpApp(
    Widget widget, {
    ThemeData? theme,
    Locale? locale,
  }) {
    return pumpWidget(
      MaterialApp(
        theme: theme,
        locale: locale,
        home: Scaffold(body: widget),
      ),
    );
  }

  /// Pump widget and settle all animations
  Future<void> pumpAppAndSettle(Widget widget) async {
    await pumpApp(widget);
    await pumpAndSettle();
  }

  /// Find widget by key string
  Finder findByKey(String key) => find.byKey(Key(key));

  /// Enter text in field by key
  Future<void> enterTextByKey(String key, String text) async {
    await enterText(findByKey(key), text);
    await pump();
  }

  /// Tap widget by key
  Future<void> tapByKey(String key) async {
    await tap(findByKey(key));
    await pumpAndSettle();
  }
}

/// Wait for async operations in tests
Future<void> wait([int milliseconds = 100]) =>
    Future<void>.delayed(Duration(milliseconds: milliseconds));

/// Extension to await multiple futures in parallel
extension FutureListX<T> on List<Future<T>> {
  Future<List<T>> awaitAll() => Future.wait(this);
}
