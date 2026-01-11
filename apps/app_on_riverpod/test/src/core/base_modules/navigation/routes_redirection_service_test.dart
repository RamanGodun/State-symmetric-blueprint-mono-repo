/// Tests for Routes Redirection Service
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - computeRedirect function logic
/// - AuthLoading state handling
/// - AuthFailure state handling
/// - AuthReady state with various session states
/// - Route access control (public, protected, verified)
/// - Hysteresis behavior for Loading state
library;

import 'package:app_on_riverpod/core/base_modules/navigation/go_router_factory.dart';
import 'package:app_on_riverpod/core/base_modules/navigation/routes/app_routes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/core_contracts/auth.dart';

import '../../../../fixtures/test_constants.dart';


void main() {
  group('computeRedirect', () {
    group('AuthLoading state', () {
      test('redirects to splash on first resolution when not on splash', () {
        // Arrange
        const snapshot = AuthLoading();
        const hasResolvedOnce = false;
        const currentPath = RoutesPaths.signIn;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: snapshot,
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert
        expect(result, equals(RoutesPaths.splash));
      });

      test('stays on splash on first resolution when already on splash', () {
        // Arrange
        const snapshot = AuthLoading();
        const hasResolvedOnce = false;
        const currentPath = RoutesPaths.splash;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: snapshot,
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert
        expect(result, isNull);
      });

      test('does not redirect after first resolution (hysteresis)', () {
        // Arrange
        const snapshot = AuthLoading();
        const hasResolvedOnce = true;
        const currentPath = RoutesPaths.signIn;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: snapshot,
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert
        expect(result, isNull);
      });

      test('handles all paths correctly after first resolution', () {
        // Arrange
        const snapshot = AuthLoading();
        const hasResolvedOnce = true;
        final paths = [
          RoutesPaths.home,
          RoutesPaths.signIn,
          RoutesPaths.signUp,
          RoutesPaths.verifyEmail,
          RoutesPaths.resetPassword,
        ];

        for (final path in paths) {
          // Act
          final result = computeRedirect(
            currentPath: path,
            snapshot: snapshot,
            hasResolvedOnce: hasResolvedOnce,
          );

          // Assert
          expect(result, isNull, reason: 'Failed for path: $path');
        }
      });
    });

    group('AuthFailure state', () {
      test('always redirects to sign-in on failure', () {
        // Arrange
        final snapshot = AuthFailure(Exception('Auth error'));
        const hasResolvedOnce = true;

        final paths = [
          RoutesPaths.home,
          RoutesPaths.signUp,
          RoutesPaths.verifyEmail,
          RoutesPaths.splash,
        ];

        for (final path in paths) {
          // Act
          final result = computeRedirect(
            currentPath: path,
            snapshot: snapshot,
            hasResolvedOnce: hasResolvedOnce,
          );

          // Assert
          expect(result, equals(RoutesPaths.signIn), reason: 'Failed for path: $path');
        }
      });

      test('stays on sign-in when already there on failure', () {
        // Arrange
        final snapshot = AuthFailure(Exception('Auth error'));
        const hasResolvedOnce = true;
        const currentPath = RoutesPaths.signIn;

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

    group('AuthReady - unauthenticated user', () {
      test('redirects to sign-in when accessing protected routes', () {
        // Arrange
        const snapshot = AuthReady(TestConstants.unauthenticatedSession);
        const hasResolvedOnce = true;

        final protectedPaths = [
          RoutesPaths.home,
          RoutesPaths.verifyEmail,
        ];

        for (final path in protectedPaths) {
          // Act
          final result = computeRedirect(
            currentPath: path,
            snapshot: snapshot,
            hasResolvedOnce: hasResolvedOnce,
          );

          // Assert
          expect(result, equals(RoutesPaths.signIn), reason: 'Failed for path: $path');
        }
      });

      test('stays on public routes when unauthenticated', () {
        // Arrange
        const snapshot = AuthReady(TestConstants.unauthenticatedSession);
        const hasResolvedOnce = true;

        final publicPaths = [
          RoutesPaths.signIn,
          RoutesPaths.signUp,
          RoutesPaths.resetPassword,
        ];

        for (final path in publicPaths) {
          // Act
          final result = computeRedirect(
            currentPath: path,
            snapshot: snapshot,
            hasResolvedOnce: hasResolvedOnce,
          );

          // Assert
          expect(result, isNull, reason: 'Failed for path: $path');
        }
      });
    });

    group('AuthReady - authenticated but unverified user', () {
      test('redirects to verify-email when accessing other routes', () {
        // Arrange
        const snapshot = AuthReady(TestConstants.unverifiedSession);
        const hasResolvedOnce = true;

        final restrictedPaths = [
          RoutesPaths.home,
          RoutesPaths.signIn,
          RoutesPaths.signUp,
        ];

        for (final path in restrictedPaths) {
          // Act
          final result = computeRedirect(
            currentPath: path,
            snapshot: snapshot,
            hasResolvedOnce: hasResolvedOnce,
          );

          // Assert
          expect(result, equals(RoutesPaths.verifyEmail), reason: 'Failed for path: $path');
        }
      });

      test('stays on verify-email when already there', () {
        // Arrange
        const snapshot = AuthReady(TestConstants.unverifiedSession);
        const hasResolvedOnce = true;
        const currentPath = RoutesPaths.verifyEmail;

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

    group('AuthReady - authenticated and verified user', () {
      test('redirects to home from public routes', () {
        // Arrange
        const snapshot = AuthReady(TestConstants.authenticatedSession);
        const hasResolvedOnce = true;

        final publicPaths = [
          RoutesPaths.signIn,
          RoutesPaths.signUp,
          RoutesPaths.resetPassword,
        ];

        for (final path in publicPaths) {
          // Act
          final result = computeRedirect(
            currentPath: path,
            snapshot: snapshot,
            hasResolvedOnce: hasResolvedOnce,
          );

          // Assert
          expect(result, equals(RoutesPaths.home), reason: 'Failed for path: $path');
        }
      });

      test('redirects to home from splash', () {
        // Arrange
        const snapshot = AuthReady(TestConstants.authenticatedSession);
        const hasResolvedOnce = true;
        const currentPath = RoutesPaths.splash;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: snapshot,
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert
        expect(result, equals(RoutesPaths.home));
      });

      test('redirects to home from verify-email', () {
        // Arrange
        const snapshot = AuthReady(TestConstants.authenticatedSession);
        const hasResolvedOnce = true;
        const currentPath = RoutesPaths.verifyEmail;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: snapshot,
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert
        expect(result, equals(RoutesPaths.home));
      });

      test('stays on home when already there', () {
        // Arrange
        const snapshot = AuthReady(TestConstants.authenticatedSession);
        const hasResolvedOnce = true;
        const currentPath = RoutesPaths.home;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: snapshot,
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert
        expect(result, isNull);
      });

      test('allows access to protected routes', () {
        // Arrange
        const snapshot = AuthReady(TestConstants.authenticatedSession);
        const hasResolvedOnce = true;

        // Simulate a protected route (not in restricted set)
        const currentPath = '/some-protected-route';

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

    group('edge cases and complex scenarios', () {
      test('handles first resolution correctly for different states', () {
        // Arrange
        const hasResolvedOnce = false;
        const currentPath = RoutesPaths.signIn;

        // Test Loading
        var result = computeRedirect(
          currentPath: currentPath,
          snapshot: const AuthLoading(),
          hasResolvedOnce: hasResolvedOnce,
        );
        expect(result, equals(RoutesPaths.splash));

        // Test Failure
        result = computeRedirect(
          currentPath: currentPath,
          snapshot: AuthFailure(Exception('Error')),
          hasResolvedOnce: hasResolvedOnce,
        );
        expect(result, equals(RoutesPaths.signIn));

        // Test Ready
        result = computeRedirect(
          currentPath: currentPath,
          snapshot: const AuthReady(TestConstants.unauthenticatedSession),
          hasResolvedOnce: hasResolvedOnce,
        );
        expect(result, isNull);
      });

      test('handles user flow: loading -> unauthenticated -> authenticated -> verified', () {
        // Arrange
        const hasResolvedOnce = true;

        // Step 1: Loading (after first resolution)
        var result = computeRedirect(
          currentPath: RoutesPaths.signIn,
          snapshot: const AuthLoading(),
          hasResolvedOnce: hasResolvedOnce,
        );
        expect(result, isNull);

        // Step 2: Unauthenticated on sign-in
        result = computeRedirect(
          currentPath: RoutesPaths.signIn,
          snapshot: const AuthReady(TestConstants.unauthenticatedSession),
          hasResolvedOnce: hasResolvedOnce,
        );
        expect(result, isNull);

        // Step 3: Authenticated but unverified
        result = computeRedirect(
          currentPath: RoutesPaths.signIn,
          snapshot: const AuthReady(TestConstants.unverifiedSession),
          hasResolvedOnce: hasResolvedOnce,
        );
        expect(result, equals(RoutesPaths.verifyEmail));

        // Step 4: Verified, should redirect to home
        result = computeRedirect(
          currentPath: RoutesPaths.verifyEmail,
          snapshot: const AuthReady(TestConstants.authenticatedSession),
          hasResolvedOnce: hasResolvedOnce,
        );
        expect(result, equals(RoutesPaths.home));
      });

      test('prevents infinite redirect loops', () {
        // Arrange - authenticated user on home
        const snapshot = AuthReady(TestConstants.authenticatedSession);
        const hasResolvedOnce = true;
        const currentPath = RoutesPaths.home;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: snapshot,
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert - should not redirect
        expect(result, isNull);
      });

      test('handles rapid state changes correctly', () {
        // Arrange
        const currentPath = RoutesPaths.signIn;
        const hasResolvedOnce = true;

        // Simulate rapid auth state changes
        final snapshots = [
          const AuthLoading(),
          AuthFailure(Exception('Error')),
          const AuthReady(TestConstants.unauthenticatedSession),
          const AuthReady(TestConstants.authenticatedSession),
        ];

        final expectedResults = [
          null, // Loading after first resolution
          RoutesPaths.signIn, // Failure
          null, // Unauthenticated on public route
          RoutesPaths.home, // Authenticated should go home
        ];

        for (var i = 0; i < snapshots.length; i++) {
          // Act
          final result = computeRedirect(
            currentPath: currentPath,
            snapshot: snapshots[i],
            hasResolvedOnce: hasResolvedOnce,
          );

          // Assert
          expect(result, equals(expectedResults[i]), reason: 'Failed for snapshot $i');
        }
      });
    });

    group('real-world scenarios', () {
      test('user opens app for first time', () {
        // Arrange - app starts with loading
        const hasResolvedOnce = false;
        const currentPath = RoutesPaths.home;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: const AuthLoading(),
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert - should show splash
        expect(result, equals(RoutesPaths.splash));
      });

      test('user signs in successfully', () {
        // Arrange - user on sign-in page, becomes authenticated
        const hasResolvedOnce = true;
        const currentPath = RoutesPaths.signIn;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: const AuthReady(TestConstants.authenticatedSession),
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert - should redirect to home
        expect(result, equals(RoutesPaths.home));
      });

      test('user signs out', () {
        // Arrange - user on home page, becomes unauthenticated
        const hasResolvedOnce = true;
        const currentPath = RoutesPaths.home;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: const AuthReady(TestConstants.unauthenticatedSession),
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert - should redirect to sign-in
        expect(result, equals(RoutesPaths.signIn));
      });

      test('user needs to verify email', () {
        // Arrange - user just signed up, not verified
        const hasResolvedOnce = true;
        const currentPath = RoutesPaths.signUp;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: const AuthReady(TestConstants.unverifiedSession),
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert - should redirect to verify email
        expect(result, equals(RoutesPaths.verifyEmail));
      });

      test('user completes email verification', () {
        // Arrange - user on verify page, becomes verified
        const hasResolvedOnce = true;
        const currentPath = RoutesPaths.verifyEmail;

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: const AuthReady(TestConstants.authenticatedSession),
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert - should redirect to home
        expect(result, equals(RoutesPaths.home));
      });

      test('unauthenticated user tries to access profile', () {
        // Arrange
        const hasResolvedOnce = true;
        const currentPath = '/profile';

        // Act
        final result = computeRedirect(
          currentPath: currentPath,
          snapshot: const AuthReady(TestConstants.unauthenticatedSession),
          hasResolvedOnce: hasResolvedOnce,
        );

        // Assert - should redirect to sign-in
        expect(result, equals(RoutesPaths.signIn));
      });
    });
  });
}
