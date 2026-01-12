/// Tests for RoutesNames
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
///
/// Coverage:
/// - Route name constants validation
/// - Ensure all route names are properly defined
/// - Verify route name format consistency
library;

import 'package:app_on_cubit/core/base_modules/navigation/routes/app_routes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RoutesNames', () {
    group('splash route', () {
      test('has correct value', () {
        // Arrange & Act
        const routeName = RoutesNames.splash;

        // Assert
        expect(routeName, equals('splash'));
        expect(routeName, isA<String>());
        expect(routeName, isNotEmpty);
      });
    });

    group('authentication routes', () {
      test('signIn has correct value', () {
        // Arrange & Act
        const routeName = RoutesNames.signIn;

        // Assert
        expect(routeName, equals('signin'));
        expect(routeName, isA<String>());
        expect(routeName, isNotEmpty);
      });

      test('signUp has correct value', () {
        // Arrange & Act
        const routeName = RoutesNames.signUp;

        // Assert
        expect(routeName, equals('signup'));
        expect(routeName, isA<String>());
        expect(routeName, isNotEmpty);
      });

      test('verifyEmail has correct value', () {
        // Arrange & Act
        const routeName = RoutesNames.verifyEmail;

        // Assert
        expect(routeName, equals('verifyEmail'));
        expect(routeName, isA<String>());
        expect(routeName, isNotEmpty);
      });
    });

    group('main app routes', () {
      test('home has correct value', () {
        // Arrange & Act
        const routeName = RoutesNames.home;

        // Assert
        expect(routeName, equals('home'));
        expect(routeName, isA<String>());
        expect(routeName, isNotEmpty);
      });

      test('profile has correct value', () {
        // Arrange & Act
        const routeName = RoutesNames.profile;

        // Assert
        expect(routeName, equals('profile'));
        expect(routeName, isA<String>());
        expect(routeName, isNotEmpty);
      });
    });

    group('password routes', () {
      test('resetPassword has correct value', () {
        // Arrange & Act
        const routeName = RoutesNames.resetPassword;

        // Assert
        expect(routeName, equals('resetPassword'));
        expect(routeName, isA<String>());
        expect(routeName, isNotEmpty);
      });

      test('changePassword has correct value', () {
        // Arrange & Act
        const routeName = RoutesNames.changePassword;

        // Assert
        expect(routeName, equals('changePassword'));
        expect(routeName, isA<String>());
        expect(routeName, isNotEmpty);
      });
    });

    group('error routes', () {
      test('pageNotFound has correct value', () {
        // Arrange & Act
        const routeName = RoutesNames.pageNotFound;

        // Assert
        expect(routeName, equals('pageNotFound'));
        expect(routeName, isA<String>());
        expect(routeName, isNotEmpty);
      });
    });

    group('route names uniqueness', () {
      test('all route names are unique', () {
        // Arrange
        final routeNames = [
          RoutesNames.splash,
          RoutesNames.signIn,
          RoutesNames.signUp,
          RoutesNames.verifyEmail,
          RoutesNames.home,
          RoutesNames.profile,
          RoutesNames.resetPassword,
          RoutesNames.changePassword,
          RoutesNames.pageNotFound,
        ];

        // Act
        final uniqueNames = routeNames.toSet();

        // Assert
        expect(
          uniqueNames.length,
          equals(routeNames.length),
          reason: 'All route names should be unique',
        );
      });
    });
  });
}
