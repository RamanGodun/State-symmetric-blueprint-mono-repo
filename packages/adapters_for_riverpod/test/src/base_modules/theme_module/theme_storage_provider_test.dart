/// Tests for themeStorageProvider
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Provider creation and initialization
/// - GetStorage instance provision
/// - Provider scope and lifecycle
/// - Provider overrides for testing
library;

import 'package:adapters_for_riverpod/src/base_modules/theme_module/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart';

class MockGetStorage extends Mock implements GetStorage {}

void main() {
  group('themeStorageProvider', () {
    group('provider creation', () {
      test('provides GetStorage instance when overridden', () {
        // Arrange
        final mockStorage = MockGetStorage();
        final container = ProviderContainer(
          overrides: [
            themeStorageProvider.overrideWithValue(mockStorage),
          ],
        );
        addTearDown(container.dispose);

        // Act
        final storage = container.read(themeStorageProvider);

        // Assert
        expect(storage, isA<GetStorage>());
        expect(storage, isNotNull);
        expect(storage, equals(mockStorage));
      });

      test('returns same instance on multiple reads', () {
        // Arrange
        final mockStorage = MockGetStorage();
        final container = ProviderContainer(
          overrides: [
            themeStorageProvider.overrideWithValue(mockStorage),
          ],
        );
        addTearDown(container.dispose);

        // Act
        final storage1 = container.read(themeStorageProvider);
        final storage2 = container.read(themeStorageProvider);

        // Assert
        expect(identical(storage1, storage2), isTrue);
      });

      test('can be overridden with different instances', () {
        // Arrange
        final mockStorage1 = MockGetStorage();
        final mockStorage2 = MockGetStorage();
        final container1 = ProviderContainer(
          overrides: [themeStorageProvider.overrideWithValue(mockStorage1)],
        );
        final container2 = ProviderContainer(
          overrides: [themeStorageProvider.overrideWithValue(mockStorage2)],
        );
        addTearDown(container1.dispose);
        addTearDown(container2.dispose);

        // Act
        final storage1 = container1.read(themeStorageProvider);
        final storage2 = container2.read(themeStorageProvider);

        // Assert - Different containers can have different storage instances
        expect(storage1, equals(mockStorage1));
        expect(storage2, equals(mockStorage2));
        expect(identical(storage1, storage2), isFalse);
      });
    });

    group('storage operations with mocks', () {
      test('can write and read values', () async {
        // Arrange
        final mockStorage = MockGetStorage();
        when(
          () => mockStorage.write(any<String>(), any<dynamic>()),
        ).thenAnswer((_) async => {});
        when(() => mockStorage.read<String>(any())).thenReturn('test_value');

        final container = ProviderContainer(
          overrides: [themeStorageProvider.overrideWithValue(mockStorage)],
        );
        addTearDown(container.dispose);
        final storage = container.read(themeStorageProvider);

        // Act
        await storage.write('test_key', 'test_value');
        final value = storage.read<String>('test_key');

        // Assert
        expect(value, equals('test_value'));
        verify(() => mockStorage.write('test_key', 'test_value')).called(1);
        verify(() => mockStorage.read<String>('test_key')).called(1);
      });

      test('can write multiple values', () async {
        // Arrange
        final mockStorage = MockGetStorage();
        when(
          () => mockStorage.write(any<String>(), any<dynamic>()),
        ).thenAnswer((_) async => {});

        final container = ProviderContainer(
          overrides: [themeStorageProvider.overrideWithValue(mockStorage)],
        );
        addTearDown(container.dispose);
        final storage = container.read(themeStorageProvider);

        // Act
        await storage.write('key1', 'value1');
        await storage.write('key2', 'value2');
        await storage.write('key3', 'value3');

        // Assert
        verify(() => mockStorage.write('key1', 'value1')).called(1);
        verify(() => mockStorage.write('key2', 'value2')).called(1);
        verify(() => mockStorage.write('key3', 'value3')).called(1);
      });

      test('can read values with different types', () {
        // Arrange
        final mockStorage = MockGetStorage();
        when(() => mockStorage.read<String>(any())).thenReturn('string_value');
        when(() => mockStorage.read<int>(any())).thenReturn(42);
        when(() => mockStorage.read<bool>(any())).thenReturn(true);

        final container = ProviderContainer(
          overrides: [themeStorageProvider.overrideWithValue(mockStorage)],
        );
        addTearDown(container.dispose);
        final storage = container.read(themeStorageProvider);

        // Act
        final stringValue = storage.read<String>('string_key');
        final intValue = storage.read<int>('int_key');
        final boolValue = storage.read<bool>('bool_key');

        // Assert
        expect(stringValue, equals('string_value'));
        expect(intValue, equals(42));
        expect(boolValue, isTrue);
      });

      test('returns null for non-existent keys', () {
        // Arrange
        final mockStorage = MockGetStorage();
        when(() => mockStorage.read<String>(any())).thenReturn(null);

        final container = ProviderContainer(
          overrides: [themeStorageProvider.overrideWithValue(mockStorage)],
        );
        addTearDown(container.dispose);
        final storage = container.read(themeStorageProvider);

        // Act
        final value = storage.read<String>('non_existent');

        // Assert
        expect(value, isNull);
      });

      test('can remove values', () async {
        // Arrange
        final mockStorage = MockGetStorage();
        when(() => mockStorage.remove(any())).thenAnswer((_) async => {});

        final container = ProviderContainer(
          overrides: [themeStorageProvider.overrideWithValue(mockStorage)],
        );
        addTearDown(container.dispose);
        final storage = container.read(themeStorageProvider);

        // Act
        await storage.remove('to_remove');

        // Assert
        verify(() => mockStorage.remove('to_remove')).called(1);
      });

      test('can erase all data', () async {
        // Arrange
        final mockStorage = MockGetStorage();
        when(mockStorage.erase).thenAnswer((_) async => {});

        final container = ProviderContainer(
          overrides: [themeStorageProvider.overrideWithValue(mockStorage)],
        );
        addTearDown(container.dispose);
        final storage = container.read(themeStorageProvider);

        // Act
        await storage.erase();

        // Assert
        verify(mockStorage.erase).called(1);
      });
    });

    group('integration with themeProvider', () {
      test('themeProvider uses storage from themeStorageProvider', () {
        // Arrange
        final mockStorage = MockGetStorage();
        when(
          () => mockStorage.read<String>('selected_theme'),
        ).thenReturn('dark');
        when(() => mockStorage.read<String>('selected_font')).thenReturn(null);

        final container = ProviderContainer(
          overrides: [themeStorageProvider.overrideWithValue(mockStorage)],
        );
        addTearDown(container.dispose);

        // Act
        final notifier = container.read(themeProvider.notifier);

        // Assert - Should load dark theme from storage
        expect(notifier.state.theme.name, equals('dark'));
        verify(() => mockStorage.read<String>('selected_theme')).called(1);
      });

      test('theme changes are persisted via themeStorageProvider', () async {
        // Arrange
        final mockStorage = MockGetStorage();
        when(() => mockStorage.read<String>(any())).thenReturn(null);
        when(
          () => mockStorage.write(any<String>(), any<dynamic>()),
        ).thenAnswer((_) async => {});

        final container = ProviderContainer(
          overrides: [themeStorageProvider.overrideWithValue(mockStorage)],
        );
        addTearDown(container.dispose);

        // Act
        container
            .read(themeProvider.notifier)
            .setTheme(ThemeVariantsEnum.amoled);

        // Small delay to allow async write
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Assert - Storage should have been called to write
        verify(() => mockStorage.write('selected_theme', 'amoled')).called(1);
      });
    });

    group('provider overrides', () {
      test('can be overridden in tests', () {
        // Arrange
        final mockStorage = MockGetStorage();
        when(
          () => mockStorage.read<String>(any()),
        ).thenReturn('override_value');

        final container = ProviderContainer(
          overrides: [
            themeStorageProvider.overrideWithValue(mockStorage),
          ],
        );
        addTearDown(container.dispose);

        // Act
        final storage = container.read(themeStorageProvider);
        final value = storage.read<String>('test_override');

        // Assert
        expect(value, equals('override_value'));
        expect(identical(storage, mockStorage), isTrue);
      });

      test('override is scoped to container', () {
        // Arrange
        final mockStorage1 = MockGetStorage();
        final mockStorage2 = MockGetStorage();
        when(() => mockStorage1.read<String>(any())).thenReturn('container1');
        when(() => mockStorage2.read<String>(any())).thenReturn('container2');

        final container1 = ProviderContainer(
          overrides: [themeStorageProvider.overrideWithValue(mockStorage1)],
        );
        final container2 = ProviderContainer(
          overrides: [themeStorageProvider.overrideWithValue(mockStorage2)],
        );
        addTearDown(container1.dispose);
        addTearDown(container2.dispose);

        // Act
        final storage1 = container1.read(themeStorageProvider);
        final storage2 = container2.read(themeStorageProvider);
        final value1 = storage1.read<String>('key');
        final value2 = storage2.read<String>('key');

        // Assert
        expect(value1, equals('container1'));
        expect(value2, equals('container2'));
      });
    });

    group('real-world scenarios', () {
      test('handles theme and font storage keys', () async {
        // Arrange
        final mockStorage = MockGetStorage();
        when(
          () => mockStorage.write(any<String>(), any<dynamic>()),
        ).thenAnswer((_) async => {});
        when(
          () => mockStorage.read<String>('selected_theme'),
        ).thenReturn('dark');
        when(
          () => mockStorage.read<String>('selected_font'),
        ).thenReturn('montserrat');

        final container = ProviderContainer(
          overrides: [themeStorageProvider.overrideWithValue(mockStorage)],
        );
        addTearDown(container.dispose);
        final storage = container.read(themeStorageProvider);

        // Act - Store theme preferences
        await storage.write('selected_theme', 'dark');
        await storage.write('selected_font', 'montserrat');

        final theme = storage.read<String>('selected_theme');
        final font = storage.read<String>('selected_font');

        // Assert
        expect(theme, equals('dark'));
        expect(font, equals('montserrat'));
      });

      test('storage works with various data types', () {
        // Arrange
        final mockStorage = MockGetStorage();
        when(
          () => mockStorage.read<String>('string_key'),
        ).thenReturn('string_value');
        when(() => mockStorage.read<int>('int_key')).thenReturn(42);
        when(() => mockStorage.read<bool>('bool_key')).thenReturn(true);
        when(
          () => mockStorage.read<List<dynamic>>('list_key'),
        ).thenReturn(['a', 'b', 'c']);

        final container = ProviderContainer(
          overrides: [themeStorageProvider.overrideWithValue(mockStorage)],
        );
        addTearDown(container.dispose);
        final storage = container.read(themeStorageProvider);

        // Act
        final stringValue = storage.read<String>('string_key');
        final intValue = storage.read<int>('int_key');
        final boolValue = storage.read<bool>('bool_key');
        final listValue = storage.read<List<dynamic>>('list_key');

        // Assert
        expect(stringValue, equals('string_value'));
        expect(intValue, equals(42));
        expect(boolValue, isTrue);
        expect(listValue, equals(['a', 'b', 'c']));
      });

      test('supports theme notifier initialization from storage', () {
        // Arrange
        final mockStorage = MockGetStorage();
        when(
          () => mockStorage.read<String>('selected_theme'),
        ).thenReturn('amoled');
        when(
          () => mockStorage.read<String>('selected_font'),
        ).thenReturn('montserrat');

        final container = ProviderContainer(
          overrides: [themeStorageProvider.overrideWithValue(mockStorage)],
        );
        addTearDown(container.dispose);

        // Act
        final state = container.read(themeProvider);

        // Assert
        expect(state.theme, equals(ThemeVariantsEnum.amoled));
        expect(state.font, equals(AppFontFamily.montserrat));
      });
    });
  });
}
