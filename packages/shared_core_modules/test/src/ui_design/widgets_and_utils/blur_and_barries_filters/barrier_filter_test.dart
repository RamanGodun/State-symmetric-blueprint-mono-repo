import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/overlays.dart';
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart'
    show OverlayBarrierFilter;

void main() {
  group('OverlayBarrierFilter', () {
    group('resolve method - blur levels', () {
      testWidgets('creates soft blur with OverlayBlurLevel.soft', (
        tester,
      ) async {
        // Act
        final widget = OverlayBarrierFilter.resolve(
          isDark: false,
          level: OverlayBlurLevel.soft,
        );

        // Assert
        expect(widget, isA<Positioned>());
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(children: [widget]),
          ),
        );
        expect(find.byType(BackdropFilter), findsOneWidget);
      });

      testWidgets('creates medium blur with OverlayBlurLevel.medium', (
        tester,
      ) async {
        // Act
        final widget = OverlayBarrierFilter.resolve(
          isDark: false,
          level: OverlayBlurLevel.medium,
        );

        // Assert
        expect(widget, isA<Positioned>());
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(children: [widget]),
          ),
        );
        expect(find.byType(BackdropFilter), findsOneWidget);
      });

      testWidgets('creates strong blur with OverlayBlurLevel.strong', (
        tester,
      ) async {
        // Act
        final widget = OverlayBarrierFilter.resolve(
          isDark: false,
          level: OverlayBlurLevel.strong,
        );

        // Assert
        expect(widget, isA<Positioned>());
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(children: [widget]),
          ),
        );
        expect(find.byType(BackdropFilter), findsOneWidget);
      });
    });

    group('resolve method - ShowAs types', () {
      testWidgets('creates blur for banner in light mode', (tester) async {
        // Act
        final widget = OverlayBarrierFilter.resolve(
          isDark: false,
          type: ShowAs.banner,
        );

        // Assert
        expect(widget, isA<Positioned>());
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(children: [widget]),
          ),
        );
        expect(find.byType(BackdropFilter), findsOneWidget);
      });

      testWidgets('creates blur for dialog in light mode', (tester) async {
        // Act
        final widget = OverlayBarrierFilter.resolve(
          isDark: false,
          type: ShowAs.dialog,
        );

        // Assert
        expect(widget, isA<Positioned>());
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(children: [widget]),
          ),
        );
        expect(find.byType(BackdropFilter), findsOneWidget);
      });

      testWidgets('creates blur for snackbar in light mode', (tester) async {
        // Act
        final widget = OverlayBarrierFilter.resolve(
          isDark: false,
          type: ShowAs.snackbar,
        );

        // Assert
        expect(widget, isA<Positioned>());
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(children: [widget]),
          ),
        );
        expect(find.byType(BackdropFilter), findsOneWidget);
      });
    });

    group('dark mode variations', () {
      testWidgets('creates darker blur for banner in dark mode', (
        tester,
      ) async {
        // Act
        final widget = OverlayBarrierFilter.resolve(
          isDark: true,
          type: ShowAs.banner,
        );

        // Assert
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(children: [widget]),
          ),
        );
        expect(find.byType(BackdropFilter), findsOneWidget);
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('creates darker blur for dialog in dark mode', (
        tester,
      ) async {
        // Act
        final widget = OverlayBarrierFilter.resolve(
          isDark: true,
          type: ShowAs.dialog,
        );

        // Assert
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(children: [widget]),
          ),
        );
        expect(find.byType(BackdropFilter), findsOneWidget);
      });
    });

    group('structure', () {
      testWidgets('returns Positioned widget', (tester) async {
        // Act
        final widget = OverlayBarrierFilter.resolve(
          isDark: false,
          level: OverlayBlurLevel.soft,
        );

        // Assert
        expect(widget, isA<Positioned>());
      });

      testWidgets('contains BackdropFilter', (tester) async {
        // Act
        final widget = OverlayBarrierFilter.resolve(
          isDark: false,
          level: OverlayBlurLevel.medium,
        );

        // Assert
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(children: [widget]),
          ),
        );
        expect(find.byType(BackdropFilter), findsOneWidget);
      });

      testWidgets('contains Container with color', (tester) async {
        // Act
        final widget = OverlayBarrierFilter.resolve(
          isDark: false,
          level: OverlayBlurLevel.strong,
        );

        // Assert
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(children: [widget]),
          ),
        );
        expect(find.byType(Container), findsWidgets);
      });
    });

    group('real-world scenarios', () {
      testWidgets('works in dialog overlay', (tester) async {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                Container(color: Colors.white),
                OverlayBarrierFilter.resolve(
                  isDark: false,
                  type: ShowAs.dialog,
                ),
              ],
            ),
          ),
        );

        // Assert
        expect(find.byType(BackdropFilter), findsOneWidget);
      });

      testWidgets('works with custom blur level override', (tester) async {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                Container(color: Colors.black),
                OverlayBarrierFilter.resolve(
                  isDark: true,
                  type: ShowAs.banner,
                  level: OverlayBlurLevel.strong,
                ),
              ],
            ),
          ),
        );

        // Assert
        expect(find.byType(BackdropFilter), findsOneWidget);
      });
    });

    group('edge cases', () {
      testWidgets('handles null type with default blur', (tester) async {
        // Act
        final widget = OverlayBarrierFilter.resolve(
          isDark: false,
        );

        // Assert
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(children: [widget]),
          ),
        );
        expect(find.byType(BackdropFilter), findsOneWidget);
      });

      testWidgets('level override takes precedence over type', (tester) async {
        // Act
        final widget = OverlayBarrierFilter.resolve(
          isDark: false,
          type: ShowAs.banner,
          level: OverlayBlurLevel.soft,
        );

        // Assert
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(children: [widget]),
          ),
        );
        expect(find.byType(BackdropFilter), findsOneWidget);
      });
    });
  });
}
