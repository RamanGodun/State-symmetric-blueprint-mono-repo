/// Tests for ThemeConfigNotifier and themeProvider
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - ThemeConfigNotifier initialization
/// - Theme loading from storage
/// - Font loading from storage
/// - Theme setting and persistence
/// - Font setting and persistence
/// - Theme toggling (light ↔ dark)
/// - Cycled theme toggling (light → dark → amoled)
/// - Combined theme and font updates
library;

import 'package:adapters_for_riverpod/src/base_modules/theme_module/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart';

class MockGetStorage extends Mock implements GetStorage {}

void main() {
  group('ThemeConfigNotifier', () {
    late MockGetStorage mockStorage;

    setUp(() {
      mockStorage = MockGetStorage();
    });

    group('initialization', () {
      test(
        'creates instance with default light theme when storage is empty',
        () {
          // Arrange
          when(() => mockStorage.read<String>(any())).thenReturn(null);

          // Act
          final notifier = ThemeConfigNotifier(mockStorage);

          // Assert
          expect(notifier.state.theme, equals(ThemeVariantsEnum.light));
          expect(notifier.state.font, equals(AppFontFamily.inter));
        },
      );

      test('loads saved theme from storage', () {
        // Arrange
        when(
          () => mockStorage.read<String>('selected_theme'),
        ).thenReturn('dark');
        when(() => mockStorage.read<String>('selected_font')).thenReturn(null);

        // Act
        final notifier = ThemeConfigNotifier(mockStorage);

        // Assert
        expect(notifier.state.theme, equals(ThemeVariantsEnum.dark));
      });

      test('loads saved font from storage', () {
        // Arrange
        when(() => mockStorage.read<String>('selected_theme')).thenReturn(null);
        when(
          () => mockStorage.read<String>('selected_font'),
        ).thenReturn('montserrat');

        // Act
        final notifier = ThemeConfigNotifier(mockStorage);

        // Assert
        expect(notifier.state.font, equals(AppFontFamily.montserrat));
      });

      test('loads both theme and font from storage', () {
        // Arrange
        when(
          () => mockStorage.read<String>('selected_theme'),
        ).thenReturn('amoled');
        when(
          () => mockStorage.read<String>('selected_font'),
        ).thenReturn('montserrat');

        // Act
        final notifier = ThemeConfigNotifier(mockStorage);

        // Assert
        expect(notifier.state.theme, equals(ThemeVariantsEnum.amoled));
        expect(notifier.state.font, equals(AppFontFamily.montserrat));
      });

      test('defaults to light theme when invalid theme stored', () {
        // Arrange
        when(
          () => mockStorage.read<String>('selected_theme'),
        ).thenReturn('invalid_theme');
        when(() => mockStorage.read<String>('selected_font')).thenReturn(null);

        // Act
        final notifier = ThemeConfigNotifier(mockStorage);

        // Assert
        expect(notifier.state.theme, equals(ThemeVariantsEnum.light));
      });
    });

    group('setTheme', () {
      test('updates theme state to dark', () {
        // Arrange
        when(() => mockStorage.read<String>(any())).thenReturn(null);
        when(
          () => mockStorage.write(any<String>(), any<String>()),
        ).thenAnswer((_) async => {});
        final notifier = ThemeConfigNotifier(mockStorage)
          // Act
          ..setTheme(ThemeVariantsEnum.dark);

        // Assert
        expect(notifier.state.theme, equals(ThemeVariantsEnum.dark));
      });

      test('updates theme state to amoled', () {
        // Arrange
        when(() => mockStorage.read<String>(any())).thenReturn(null);
        when(
          () => mockStorage.write(any<String>(), any<String>()),
        ).thenAnswer((_) async => {});
        final notifier = ThemeConfigNotifier(mockStorage)
          // Act
          ..setTheme(ThemeVariantsEnum.amoled);

        // Assert
        expect(notifier.state.theme, equals(ThemeVariantsEnum.amoled));
      });

      test('preserves font when changing theme', () {
        // Arrange
        when(() => mockStorage.read<String>('selected_theme')).thenReturn(null);
        when(
          () => mockStorage.read<String>('selected_font'),
        ).thenReturn('montserrat');
        when(
          () => mockStorage.write(any<String>(), any<String>()),
        ).thenAnswer((_) async => {});
        final notifier = ThemeConfigNotifier(mockStorage)
          // Act
          ..setTheme(ThemeVariantsEnum.dark);

        // Assert
        expect(notifier.state.theme, equals(ThemeVariantsEnum.dark));
        expect(notifier.state.font, equals(AppFontFamily.montserrat));
      });

      test('persists theme to storage', () {
        // Arrange
        when(() => mockStorage.read<String>(any())).thenReturn(null);
        when(
          () => mockStorage.write(any<String>(), any<String>()),
        ).thenAnswer((_) async => {});
        ThemeConfigNotifier(mockStorage)
        // Act
        .setTheme(ThemeVariantsEnum.dark);

        // Assert
        verify(() => mockStorage.write('selected_theme', 'dark')).called(1);
      });
    });

    group('toggleTheme', () {
      test('toggles from light to dark', () {
        // Arrange
        when(() => mockStorage.read<String>(any())).thenReturn(null);
        when(
          () => mockStorage.write(any<String>(), any<String>()),
        ).thenAnswer((_) async => {});
        final notifier = ThemeConfigNotifier(mockStorage)
          // Act
          ..toggleTheme();

        // Assert
        expect(notifier.state.theme, equals(ThemeVariantsEnum.dark));
      });

      test('toggles from dark to light', () {
        // Arrange
        when(
          () => mockStorage.read<String>('selected_theme'),
        ).thenReturn('dark');
        when(() => mockStorage.read<String>('selected_font')).thenReturn(null);
        when(
          () => mockStorage.write(any<String>(), any<String>()),
        ).thenAnswer((_) async => {});
        final notifier = ThemeConfigNotifier(mockStorage)
          // Act
          ..toggleTheme();

        // Assert
        expect(notifier.state.theme, equals(ThemeVariantsEnum.light));
      });

      test('toggles from amoled to light (amoled is dark variant)', () {
        // Arrange
        when(
          () => mockStorage.read<String>('selected_theme'),
        ).thenReturn('amoled');
        when(() => mockStorage.read<String>('selected_font')).thenReturn(null);
        when(
          () => mockStorage.write(any<String>(), any<String>()),
        ).thenAnswer((_) async => {});
        final notifier = ThemeConfigNotifier(mockStorage)
          // Act
          ..toggleTheme();

        // Assert
        expect(notifier.state.theme, equals(ThemeVariantsEnum.light));
      });

      test('multiple toggles alternate correctly', () {
        // Arrange
        when(() => mockStorage.read<String>(any())).thenReturn(null);
        when(
          () => mockStorage.write(any<String>(), any<String>()),
        ).thenAnswer((_) async => {});
        final notifier = ThemeConfigNotifier(mockStorage);

        // Act & Assert
        expect(notifier.state.theme, equals(ThemeVariantsEnum.light));

        notifier.toggleTheme();
        expect(notifier.state.theme, equals(ThemeVariantsEnum.dark));

        notifier.toggleTheme();
        expect(notifier.state.theme, equals(ThemeVariantsEnum.light));

        notifier.toggleTheme();
        expect(notifier.state.theme, equals(ThemeVariantsEnum.dark));
      });
    });

    group('toggleThemeCycled', () {
      test('cycles from light to dark', () {
        // Arrange
        when(() => mockStorage.read<String>(any())).thenReturn(null);
        when(
          () => mockStorage.write(any<String>(), any<String>()),
        ).thenAnswer((_) async => {});
        final notifier = ThemeConfigNotifier(mockStorage)
          // Act
          ..toggleThemeCycled();

        // Assert
        expect(notifier.state.theme, equals(ThemeVariantsEnum.dark));
      });

      test('cycles from dark to amoled', () {
        // Arrange
        when(
          () => mockStorage.read<String>('selected_theme'),
        ).thenReturn('dark');
        when(() => mockStorage.read<String>('selected_font')).thenReturn(null);
        when(
          () => mockStorage.write(any<String>(), any<String>()),
        ).thenAnswer((_) async => {});
        final notifier = ThemeConfigNotifier(mockStorage)
          // Act
          ..toggleThemeCycled();

        // Assert
        expect(notifier.state.theme, equals(ThemeVariantsEnum.amoled));
      });

      test('cycles from amoled to light', () {
        // Arrange
        when(
          () => mockStorage.read<String>('selected_theme'),
        ).thenReturn('amoled');
        when(() => mockStorage.read<String>('selected_font')).thenReturn(null);
        when(
          () => mockStorage.write(any<String>(), any<String>()),
        ).thenAnswer((_) async => {});
        final notifier = ThemeConfigNotifier(mockStorage)
          // Act
          ..toggleThemeCycled();

        // Assert
        expect(notifier.state.theme, equals(ThemeVariantsEnum.light));
      });

      test('full cycle: light → dark → amoled → light', () {
        // Arrange
        when(() => mockStorage.read<String>(any())).thenReturn(null);
        when(
          () => mockStorage.write(any<String>(), any<String>()),
        ).thenAnswer((_) async => {});
        final notifier = ThemeConfigNotifier(mockStorage);

        // Act & Assert
        expect(notifier.state.theme, equals(ThemeVariantsEnum.light));

        notifier.toggleThemeCycled();
        expect(notifier.state.theme, equals(ThemeVariantsEnum.dark));

        notifier.toggleThemeCycled();
        expect(notifier.state.theme, equals(ThemeVariantsEnum.amoled));

        notifier.toggleThemeCycled();
        expect(notifier.state.theme, equals(ThemeVariantsEnum.light));
      });
    });

    group('setFont', () {
      test('updates font state to montserrat', () {
        // Arrange
        when(() => mockStorage.read<String>(any())).thenReturn(null);
        when(
          () => mockStorage.write(any<String>(), any<String>()),
        ).thenAnswer((_) async => {});
        final notifier = ThemeConfigNotifier(mockStorage)
          // Act
          ..setFont(AppFontFamily.montserrat);

        // Assert
        expect(notifier.state.font, equals(AppFontFamily.montserrat));
      });

      test('updates font state back to inter', () {
        // Arrange
        when(() => mockStorage.read<String>(any())).thenReturn('montserrat');
        when(
          () => mockStorage.write(any<String>(), any<String>()),
        ).thenAnswer((_) async => {});
        final notifier = ThemeConfigNotifier(mockStorage)
          // Act
          ..setFont(AppFontFamily.inter);

        // Assert
        expect(notifier.state.font, equals(AppFontFamily.inter));
      });

      test('preserves theme when changing font', () {
        // Arrange
        when(
          () => mockStorage.read<String>('selected_theme'),
        ).thenReturn('dark');
        when(() => mockStorage.read<String>('selected_font')).thenReturn(null);
        when(
          () => mockStorage.write(any<String>(), any<String>()),
        ).thenAnswer((_) async => {});
        final notifier = ThemeConfigNotifier(mockStorage)
          // Act
          ..setFont(AppFontFamily.montserrat);

        // Assert
        expect(notifier.state.theme, equals(ThemeVariantsEnum.dark));
        expect(notifier.state.font, equals(AppFontFamily.montserrat));
      });

      test('persists font to storage', () {
        // Arrange
        when(() => mockStorage.read<String>(any())).thenReturn(null);
        when(
          () => mockStorage.write(any<String>(), any<String>()),
        ).thenAnswer((_) async => {});
        ThemeConfigNotifier(mockStorage)
        // Act
        .setFont(AppFontFamily.montserrat);

        // Assert
        verify(
          () => mockStorage.write('selected_font', 'montserrat'),
        ).called(1);
      });
    });

    group('setThemeAndFont', () {
      test('updates both theme and font', () {
        // Arrange
        when(() => mockStorage.read<String>(any())).thenReturn(null);
        when(
          () => mockStorage.write(any<String>(), any<String>()),
        ).thenAnswer((_) async => {});
        final notifier = ThemeConfigNotifier(mockStorage)
          // Act
          ..setThemeAndFont(ThemeVariantsEnum.dark, AppFontFamily.montserrat);

        // Assert
        expect(notifier.state.theme, equals(ThemeVariantsEnum.dark));
        expect(notifier.state.font, equals(AppFontFamily.montserrat));
      });

      test('persists both theme and font to storage', () {
        // Arrange
        when(() => mockStorage.read<String>(any())).thenReturn(null);
        when(
          () => mockStorage.write(any<String>(), any<String>()),
        ).thenAnswer((_) async => {});
        ThemeConfigNotifier(mockStorage)
        // Act
        .setThemeAndFont(ThemeVariantsEnum.amoled, AppFontFamily.montserrat);

        // Assert
        verify(() => mockStorage.write('selected_theme', 'amoled')).called(1);
        verify(
          () => mockStorage.write('selected_font', 'montserrat'),
        ).called(1);
      });

      test('updates from custom state to new custom state', () {
        // Arrange
        when(
          () => mockStorage.read<String>('selected_theme'),
        ).thenReturn('dark');
        when(
          () => mockStorage.read<String>('selected_font'),
        ).thenReturn('montserrat');
        when(
          () => mockStorage.write(any<String>(), any<String>()),
        ).thenAnswer((_) async => {});
        final notifier = ThemeConfigNotifier(mockStorage)
          // Act
          ..setThemeAndFont(ThemeVariantsEnum.light, AppFontFamily.inter);

        // Assert
        expect(notifier.state.theme, equals(ThemeVariantsEnum.light));
        expect(notifier.state.font, equals(AppFontFamily.inter));
      });
    });

    group('real-world scenarios', () {
      test('user changes theme preferences multiple times', () {
        // Arrange
        when(() => mockStorage.read<String>(any())).thenReturn(null);
        when(
          () => mockStorage.write(any<String>(), any<String>()),
        ).thenAnswer((_) async => {});
        final notifier = ThemeConfigNotifier(mockStorage)
          // Act - User tries different themes
          ..setTheme(ThemeVariantsEnum.dark);
        expect(notifier.state.theme, equals(ThemeVariantsEnum.dark));

        notifier.setTheme(ThemeVariantsEnum.amoled);
        expect(notifier.state.theme, equals(ThemeVariantsEnum.amoled));

        notifier.setTheme(ThemeVariantsEnum.light);
        expect(notifier.state.theme, equals(ThemeVariantsEnum.light));

        // Assert - Each change was persisted
        verify(() => mockStorage.write('selected_theme', 'dark')).called(1);
        verify(() => mockStorage.write('selected_theme', 'amoled')).called(1);
        verify(() => mockStorage.write('selected_theme', 'light')).called(1);
      });

      test('user customizes both theme and font', () {
        // Arrange
        when(() => mockStorage.read<String>(any())).thenReturn(null);
        when(
          () => mockStorage.write(any<String>(), any<String>()),
        ).thenAnswer((_) async => {});
        final notifier = ThemeConfigNotifier(mockStorage)
          // Act - User selects dark theme
          ..setTheme(ThemeVariantsEnum.dark)
          // Then changes font
          ..setFont(AppFontFamily.montserrat);

        // Assert
        expect(notifier.state.theme, equals(ThemeVariantsEnum.dark));
        expect(notifier.state.font, equals(AppFontFamily.montserrat));
      });

      test('app restart loads saved preferences', () {
        // Arrange - First session
        when(() => mockStorage.read<String>(any())).thenReturn(null);
        when(
          () => mockStorage.write(any<String>(), any<String>()),
        ).thenAnswer((_) async => {});
        ThemeConfigNotifier(
          mockStorage,
        ).setThemeAndFont(ThemeVariantsEnum.amoled, AppFontFamily.montserrat);

        // Act - App restart (second session)
        when(
          () => mockStorage.read<String>('selected_theme'),
        ).thenReturn('amoled');
        when(
          () => mockStorage.read<String>('selected_font'),
        ).thenReturn('montserrat');
        final notifier2 = ThemeConfigNotifier(mockStorage);

        // Assert - Preferences persisted
        expect(notifier2.state.theme, equals(ThemeVariantsEnum.amoled));
        expect(notifier2.state.font, equals(AppFontFamily.montserrat));
      });

      test('quick toggle for dark mode switch', () {
        // Arrange - User on light theme
        when(() => mockStorage.read<String>(any())).thenReturn(null);
        when(
          () => mockStorage.write(any<String>(), any<String>()),
        ).thenAnswer((_) async => {});
        final notifier = ThemeConfigNotifier(mockStorage)
          // Act - Quick toggle button
          ..toggleTheme(); // Light → Dark

        // Assert
        expect(notifier.state.theme, equals(ThemeVariantsEnum.dark));

        // Act - Toggle again
        notifier.toggleTheme(); // Dark → Light

        // Assert
        expect(notifier.state.theme, equals(ThemeVariantsEnum.light));
      });
    });

    group('themeProvider integration', () {
      test('creates provider with storage', () async {
        // Arrange
        final container = ProviderContainer(
          overrides: [
            themeStorageProvider.overrideWithValue(mockStorage),
          ],
        );
        addTearDown(container.dispose);

        when(() => mockStorage.read<String>(any())).thenReturn(null);

        // Act
        final notifier = container.read(themeProvider.notifier);
        final state = container.read(themeProvider);

        // Assert
        expect(notifier, isA<ThemeConfigNotifier>());
        expect(state, isA<ThemePreferences>());
        expect(state.theme, equals(ThemeVariantsEnum.light));
      });

      test('provider updates notify listeners', () async {
        // Arrange
        final container = ProviderContainer(
          overrides: [
            themeStorageProvider.overrideWithValue(mockStorage),
          ],
        );
        addTearDown(container.dispose);

        when(() => mockStorage.read<String>(any())).thenReturn(null);
        when(
          () => mockStorage.write(any<String>(), any<String>()),
        ).thenAnswer((_) async => {});

        var updateCount = 0;
        container.listen<ThemePreferences>(
          themeProvider,
          (previous, next) {
            updateCount++;
          },
        );

        // Act
        container.read(themeProvider.notifier).setTheme(ThemeVariantsEnum.dark);

        // Assert
        expect(updateCount, equals(1));
        expect(
          container.read(themeProvider).theme,
          equals(ThemeVariantsEnum.dark),
        );
      });
    });
  });
}
