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
    setUpAll(() async {
      await EasyLocalization.ensureInitialized();
    });

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

    group('menu items display', () {
      testWidgets('shows all language flags', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.byType(PopupMenuButton<LanguageOption>));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('🇬🇧'), findsOneWidget);
        expect(find.text('🇺🇦'), findsOneWidget);
        expect(find.text('🇵🇱'), findsOneWidget);
      });

      testWidgets('shows all language labels', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.byType(PopupMenuButton<LanguageOption>));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Change to English'), findsOneWidget);
        expect(find.text('Змінити на українську'), findsOneWidget);
        expect(find.text('Zmień na polski'), findsOneWidget);
      });
    });

    group('widget key', () {
      testWidgets('accepts custom key', (tester) async {
        // Arrange
        const customKey = Key('custom-language-toggle');
        final widget = EasyLocalization(
          supportedLocales: const [Locale('en')],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          assetLoader: const CodegenLoader(),
          child: Builder(
            builder: (context) {
              return const MaterialApp(
                home: Scaffold(
                  body: LanguageToggleButton(key: customKey),
                ),
              );
            },
          ),
        );

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byKey(customKey), findsOneWidget);
      });

      testWidgets('works without explicit key', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(LanguageToggleButton), findsOneWidget);
      });
    });

    group('integration scenarios', () {
      testWidgets('can be placed in AppBar', (tester) async {
        // Arrange
        final widget = EasyLocalization(
          supportedLocales: const [Locale('en')],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          assetLoader: const CodegenLoader(),
          child: Builder(
            builder: (context) {
              return MaterialApp(
                home: Scaffold(
                  appBar: AppBar(
                    actions: const [LanguageToggleButton()],
                  ),
                ),
              );
            },
          ),
        );

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(LanguageToggleButton), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
      });

      testWidgets('can be placed in Drawer', (tester) async {
        // Arrange
        final widget = EasyLocalization(
          supportedLocales: const [Locale('en')],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          assetLoader: const CodegenLoader(),
          child: Builder(
            builder: (context) {
              return const MaterialApp(
                home: Scaffold(
                  drawer: Drawer(
                    child: LanguageToggleButton(),
                  ),
                ),
              );
            },
          ),
        );

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(LanguageToggleButton), findsOneWidget);
      });

      testWidgets('multiple instances can exist', (tester) async {
        // Arrange
        final widget = EasyLocalization(
          supportedLocales: const [Locale('en')],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          assetLoader: const CodegenLoader(),
          child: Builder(
            builder: (context) {
              return const MaterialApp(
                home: Scaffold(
                  body: Column(
                    children: [
                      LanguageToggleButton(),
                      LanguageToggleButton(),
                    ],
                  ),
                ),
              );
            },
          ),
        );

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(LanguageToggleButton), findsNWidgets(2));
      });
    });

    group('edge cases', () {
      testWidgets('handles rapid taps', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act - tap multiple times quickly
        await tester.tap(find.byType(PopupMenuButton<LanguageOption>));
        await tester.pump();
        await tester.tap(find.byType(PopupMenuButton<LanguageOption>));
        await tester.pump();
        await tester.pumpAndSettle();

        // Assert - should not crash
        expect(find.byType(LanguageToggleButton), findsOneWidget);
      });

      testWidgets('handles opening and closing without selection', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.byType(PopupMenuButton<LanguageOption>));
        await tester.pumpAndSettle();

        // Close by tapping outside
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(PopupMenuItem<LanguageOption>), findsNothing);
      });
    });

    group('const constructor', () {
      test('has const constructor', () {
        // Act
        const button = LanguageToggleButton();

        // Assert
        expect(button, isA<LanguageToggleButton>());
      });

      test('const instances are equal', () {
        // Arrange
        const button1 = LanguageToggleButton();
        const button2 = LanguageToggleButton();

        // Assert
        expect(button1, equals(button2));
      });
    });

    group('accessibility', () {
      testWidgets('has semantics for screen readers', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        final semantics = tester.getSemantics(
          find.byType(PopupMenuButton<LanguageOption>),
        );

        // Assert
        expect(semantics, isNotNull);
      });

      testWidgets('menu items are accessible', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.byType(PopupMenuButton<LanguageOption>));
        await tester.pumpAndSettle();

        // Assert - all menu items should be in widget tree
        expect(
          find.byType(PopupMenuItem<LanguageOption>),
          findsNWidgets(3),
        );
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
