/// Tests for computeRedirect
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge case coverage
///
/// Coverage:
/// - Loading state redirects
/// - Failure state redirects
/// - Authenticated/unauthenticated redirects
/// - Email verification redirects
/// - Public route access
/// - Hysteresis behavior
library;

import 'package:app_on_cubit/core/base_modules/navigation/go_router_factory.dart';
import 'package:app_on_cubit/core/base_modules/navigation/routes/app_routes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/core_contracts/auth.dart';

void main() {
  group('computeRedirect', () {
    group('AuthLoading state', () {
      test(
        'redirects to splash when hasResolvedOnce is false and not on splash',
        () {
          // Arrange
          const snapshot = AuthLoading();
          const currentPath = RoutesPaths.home;
          const hasResolvedOnce = false;

          // Act
          final result = computeRedirect(
            currentPath: currentPath,
            snapshot: snapshot,
            hasResolvedOnce: hasResolvedOnce,
          );

          // Assert
          expect(result, equals(RoutesPaths.splash));
        },
      );

      test(
        'returns null when hasResolvedOnce is false and already on splash',
        () {
          // Arrange
          const snapshot = AuthLoading();
          const currentPath = RoutesPaths.splash;
          const hasResolvedOnce = false;

          // Act
          final result = computeRedirect(
            currentPath: currentPath,
            snapshot: snapshot,
            hasResolvedOnce: hasResolvedOnce,
          );

          // Assert
          expect(result, isNull);
        },
      );

      test('returns null when hasResolvedOnce is true (hysteresis)', () {
        // Arrange
        const snapshot = AuthLoading();
        const currentPath = RoutesPaths.home;
        const hasResolvedOnce = true;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: snapshot,
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert
        expect(result, isNull);
      });
    });

    group('AuthFailure state', () {
      test('always redirects to signIn', () {
        // Arrange
        final snapshot = AuthFailure(Exception('Test failure'));
        const currentPath = RoutesPaths.home;
        const hasResolvedOnce = true;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: snapshot,
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert
        expect(result, equals(RoutesPaths.signIn));
      });

      test('redirects to signIn even when on public route', () {
        // Arrange
        final snapshot = AuthFailure(Exception('Test failure'));
        const currentPath = RoutesPaths.signUp;
        const hasResolvedOnce = false;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: snapshot,
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert
        expect(result, equals(RoutesPaths.signIn));
      });
    });

    group('AuthReady - not authenticated', () {
      const unauthenticatedSession = AuthSession(
        isAnonymous: false,
        emailVerified: false,
      );

      test('allows access to signIn page', () {
        // Arrange
        const snapshot = AuthReady(unauthenticatedSession);
        const currentPath = RoutesPaths.signIn;
        const hasResolvedOnce = true;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: snapshot,
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert
        expect(result, isNull);
      });

      test('allows access to signUp page', () {
        // Arrange
        const snapshot = AuthReady(unauthenticatedSession);
        const currentPath = RoutesPaths.signUp;
        const hasResolvedOnce = true;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: snapshot,
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert
        expect(result, isNull);
      });

      test('allows access to resetPassword page', () {
        // Arrange
        const snapshot = AuthReady(unauthenticatedSession);
        const currentPath = RoutesPaths.resetPassword;
        const hasResolvedOnce = true;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: snapshot,
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert
        expect(result, isNull);
      });

      test('redirects to signIn when trying to access protected route', () {
        // Arrange
        const snapshot = AuthReady(unauthenticatedSession);
        const currentPath = RoutesPaths.home;
        const hasResolvedOnce = true;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: snapshot,
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert
        expect(result, equals(RoutesPaths.signIn));
      });

      test('redirects to signIn when trying to access profile', () {
        // Arrange
        const snapshot = AuthReady(unauthenticatedSession);
        const currentPath = RoutesPaths.profile;
        const hasResolvedOnce = true;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: snapshot,
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert
        expect(result, equals(RoutesPaths.signIn));
      });
    });

    group('AuthReady - authenticated but not verified', () {
      const unverifiedSession = AuthSession(
        uid: 'test-user-id',
        email: 'test@example.com',
        isAnonymous: false,
        emailVerified: false,
      );

      test('allows access to verifyEmail page', () {
        // Arrange
        const snapshot = AuthReady(unverifiedSession);
        const currentPath = RoutesPaths.verifyEmail;
        const hasResolvedOnce = true;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: snapshot,
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert
        expect(result, isNull);
      });

      test('redirects to verifyEmail when trying to access home', () {
        // Arrange
        const snapshot = AuthReady(unverifiedSession);
        const currentPath = RoutesPaths.home;
        const hasResolvedOnce = true;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: snapshot,
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert
        expect(result, equals(RoutesPaths.verifyEmail));
      });

      test('redirects to verifyEmail when on signIn page', () {
        // Arrange
        const snapshot = AuthReady(unverifiedSession);
        const currentPath = RoutesPaths.signIn;
        const hasResolvedOnce = true;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: snapshot,
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert
        expect(result, equals(RoutesPaths.verifyEmail));
      });
    });

    group('AuthReady - authenticated and verified', () {
      const verifiedSession = AuthSession(
        uid: 'test-user-id',
        email: 'test@example.com',
        isAnonymous: false,
        emailVerified: true,
      );

      test('allows access to home page', () {
        // Arrange
        const snapshot = AuthReady(verifiedSession);
        const currentPath = RoutesPaths.home;
        const hasResolvedOnce = true;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: snapshot,
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert
        expect(result, isNull);
      });

      test('allows access to profile page', () {
        // Arrange
        const snapshot = AuthReady(verifiedSession);
        const currentPath = RoutesPaths.profile;
        const hasResolvedOnce = true;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: snapshot,
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert
        expect(result, isNull);
      });

      test('redirects to home when on splash page', () {
        // Arrange
        const snapshot = AuthReady(verifiedSession);
        const currentPath = RoutesPaths.splash;
        const hasResolvedOnce = true;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: snapshot,
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert
        expect(result, equals(RoutesPaths.home));
      });

      test('redirects to home when on signIn page', () {
        // Arrange
        const snapshot = AuthReady(verifiedSession);
        const currentPath = RoutesPaths.signIn;
        const hasResolvedOnce = true;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: snapshot,
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert
        expect(result, equals(RoutesPaths.home));
      });

      test('redirects to home when on signUp page', () {
        // Arrange
        const snapshot = AuthReady(verifiedSession);
        const currentPath = RoutesPaths.signUp;
        const hasResolvedOnce = true;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: snapshot,
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert
        expect(result, equals(RoutesPaths.home));
      });

      test('redirects to home when on resetPassword page', () {
        // Arrange
        const snapshot = AuthReady(verifiedSession);
        const currentPath = RoutesPaths.resetPassword;
        const hasResolvedOnce = true;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: snapshot,
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert
        expect(result, equals(RoutesPaths.home));
      });

      test('redirects to home when on verifyEmail page', () {
        // Arrange
        const snapshot = AuthReady(verifiedSession);
        const currentPath = RoutesPaths.verifyEmail;
        const hasResolvedOnce = true;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: snapshot,
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert
        expect(result, equals(RoutesPaths.home));
      });

      test('allows access to changePassword page', () {
        // Arrange
        const snapshot = AuthReady(verifiedSession);
        const currentPath = RoutesPaths.changePassword;
        const hasResolvedOnce = true;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: snapshot,
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert
        expect(result, isNull);
      });
    });
  });
}
