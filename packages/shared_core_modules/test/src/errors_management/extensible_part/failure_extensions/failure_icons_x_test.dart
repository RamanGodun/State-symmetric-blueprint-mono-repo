// Tests use const constructors extensively for immutable objects

/// Tests for `FailureIconX` extension
///
/// Coverage:
/// - Icon mapping for all FailureType variants
/// - Fallback icon for unknown types
/// - Icon consistency
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';

void main() {
  group('FailureIconX', () {
    group('Network failure types', () {
      test('NetworkFailureType returns wifi offline icon', () {
        // Arrange
        const type = NetworkFailureType();

        // Act
        final icon = type.icon;

        // Assert
        expect(icon, equals(Icons.signal_wifi_connected_no_internet_4));
      });

      test('NetworkTimeoutFailureType returns schedule icon', () {
        // Arrange
        const type = NetworkTimeoutFailureType();

        // Act
        final icon = type.icon;

        // Assert
        expect(icon, equals(Icons.schedule));
      });

      test('JsonErrorFailureType returns code icon', () {
        // Arrange
        const type = JsonErrorFailureType();

        // Act
        final icon = type.icon;

        // Assert
        expect(icon, equals(Icons.code));
      });

      test('ApiFailureType returns cloud off icon', () {
        // Arrange
        const type = ApiFailureType();

        // Act
        final icon = type.icon;

        // Assert
        expect(icon, equals(Icons.cloud_off));
      });

      test('UnauthorizedFailureType returns lock icon', () {
        // Arrange
        const type = UnauthorizedFailureType();

        // Act
        final icon = type.icon;

        // Assert
        expect(icon, equals(Icons.lock));
      });
    });

    group('Misc failure types', () {
      test('UnknownFailureType returns error outline icon', () {
        // Arrange
        const type = UnknownFailureType();

        // Act
        final icon = type.icon;

        // Assert
        expect(icon, equals(Icons.error_outline));
      });

      test('CacheFailureType returns sd storage icon', () {
        // Arrange
        const type = CacheFailureType();

        // Act
        final icon = type.icon;

        // Assert
        expect(icon, equals(Icons.sd_storage));
      });

      test('EmailVerificationTimeoutFailureType returns email unread icon', () {
        // Arrange
        const type = EmailVerificationTimeoutFailureType();

        // Act
        final icon = type.icon;

        // Assert
        expect(icon, equals(Icons.mark_email_unread));
      });

      test('FormatFailureType returns format icon', () {
        // Arrange
        const type = FormatFailureType();

        // Act
        final icon = type.icon;

        // Assert
        expect(icon, equals(Icons.format_align_justify));
      });

      test('MissingPluginFailureType returns extension off icon', () {
        // Arrange
        const type = MissingPluginFailureType();

        // Act
        final icon = type.icon;

        // Assert
        expect(icon, equals(Icons.extension_off));
      });
    });

    group('Firebase failure types', () {
      test('GenericFirebaseFailureType returns fire department icon', () {
        // Arrange
        const type = GenericFirebaseFailureType();

        // Act
        final icon = type.icon;

        // Assert
        expect(icon, equals(Icons.local_fire_department));
      });

      test('InvalidCredentialFirebaseFailureType returns vpn key off icon', () {
        // Arrange
        const type = InvalidCredentialFirebaseFailureType();

        // Act
        final icon = type.icon;

        // Assert
        expect(icon, equals(Icons.vpn_key_off));
      });

      test('EmailAlreadyInUseFirebaseFailureType returns email read icon', () {
        // Arrange
        const type = EmailAlreadyInUseFirebaseFailureType();

        // Act
        final icon = type.icon;

        // Assert
        expect(icon, equals(Icons.mark_email_read));
      });

      test(
        'OperationNotAllowedFirebaseFailureType returns do not disturb icon',
        () {
          // Arrange
          const type = OperationNotAllowedFirebaseFailureType();

          // Act
          final icon = type.icon;

          // Assert
          expect(icon, equals(Icons.do_not_disturb_alt));
        },
      );

      test('UserDisabledFirebaseFailureType returns block icon', () {
        // Arrange
        const type = UserDisabledFirebaseFailureType();

        // Act
        final icon = type.icon;

        // Assert
        expect(icon, equals(Icons.block));
      });

      test('UserNotFoundFirebaseFailureType returns person search icon', () {
        // Arrange
        const type = UserNotFoundFirebaseFailureType();

        // Act
        final icon = type.icon;

        // Assert
        expect(icon, equals(Icons.person_search));
      });

      test('RequiresRecentLoginFirebaseFailureType has valid icon', () {
        // Arrange
        const type = RequiresRecentLoginFirebaseFailureType();

        // Act
        final icon = type.icon;

        // Assert
        expect(icon, isA<IconData>());
        expect(icon, isNot(equals(Icons.error))); // Not fallback
      });

      test('UserMissingFirebaseFailureType returns no accounts icon', () {
        // Arrange
        const type = UserMissingFirebaseFailureType();

        // Act
        final icon = type.icon;

        // Assert
        expect(icon, equals(Icons.no_accounts));
      });

      test('DocMissingFirebaseFailureType returns file icon', () {
        // Arrange
        const type = DocMissingFirebaseFailureType();

        // Act
        final icon = type.icon;

        // Assert
        expect(icon, equals(Icons.insert_drive_file));
      });

      test('TooManyRequestsFirebaseFailureType returns timer icon', () {
        // Arrange
        const type = TooManyRequestsFirebaseFailureType();

        // Act
        final icon = type.icon;

        // Assert
        expect(icon, equals(Icons.timer));
      });

      test(
        'AccountExistsWithDifferentCredentialFirebaseFailureType returns account icon',
        () {
          // Arrange
          const type =
              AccountExistsWithDifferentCredentialFirebaseFailureType();

          // Act
          final icon = type.icon;

          // Assert
          expect(icon, equals(Icons.account_circle));
        },
      );
    });

    group('icon consistency', () {
      test('all failure types return valid IconData', () {
        // Arrange
        final allTypes = [
          const NetworkFailureType(),
          const NetworkTimeoutFailureType(),
          const JsonErrorFailureType(),
          const ApiFailureType(),
          const UnauthorizedFailureType(),
          const UnknownFailureType(),
          const CacheFailureType(),
          const EmailVerificationTimeoutFailureType(),
          const FormatFailureType(),
          const MissingPluginFailureType(),
          const GenericFirebaseFailureType(),
          const InvalidCredentialFirebaseFailureType(),
          const EmailAlreadyInUseFirebaseFailureType(),
          const OperationNotAllowedFirebaseFailureType(),
          const UserDisabledFirebaseFailureType(),
          const UserNotFoundFirebaseFailureType(),
          const RequiresRecentLoginFirebaseFailureType(),
          const UserMissingFirebaseFailureType(),
          const DocMissingFirebaseFailureType(),
          const TooManyRequestsFirebaseFailureType(),
          const AccountExistsWithDifferentCredentialFirebaseFailureType(),
        ];

        // Act & Assert
        for (final type in allTypes) {
          expect(
            type.icon,
            isA<IconData>(),
            reason: '${type.runtimeType} should return IconData',
          );
        }
      });

      test('all icons are non-null', () {
        // Arrange
        final allTypes = [
          const NetworkFailureType(),
          const ApiFailureType(),
          const UnknownFailureType(),
          const GenericFirebaseFailureType(),
        ];

        // Act & Assert
        for (final type in allTypes) {
          expect(
            type.icon,
            isNotNull,
            reason: '${type.runtimeType} icon should not be null',
          );
        }
      });

      test('different types may have different icons', () {
        // Arrange
        const type1 = NetworkFailureType();
        const type2 = ApiFailureType();

        // Act
        final icon1 = type1.icon;
        final icon2 = type2.icon;

        // Assert
        expect(icon1, isNot(equals(icon2)));
      });

      test('same type always returns same icon', () {
        // Arrange
        const type = NetworkFailureType();

        // Act
        final icon1 = type.icon;
        final icon2 = type.icon;

        // Assert
        expect(icon1, equals(icon2));
      });
    });

    group('icon semantic meaning', () {
      test('network errors use network-related icons', () {
        // Arrange
        const networkTypes = [
          NetworkFailureType(),
          NetworkTimeoutFailureType(),
        ];

        // Act & Assert
        for (final type in networkTypes) {
          final icon = type.icon;
          expect(icon, isA<IconData>());
          // Network icons should be recognizable
          expect(
            [
              Icons.signal_wifi_connected_no_internet_4,
              Icons.schedule,
              Icons.wifi_off,
            ].contains(icon),
            isTrue,
            reason: '${type.runtimeType} should have network-related icon',
          );
        }
      });

      test('auth errors use auth-related icons', () {
        // Arrange
        const authTypes = [
          UnauthorizedFailureType(),
          InvalidCredentialFirebaseFailureType(),
        ];

        // Act & Assert
        for (final type in authTypes) {
          final icon = type.icon;
          expect(icon, isA<IconData>());
          // Auth icons should be recognizable
          expect(
            [Icons.lock, Icons.vpn_key_off, Icons.key_off].contains(icon),
            isTrue,
            reason: '${type.runtimeType} should have auth-related icon',
          );
        }
      });

      test('user-related errors use user icons', () {
        // Arrange
        const type = UserNotFoundFirebaseFailureType();

        // Act
        final icon = type.icon;

        // Assert
        expect(icon, equals(Icons.person_search));
      });
    });

    group('usage in UI', () {
      test('icon can be used in Icon widget', () {
        // Arrange
        const type = NetworkFailureType();
        final icon = type.icon;

        // Act
        final widget = Icon(icon);

        // Assert
        expect(widget, isA<Icon>());
        expect(widget.icon, equals(Icons.signal_wifi_connected_no_internet_4));
      });

      test('icon can be used in Failure to FailureUIEntity flow', () {
        // Arrange
        const failure = Failure(
          type: NetworkFailureType(),
          message: 'No connection',
        );

        // Act
        final icon = failure.type.icon;

        // Assert
        expect(icon, isA<IconData>());
        expect(icon, equals(Icons.signal_wifi_connected_no_internet_4));
      });

      test('all failure icons work with Icon widget', () {
        // Arrange
        final allTypes = [
          const NetworkFailureType(),
          const ApiFailureType(),
          const UnknownFailureType(),
          const GenericFirebaseFailureType(),
        ];

        // Act & Assert
        for (final type in allTypes) {
          final widget = Icon(type.icon);
          expect(widget, isA<Icon>());
          expect(widget.icon, equals(type.icon));
        }
      });
    });

    group('real-world scenarios', () {
      test('network offline shows appropriate icon', () {
        // Arrange
        const type = NetworkFailureType();

        // Assert
        expect(type.icon, equals(Icons.signal_wifi_connected_no_internet_4));
      });

      test('timeout shows clock icon', () {
        // Arrange
        const type = NetworkTimeoutFailureType();

        // Assert
        expect(type.icon, equals(Icons.schedule));
      });

      test('invalid credentials show key-off icon', () {
        // Arrange
        const type = InvalidCredentialFirebaseFailureType();

        // Assert
        expect(type.icon, equals(Icons.vpn_key_off));
      });

      test('unauthorized shows lock icon', () {
        // Arrange
        const type = UnauthorizedFailureType();

        // Assert
        expect(type.icon, equals(Icons.lock));
      });

      test('unknown error shows error outline', () {
        // Arrange
        const type = UnknownFailureType();

        // Assert
        expect(type.icon, equals(Icons.error_outline));
      });

      test('cache error shows storage icon', () {
        // Arrange
        const type = CacheFailureType();

        // Assert
        expect(type.icon, equals(Icons.sd_storage));
      });

      test('rate limit shows timer icon', () {
        // Arrange
        const type = TooManyRequestsFirebaseFailureType();

        // Assert
        expect(type.icon, equals(Icons.timer));
      });
    });
  });
}
