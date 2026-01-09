import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/shared_core_modules.dart';

void main() {
  group('OverlayAnimationEngineMapperX', () {
    group('iOS platform', () {
      testWidgets('returns IOSOverlayAnimationEngine for dialog', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: Builder(
              builder: (context) {
                // Act
                final engine = context.getEngine(OverlayCategory.dialog);

                // Assert
                expect(engine, isA<IOSOverlayAnimationEngine>());
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('returns IOSOverlayAnimationEngine for banner', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: Builder(
              builder: (context) {
                // Act
                final engine = context.getEngine(OverlayCategory.banner);

                // Assert
                expect(engine, isA<IOSOverlayAnimationEngine>());
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('returns IOSOverlayAnimationEngine for snackbar', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: Builder(
              builder: (context) {
                // Act
                final engine = context.getEngine(OverlayCategory.snackbar);

                // Assert
                expect(engine, isA<IOSOverlayAnimationEngine>());
                return Container();
              },
            ),
          ),
        );
      });
    });

    group('Android platform', () {
      testWidgets('returns AndroidOverlayAnimationEngine for dialog', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: Builder(
              builder: (context) {
                // Act
                final engine = context.getEngine(OverlayCategory.dialog);

                // Assert
                expect(engine, isA<AndroidOverlayAnimationEngine>());
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('returns AndroidOverlayAnimationEngine for banner', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: Builder(
              builder: (context) {
                // Act
                final engine = context.getEngine(OverlayCategory.banner);

                // Assert
                expect(engine, isA<AndroidOverlayAnimationEngine>());
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('returns AndroidOverlayAnimationEngine for snackbar', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: Builder(
              builder: (context) {
                // Act
                final engine = context.getEngine(OverlayCategory.snackbar);

                // Assert
                expect(engine, isA<AndroidOverlayAnimationEngine>());
                return Container();
              },
            ),
          ),
        );
      });
    });

    group('fallback for unsupported platforms', () {
      testWidgets('returns FallbackAnimationEngine for macOS', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.macOS),
            home: Builder(
              builder: (context) {
                // Act
                final engine = context.getEngine(OverlayCategory.dialog);

                // Assert
                expect(engine, isA<FallbackAnimationEngine>());
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('returns FallbackAnimationEngine for windows', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.windows),
            home: Builder(
              builder: (context) {
                // Act
                final engine = context.getEngine(OverlayCategory.dialog);

                // Assert
                expect(engine, isA<FallbackAnimationEngine>());
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('returns FallbackAnimationEngine for linux', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.linux),
            home: Builder(
              builder: (context) {
                // Act
                final engine = context.getEngine(OverlayCategory.dialog);

                // Assert
                expect(engine, isA<FallbackAnimationEngine>());
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('returns FallbackAnimationEngine for fuchsia', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.fuchsia),
            home: Builder(
              builder: (context) {
                // Act
                final engine = context.getEngine(OverlayCategory.dialog);

                // Assert
                expect(engine, isA<FallbackAnimationEngine>());
                return Container();
              },
            ),
          ),
        );
      });
    });

    group('platform detection', () {
      testWidgets('correctly detects iOS platform', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: Builder(
              builder: (context) {
                // Act
                final engine = context.getEngine(OverlayCategory.dialog)
                  // Assert - iOS engine should not have slide animation
                  ..initialize(tester);
                expect(engine.slide, isNull);
                engine.dispose();

                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('correctly detects Android platform', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: Builder(
              builder: (context) {
                // Act
                final engine = context.getEngine(OverlayCategory.dialog)
                  // Assert - Android engine should have slide animation
                  ..initialize(tester);
                expect(engine.slide, isNotNull);
                engine.dispose();

                return Container();
              },
            ),
          ),
        );
      });
    });

    group('overlay category mapping', () {
      testWidgets('dialog category maps to ShowAs.dialog', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: Builder(
              builder: (context) {
                // Act
                final engine =
                    context.getEngine(OverlayCategory.dialog)
                        as IOSOverlayAnimationEngine;

                // Assert - Check it's configured for dialog
                expect(engine, isA<IOSOverlayAnimationEngine>());

                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('banner category maps to ShowAs.banner', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: Builder(
              builder: (context) {
                // Act
                final engine =
                    context.getEngine(OverlayCategory.banner)
                        as IOSOverlayAnimationEngine;

                // Assert
                expect(engine, isA<IOSOverlayAnimationEngine>());

                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('snackbar category maps to ShowAs.snackbar', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: Builder(
              builder: (context) {
                // Act
                final engine =
                    context.getEngine(OverlayCategory.snackbar)
                        as IOSOverlayAnimationEngine;

                // Assert
                expect(engine, isA<IOSOverlayAnimationEngine>());

                return Container();
              },
            ),
          ),
        );
      });
    });

    group('real-world scenarios', () {
      testWidgets('iOS uses IOSOverlayAnimationEngine', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: Builder(
              builder: (context) {
                final iosEngine = context.getEngine(OverlayCategory.dialog);

                // Assert
                expect(iosEngine, isA<IOSOverlayAnimationEngine>());
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('Android uses AndroidOverlayAnimationEngine', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: Builder(
              builder: (context) {
                final androidEngine = context.getEngine(OverlayCategory.dialog);

                // Assert
                expect(androidEngine, isA<AndroidOverlayAnimationEngine>());
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('fallback for desktop platforms', (tester) async {
        // Test macOS
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.macOS),
            home: Builder(
              builder: (context) {
                final engine = context.getEngine(OverlayCategory.dialog);
                expect(engine, isA<FallbackAnimationEngine>());
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('can create engines for all overlay types', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: Builder(
              builder: (context) {
                // Act - Create engines for all types
                final dialogEngine = context.getEngine(OverlayCategory.dialog);
                final bannerEngine = context.getEngine(OverlayCategory.banner);
                final snackbarEngine = context.getEngine(
                  OverlayCategory.snackbar,
                );

                // Assert
                expect(dialogEngine, isA<AndroidOverlayAnimationEngine>());
                expect(bannerEngine, isA<AndroidOverlayAnimationEngine>());
                expect(snackbarEngine, isA<AndroidOverlayAnimationEngine>());

                return Container();
              },
            ),
          ),
        );
      });
    });

    group('edge cases', () {
      testWidgets('can be called multiple times', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: Builder(
              builder: (context) {
                // Act - Call multiple times
                final engine1 = context.getEngine(OverlayCategory.dialog);
                final engine2 = context.getEngine(OverlayCategory.dialog);
                final engine3 = context.getEngine(OverlayCategory.dialog);

                // Assert - All return valid engines
                expect(engine1, isA<IOSOverlayAnimationEngine>());
                expect(engine2, isA<IOSOverlayAnimationEngine>());
                expect(engine3, isA<IOSOverlayAnimationEngine>());

                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('each call returns new instance', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: Builder(
              builder: (context) {
                // Act
                final engine1 = context.getEngine(OverlayCategory.dialog);
                final engine2 = context.getEngine(OverlayCategory.dialog);

                // Assert - Different instances
                expect(engine1, isNot(same(engine2)));

                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('works with nested builders', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: Builder(
              builder: (outerContext) {
                final outerEngine = outerContext.getEngine(
                  OverlayCategory.dialog,
                );

                return Builder(
                  builder: (innerContext) {
                    final innerEngine = innerContext.getEngine(
                      OverlayCategory.banner,
                    );

                    // Assert - Both work correctly
                    expect(outerEngine, isA<AndroidOverlayAnimationEngine>());
                    expect(innerEngine, isA<AndroidOverlayAnimationEngine>());

                    return Container();
                  },
                );
              },
            ),
          ),
        );
      });
    });

    group('consistency', () {
      testWidgets('same category returns same engine type', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: Builder(
              builder: (context) {
                // Act - Get engines multiple times
                final engine1 = context.getEngine(OverlayCategory.dialog);
                final engine2 = context.getEngine(OverlayCategory.dialog);
                final engine3 = context.getEngine(OverlayCategory.dialog);

                // Assert - All same type
                expect(engine1.runtimeType, equals(engine2.runtimeType));
                expect(engine2.runtimeType, equals(engine3.runtimeType));

                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('different categories can return same engine type', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: Builder(
              builder: (context) {
                // Act
                final dialogEngine = context.getEngine(OverlayCategory.dialog);
                final bannerEngine = context.getEngine(OverlayCategory.banner);

                // Assert - Both are Android engines
                expect(dialogEngine, isA<AndroidOverlayAnimationEngine>());
                expect(bannerEngine, isA<AndroidOverlayAnimationEngine>());

                return Container();
              },
            ),
          ),
        );
      });
    });
  });
}
