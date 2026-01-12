/// Tests for RoutesPaths
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
///
/// Coverage:
/// - Route path constants validation
/// - Path format consistency (leading slash)
/// - Nested path structure validation
/// - Relationship between paths and names
library;

import 'package:app_on_cubit/core/base_modules/navigation/routes/app_routes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RoutesPaths', () {
    group('splash route', () {
      test('has correct value with leading slash', () {
        // Arrange & Act
        const path = RoutesPaths.splash;

        // Assert
        expect(path, equals('/splash'));
        expect(path, startsWith('/'));
        expect(path, isA<String>());
      });

      test('matches RoutesNames.splash', () {
        // Arrange & Act
        const path = RoutesPaths.splash;

        // Assert
        expect(path, equals('/${RoutesNames.splash}'));
      });
    });

    group('authentication routes', () {
      test('signIn has correct value', () {
        // Arrange & Act
        const path = RoutesPaths.signIn;

        // Assert
        expect(path, equals('/signin'));
        expect(path, startsWith('/'));
        expect(path, equals('/${RoutesNames.signIn}'));
      });

      test('signUp has correct value', () {
        // Arrange & Act
        const path = RoutesPaths.signUp;

        // Assert
        expect(path, equals('/signup'));
        expect(path, startsWith('/'));
        expect(path, equals('/${RoutesNames.signUp}'));
      });

      test('resetPassword has correct value', () {
        // Arrange & Act
        const path = RoutesPaths.resetPassword;

        // Assert
        expect(path, equals('/resetPassword'));
        expect(path, startsWith('/'));
        expect(path, equals('/${RoutesNames.resetPassword}'));
      });

      test('verifyEmail has correct value', () {
        // Arrange & Act
        const path = RoutesPaths.verifyEmail;

        // Assert
        expect(path, equals('/verifyEmail'));
        expect(path, startsWith('/'));
        expect(path, equals('/${RoutesNames.verifyEmail}'));
      });
    });

    group('main app routes', () {
      test('home has correct value', () {
        // Arrange & Act
        const path = RoutesPaths.home;

        // Assert
        expect(path, equals('/home'));
        expect(path, startsWith('/'));
        expect(path, equals('/${RoutesNames.home}'));
      });

      test('profile is nested under home', () {
        // Arrange & Act
        const path = RoutesPaths.profile;

        // Assert
        expect(path, equals('/home/profile'));
        expect(path, startsWith('/'));
        expect(path, contains(RoutesPaths.home));
        expect(path, equals('${RoutesPaths.home}/${RoutesNames.profile}'));
      });

      test('changePassword is nested under profile', () {
        // Arrange & Act
        const path = RoutesPaths.changePassword;

        // Assert
        expect(path, equals('/home/profile/changePassword'));
        expect(path, startsWith('/'));
        expect(path, contains(RoutesPaths.profile));
        expect(
          path,
          equals('${RoutesPaths.profile}/${RoutesNames.changePassword}'),
        );
      });
    });

    group('error routes', () {
      test('pageNotFound has correct value', () {
        // Arrange & Act
        const path = RoutesPaths.pageNotFound;

        // Assert
        expect(path, equals('/pageNotFound'));
        expect(path, startsWith('/'));
        expect(path, equals('/${RoutesNames.pageNotFound}'));
      });
    });

    group('path format consistency', () {
      test('all root-level paths start with single slash', () {
        // Arrange
        final rootPaths = [
          RoutesPaths.splash,
          RoutesPaths.signIn,
          RoutesPaths.signUp,
          RoutesPaths.resetPassword,
          RoutesPaths.verifyEmail,
          RoutesPaths.home,
          RoutesPaths.pageNotFound,
        ];

        // Act & Assert
        for (final path in rootPaths) {
          expect(
            path,
            startsWith('/'),
            reason: 'Path $path should start with /',
          );
          expect(
            path.indexOf('/'),
            equals(0),
            reason: 'Path $path should have slash at index 0',
          );
        }
      });

      test('all paths are non-empty strings', () {
        // Arrange
        final allPaths = [
          RoutesPaths.splash,
          RoutesPaths.signIn,
          RoutesPaths.signUp,
          RoutesPaths.resetPassword,
          RoutesPaths.verifyEmail,
          RoutesPaths.home,
          RoutesPaths.profile,
          RoutesPaths.changePassword,
          RoutesPaths.pageNotFound,
        ];

        // Act & Assert
        for (final path in allPaths) {
          expect(path, isNotEmpty, reason: 'Path should not be empty');
          expect(path, isA<String>());
        }
      });

      test('nested paths contain their parent paths', () {
        // Assert
        expect(RoutesPaths.profile, contains(RoutesPaths.home));
        expect(RoutesPaths.changePassword, contains(RoutesPaths.profile));
        expect(RoutesPaths.changePassword, contains(RoutesPaths.home));
      });
    });

    group('path uniqueness', () {
      test('all route paths are unique', () {
        // Arrange
        final allPaths = [
          RoutesPaths.splash,
          RoutesPaths.signIn,
          RoutesPaths.signUp,
          RoutesPaths.resetPassword,
          RoutesPaths.verifyEmail,
          RoutesPaths.home,
          RoutesPaths.profile,
          RoutesPaths.changePassword,
          RoutesPaths.pageNotFound,
        ];

        // Act
        final uniquePaths = allPaths.toSet();

        // Assert
        expect(
          uniquePaths.length,
          equals(allPaths.length),
          reason: 'All route paths should be unique',
        );
      });
    });
  });
}
