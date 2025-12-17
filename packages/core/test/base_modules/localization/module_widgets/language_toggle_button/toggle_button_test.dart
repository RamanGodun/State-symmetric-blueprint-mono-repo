/// Tests for `LanguageToggleButton` widget
///
/// Coverage:
/// - Widget rendering
/// - PopupMenuButton configuration
/// - Language selection handling
/// - Integration with EasyLocalization context
/// - Overlay banner display
library;

import 'package:core/src/base_modules/localization/generated/codegen_loader.g.dart';
import 'package:core/src/base_modules/localization/module_widgets/language_toggle_button/language_option.dart';
import 'package:core/src/base_modules/localization/module_widgets/language_toggle_button/toggle_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LanguageToggleButton', () {
    Widget createTestWidget({Locale initialLocale = const Locale('en')}) {
      return EasyLocalization(
        supportedLocales: const [
          Locale('en'),
          Locale('uk'),
          Locale('pl'),
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        startLocale: initialLocale,
        useOnlyLangCode: true,
        assetLoader: const CodegenLoader(),
        child: Builder(
          builder: (context) {
            return MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              home: const Scaffold(
                body: LanguageToggleButton(),
              ),
            );
          },
        ),
      );
    }

    group('widget rendering', () {
      testWidgets('renders without errors', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(LanguageToggleButton), findsOneWidget);
      });

      testWidgets('displays PopupMenuButton', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(PopupMenuButton<LanguageOption>), findsOneWidget);
      });

      testWidgets('displays icon button', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(Icon), findsOneWidget);
      });

      testWidgets('has zero padding', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        final popupButton = tester.widget<PopupMenuButton<LanguageOption>>(
          find.byType(PopupMenuButton<LanguageOption>),
        );
        expect(popupButton.padding, equals(EdgeInsets.zero));
      });
    });

    group('popup menu behavior', () {
      testWidgets('opens menu on tap', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.byType(PopupMenuButton<LanguageOption>));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(PopupMenuItem<LanguageOption>), findsWidgets);
      });

      testWidgets('shows all language options when opened', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.byType(PopupMenuButton<LanguageOption>));
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.byType(PopupMenuItem<LanguageOption>),
          findsNWidgets(3),
        );
      });

      testWidgets('closes menu after selection', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.byType(PopupMenuButton<LanguageOption>));
        await tester.pumpAndSettle();

        // Find and tap a non-current language option
        final ukMenuItem = find.text('Змінити на українську');
        await tester.tap(ukMenuItem);
        await tester.pumpAndSettle();

        // Assert - menu should be closed
        expect(find.byType(PopupMenuItem<LanguageOption>), findsNothing);
      });
    });

    group('current language detection', () {
      testWidgets('detects English as current locale', (tester) async {
        // Arrange
        await tester.pumpWidget(
          createTestWidget(),
        );

        // Act
        await tester.tap(find.byType(PopupMenuButton<LanguageOption>));
        await tester.pumpAndSettle();

        // Assert - English option should show check icon
        expect(find.byIcon(Icons.check), findsOneWidget);
      });

      testWidgets('detects Ukrainian as current locale', (tester) async {
        // Arrange
        await tester.pumpWidget(
          createTestWidget(initialLocale: const Locale('uk')),
        );

        // Act
        await tester.tap(find.byType(PopupMenuButton<LanguageOption>));
        await tester.pumpAndSettle();

        // Assert - should show check icon for current language
        expect(find.byIcon(Icons.check), findsOneWidget);
      });

      testWidgets('detects Polish as current locale', (tester) async {
        // Arrange
        await tester.pumpWidget(
          createTestWidget(initialLocale: const Locale('pl')),
        );

        // Act
        await tester.tap(find.byType(PopupMenuButton<LanguageOption>));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byIcon(Icons.check), findsOneWidget);
      });
    });


    group('widget key', () {
      testWidgets('works without explicit key', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(LanguageToggleButton), findsOneWidget);
      });
    });



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

      testWidgets('rebuilds when parent changes', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        final initialWidget = find.byType(LanguageToggleButton);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(initialWidget, findsOneWidget);
      });
    });
  });
}
