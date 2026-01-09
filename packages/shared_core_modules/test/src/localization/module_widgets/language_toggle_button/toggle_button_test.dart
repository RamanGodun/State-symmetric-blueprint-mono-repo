/// Tests for `LanguageToggleButton` widget
///
/// Coverage:
/// - Widget instantiation
/// - Const constructor behavior
/// - StatelessWidget properties
///
/// Note: Widget rendering tests with EasyLocalization require integration
/// test environment due to shared_preferences plugin dependency
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/localization.dart';

void main() {
  group('LanguageToggleButton', () {
    group('const constructor', () {
      test('has const constructor', () {
        // Act
        const button = LanguageToggleButton();

        // Assert
        expect(button, isA<LanguageToggleButton>());
      });

      test('const instances have same runtime type', () {
        // Arrange
        const button1 = LanguageToggleButton();
        const button2 = LanguageToggleButton();

        // Assert
        expect(button1.runtimeType, equals(button2.runtimeType));
        expect(button1, isA<LanguageToggleButton>());
        expect(button2, isA<LanguageToggleButton>());
      });
    });

    group('StatelessWidget properties', () {
      test('is a StatelessWidget', () {
        // Arrange
        const button = LanguageToggleButton();

        // Assert
        expect(button, isA<StatelessWidget>());
      });
    });
  });
}
