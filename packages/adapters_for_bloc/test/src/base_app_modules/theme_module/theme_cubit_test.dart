/// Tests for [AppThemeCubit]
///
/// Coverage:
/// - Theme state management
/// - Font state management
/// - Persistence via HydratedCubit
/// - Theme toggling
library;

import 'package:adapters_for_bloc/src/base_app_modules/theme_module/theme_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  group('AppThemeCubit', () {
    late AppThemeCubit cubit;
    late Storage storage;

    setUp(() {
      storage = MockStorage();
      when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
      when(() => storage.read(any())).thenReturn(null);
      HydratedBloc.storage = storage;

      cubit = AppThemeCubit();
    });

    tearDown(() async {
      await cubit.close();
    });

    group('initial state', () {
      test('starts with light theme and inter font', () {
        expect(cubit.state.theme, ThemeVariantsEnum.light);
        expect(cubit.state.font, AppFontFamily.inter);
      });
    });

    group('setTheme', () {
      test('updates theme variant', () {
        cubit.setTheme(ThemeVariantsEnum.dark);
        expect(cubit.state.theme, ThemeVariantsEnum.dark);
      });

      test('preserves font when changing theme', () {
        cubit
          ..setFont(AppFontFamily.montserrat)
          ..setTheme(ThemeVariantsEnum.dark);

        expect(cubit.state.theme, ThemeVariantsEnum.dark);
        expect(cubit.state.font, AppFontFamily.montserrat);
      });
    });

    group('setFont', () {
      test('updates font family', () {
        cubit.setFont(AppFontFamily.montserrat);
        expect(cubit.state.font, AppFontFamily.montserrat);
      });

      test('preserves theme when changing font', () {
        cubit
          ..setTheme(ThemeVariantsEnum.dark)
          ..setFont(AppFontFamily.montserrat);

        expect(cubit.state.theme, ThemeVariantsEnum.dark);
        expect(cubit.state.font, AppFontFamily.montserrat);
      });
    });

    group('setThemeAndFont', () {
      test('updates both theme and font', () {
        cubit.setThemeAndFont(
          ThemeVariantsEnum.amoled,
          AppFontFamily.montserrat,
        );

        expect(cubit.state.theme, ThemeVariantsEnum.amoled);
        expect(cubit.state.font, AppFontFamily.montserrat);
      });
    });

    group('toggleTheme', () {
      test('switches from light to dark', () {
        cubit.toggleTheme();
        expect(cubit.state.theme, ThemeVariantsEnum.dark);
      });

      test('switches from dark to light', () {
        cubit
          ..setTheme(ThemeVariantsEnum.dark)
          ..toggleTheme();

        expect(cubit.state.theme, ThemeVariantsEnum.light);
      });

      test('switches from amoled to dark', () {
        cubit
          ..setTheme(ThemeVariantsEnum.amoled)
          ..toggleTheme();

        expect(cubit.state.theme, ThemeVariantsEnum.dark);
      });
    });

    group('toggleThemeCycled', () {
      test('cycles light → dark → amoled → light', () {
        expect(cubit.state.theme, ThemeVariantsEnum.light);

        cubit.toggleThemeCycled();
        expect(cubit.state.theme, ThemeVariantsEnum.dark);

        cubit.toggleThemeCycled();
        expect(cubit.state.theme, ThemeVariantsEnum.amoled);

        cubit.toggleThemeCycled();
        expect(cubit.state.theme, ThemeVariantsEnum.light);
      });
    });

    group('JSON serialization', () {
      test('toJson serializes theme and font correctly', () {
        cubit.setThemeAndFont(ThemeVariantsEnum.dark, AppFontFamily.montserrat);

        final json = cubit.toJson(cubit.state);

        expect(json, {
          'theme': 'dark',
          'font': 'montserrat',
        });
      });

      test('fromJson deserializes theme correctly', () {
        final state = cubit.fromJson({
          'theme': 'amoled',
          'font': 'inter',
        });

        expect(state?.theme, ThemeVariantsEnum.amoled);
        expect(state?.font, AppFontFamily.inter);
      });

      test('fromJson handles invalid theme gracefully', () {
        final state = cubit.fromJson({
          'theme': 'invalid',
          'font': 'inter',
        });

        expect(state?.theme, ThemeVariantsEnum.light); // Default
        expect(state?.font, AppFontFamily.inter);
      });

      test('fromJson handles missing keys', () {
        final state = cubit.fromJson({});

        expect(state?.theme, ThemeVariantsEnum.light);
      });
    });
  });
}
