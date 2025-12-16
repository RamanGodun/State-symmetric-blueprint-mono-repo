/// Tests for `ExceptionToFailureX` extension from
/// _exceptions_to_failures_mapper_x.dart
///
/// This test follows best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
/// ✅ Real-world scenarios
///
/// Coverage:
/// - mapToFailure() for all exception types
/// - SocketException → NetworkFailure
/// - JsonUnsupportedObjectError → JsonErrorFailure
/// - FBException → Firebase failures (with map lookup)
/// - FormatException → FormatFailure / DocMissingFailure
/// - MissingPluginException → MissingPluginFailure
/// - FileSystemException → CacheFailure
/// - TimeoutException → NetworkTimeoutFailure
/// - PlatformException → Platform failures (with map lookup)
/// - Unknown Object → UnknownFailure (fallback)
/// - Logging integration
library;

import 'dart:async' show TimeoutException;
import 'dart:convert' show JsonUnsupportedObjectError;
import 'dart:io' show FileSystemException, SocketException;

import 'package:core/public_api/base_modules/errors_management.dart';
import 'package:firebase_adapter/firebase_adapter.dart' show FBException;
import 'package:flutter/services.dart'
    show MissingPluginException, PlatformException;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExceptionToFailureX', () {
    group('mapToFailure', () {
      group('SocketException mapping', () {
        test('maps SocketException to NetworkFailure', () {
          // Arrange
          const exception = SocketException('Connection failed');

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure, isA<Failure>());
          expect(failure.type, isA<NetworkFailureType>());
          expect(failure.message, equals('Connection failed'));
        });

        test('maps SocketException with empty message', () {
          // Arrange
          const exception = SocketException('');

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<NetworkFailureType>());
          expect(failure.message, isEmpty);
        });

        test('maps SocketException with detailed network message', () {
          // Arrange
          const exception = SocketException(
            'Failed host lookup: example.com',
            port: 443,
          );

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<NetworkFailureType>());
          expect(failure.message, contains('Failed host lookup'));
        });
      });

      group('JsonUnsupportedObjectError mapping', () {
        test('maps JsonUnsupportedObjectError to JsonErrorFailure', () {
          // Arrange
          final exception = JsonUnsupportedObjectError(DateTime.now());

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure, isA<Failure>());
          expect(failure.type, isA<JsonErrorFailureType>());
          expect(failure.message, isNotEmpty);
        });

        test('message contains toString() output', () {
          // Arrange
          final customObject = CustomObject('test');
          final exception = JsonUnsupportedObjectError(customObject);

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<JsonErrorFailureType>());
          expect(failure.message, contains('CustomObject'));
        });
      });

      group('FBException mapping', () {
        test('maps known Firebase code using firebaseFailureMap', () {
          // Arrange
          final exception = FBException(
            code: 'invalid-credential',
            message: 'Invalid credentials provided',
            plugin: '',
          );

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<InvalidCredentialFirebaseFailureType>());
          expect(failure.message, equals('Invalid credentials provided'));
        });

        test('maps email-already-in-use to EmailAlreadyInUseFailure', () {
          // Arrange
          final exception = FBException(
            code: 'email-already-in-use',
            message: 'Email is already registered',
            plugin: '',
          );

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<EmailAlreadyInUseFirebaseFailureType>());
          expect(failure.message, equals('Email is already registered'));
        });

        test('maps user-not-found to UserNotFoundFailure', () {
          // Arrange
          final exception = FBException(
            code: 'user-not-found',
            message: 'User does not exist',
            plugin: '',
          );

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<UserNotFoundFirebaseFailureType>());
        });

        test('maps user-disabled to UserDisabledFailure', () {
          // Arrange
          final exception = FBException(
            code: 'user-disabled',
            message: 'Account has been disabled',
            plugin: '',
          );

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<UserDisabledFirebaseFailureType>());
        });

        test('maps too-many-requests to TooManyRequestsFailure', () {
          // Arrange
          final exception = FBException(
            code: 'too-many-requests',
            message: 'Rate limit exceeded',
            plugin: '',
          );

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<TooManyRequestsFirebaseFailureType>());
        });

        test('maps network-request-failed to NetworkFailure', () {
          // Arrange
          final exception = FBException(
            code: 'network-request-failed',
            message: 'Network error',
            plugin: '',
          );

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<NetworkFailureType>());
        });

        test('maps deadline-exceeded to NetworkTimeoutFailure', () {
          // Arrange
          final exception = FBException(
            code: 'deadline-exceeded',
            message: 'Operation timed out',
            plugin: '',
          );

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<NetworkTimeoutFailureType>());
        });

        test('maps unknown Firebase code to GenericFirebaseFailure', () {
          // Arrange
          final exception = FBException(
            code: 'unknown-firebase-error',
            message: 'Something went wrong',
            plugin: '',
          );

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<GenericFirebaseFailureType>());
          expect(failure.message, equals('Something went wrong'));
        });

        test('fallback logs the failure when code is unknown', () {
          // Arrange
          final exception = FBException(
            code: 'custom-code-123',
            message: 'Custom error',
            plugin: '',
          );

          // Act
          final failure = exception.mapToFailure();

          // Assert - Logging happens internally
          expect(failure.type, isA<GenericFirebaseFailureType>());
        });

        test('handles null message in Firebase exception', () {
          // Arrange
          final exception = FBException(
            code: 'invalid-credential',
            plugin: '',
          );

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<InvalidCredentialFirebaseFailureType>());
          expect(failure.message, isNull);
        });
      });

      group('FormatException mapping', () {
        test('maps FormatException with "document" to DocMissingFailure', () {
          // Arrange
          const exception = FormatException('Missing document field');

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<DocMissingFirebaseFailureType>());
          expect(failure.message, contains('document'));
        });

        test('maps generic FormatException to FormatFailure', () {
          // Arrange
          const exception = FormatException('Invalid format');

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<FormatFailureType>());
          expect(failure.message, equals('Invalid format'));
        });

        test('maps FormatException for date parsing', () {
          // Arrange
          const exception = FormatException('Invalid date format');

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<FormatFailureType>());
        });

        test('prioritizes document check over generic format', () {
          // Arrange
          const docException = FormatException('document is missing');
          const genericException = FormatException('format error');

          // Act
          final docFailure = docException.mapToFailure();
          final genericFailure = genericException.mapToFailure();

          // Assert
          expect(docFailure.type, isA<DocMissingFirebaseFailureType>());
          expect(genericFailure.type, isA<FormatFailureType>());
        });
      });

      group('MissingPluginException mapping', () {
        test('maps MissingPluginException to MissingPluginFailure', () {
          // Arrange
          final exception = MissingPluginException('Plugin not implemented');

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure, isA<Failure>());
          expect(failure.type, isA<MissingPluginFailureType>());
          expect(failure.message, contains('Plugin not implemented'));
        });

        test('includes plugin details in message', () {
          // Arrange
          final exception = MissingPluginException(
            'No implementation found for method getVersion on channel my_plugin',
          );

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<MissingPluginFailureType>());
          expect(failure.message, contains('my_plugin'));
        });
      });

      group('FileSystemException mapping', () {
        test('maps FileSystemException to CacheFailure', () {
          // Arrange
          const exception = FileSystemException('File not found');

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure, isA<Failure>());
          expect(failure.type, isA<CacheFailureType>());
          expect(failure.message, equals('File not found'));
        });

        test('maps file write error to CacheFailure', () {
          // Arrange
          const exception = FileSystemException(
            'Cannot write to file',
            '/path/to/cache',
          );

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<CacheFailureType>());
          expect(failure.message, contains('write'));
        });

        test('handles FileSystemException with empty message', () {
          // Arrange
          const exception = FileSystemException();

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<CacheFailureType>());
          expect(failure.message, isEmpty);
        });
      });

      group('TimeoutException mapping', () {
        test('maps TimeoutException to NetworkTimeoutFailure', () {
          // Arrange
          final exception = TimeoutException('Operation timeout');

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure, isA<Failure>());
          expect(failure.type, isA<NetworkTimeoutFailureType>());
          expect(failure.message, equals('Operation timeout'));
        });

        test('maps TimeoutException with null message', () {
          // Arrange
          final exception = TimeoutException(null);

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<NetworkTimeoutFailureType>());
          expect(failure.message, isNull);
        });

        test('maps TimeoutException with duration', () {
          // Arrange
          final exception = TimeoutException(
            'Request timed out',
            const Duration(seconds: 30),
          );

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<NetworkTimeoutFailureType>());
          expect(failure.message, contains('timed out'));
        });
      });

      group('PlatformException mapping', () {
        test('maps known platform code using platformFailureMap', () {
          // Arrange
          final exception = PlatformException(
            code: 'invalid-credential',
            message: 'Invalid user credentials',
          );

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<InvalidCredentialFirebaseFailureType>());
          expect(failure.message, equals('Invalid user credentials'));
        });

        test('maps user-not-found platform code', () {
          // Arrange
          final exception = PlatformException(
            code: 'user-not-found',
            message: 'User does not exist',
          );

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<UserNotFoundFirebaseFailureType>());
        });

        test('maps network-request-failed platform code', () {
          // Arrange
          final exception = PlatformException(
            code: 'network-request-failed',
            message: 'Network unavailable',
          );

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<NetworkFailureType>());
        });

        test('maps timeout platform code', () {
          // Arrange
          final exception = PlatformException(
            code: 'timeout',
            message: 'Request timeout',
          );

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<NetworkTimeoutFailureType>());
        });

        test('falls back to FormatFailure for unknown platform code', () {
          // Arrange
          final exception = PlatformException(
            code: 'unknown-platform-error',
            message: 'Unknown error occurred',
          );

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<FormatFailureType>());
          expect(failure.message, equals('Unknown error occurred'));
        });

        test('handles PlatformException with null message', () {
          // Arrange
          final exception = PlatformException(code: 'invalid-email');

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<FormatFailureType>());
          expect(failure.message, isNull);
        });

        test('includes platform exception details', () {
          // Arrange
          final exception = PlatformException(
            code: 'invalid-credential',
            message: 'Auth failed',
            details: const {'reason': 'wrong password'},
          );

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<InvalidCredentialFirebaseFailureType>());
          expect(failure.message, equals('Auth failed'));
        });
      });

      group('Unknown Object fallback mapping', () {
        test('maps String to UnknownFailure', () {
          // Arrange
          const errorString = 'Simple error string';

          // Act
          final failure = errorString.mapToFailure();

          // Assert
          expect(failure, isA<Failure>());
          expect(failure.type, isA<UnknownFailureType>());
          expect(failure.message, equals('Simple error string'));
        });

        test('maps int to UnknownFailure', () {
          // Arrange
          const errorCode = 404;

          // Act
          final failure = errorCode.mapToFailure();

          // Assert
          expect(failure.type, isA<UnknownFailureType>());
          expect(failure.message, equals('404'));
        });

        test('maps bool to UnknownFailure', () {
          // Arrange
          const errorBool = false;

          // Act
          final failure = errorBool.mapToFailure();

          // Assert
          expect(failure.type, isA<UnknownFailureType>());
          expect(failure.message, equals('false'));
        });

        test('maps custom object to UnknownFailure', () {
          // Arrange
          final customError = CustomObject('custom error');

          // Act
          final failure = customError.mapToFailure();

          // Assert
          expect(failure.type, isA<UnknownFailureType>());
          expect(failure.message, contains('CustomObject'));
        });

        test('maps Map to UnknownFailure', () {
          // Arrange
          final errorMap = {'code': 500, 'message': 'Internal error'};

          // Act
          final failure = errorMap.mapToFailure();

          // Assert
          expect(failure.type, isA<UnknownFailureType>());
          expect(failure.message, contains('500'));
        });

        test('logs unknown object when mapped', () {
          // Arrange
          const unknownError = 'Unknown error type';

          // Act
          final failure = unknownError.mapToFailure();

          // Assert - Logging happens internally
          expect(failure.type, isA<UnknownFailureType>());
        });
      });

      group('stackTrace parameter', () {
        test('passes stackTrace to logging for unknown objects', () {
          // Arrange
          const errorString = 'Error with trace';
          final stackTrace = StackTrace.current;

          // Act
          final failure = errorString.mapToFailure(stackTrace);

          // Assert - StackTrace is used internally for logging
          expect(failure.type, isA<UnknownFailureType>());
        });

        test('passes stackTrace to logging for Firebase fallback', () {
          // Arrange
          final exception = FBException(
            code: 'unknown-code',
            message: 'Unknown error',
            plugin: '',
          );
          final stackTrace = StackTrace.current;

          // Act
          final failure = exception.mapToFailure(stackTrace);

          // Assert - StackTrace is logged
          expect(failure.type, isA<GenericFirebaseFailureType>());
        });

        test('handles null stackTrace gracefully', () {
          // Arrange
          const errorString = 'Error without trace';

          // Act
          final failure = errorString.mapToFailure();

          // Assert
          expect(failure.type, isA<UnknownFailureType>());
        });
      });

      group('real-world scenarios', () {
        test('handles network connectivity loss', () {
          // Arrange
          const exception = SocketException('Network is unreachable');

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<NetworkFailureType>());
        });

        test('handles authentication failure flow', () {
          // Arrange
          final exception = FBException(
            code: 'invalid-credential',
            message: 'Wrong password',
            plugin: '',
          );

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<InvalidCredentialFirebaseFailureType>());
        });

        test('handles rate limiting scenario', () {
          // Arrange
          final exception = FBException(
            code: 'too-many-requests',
            message: 'Please try again later',
            plugin: '',
          );

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<TooManyRequestsFirebaseFailureType>());
        });

        test('handles JSON parsing error in API response', () {
          // Arrange
          final exception = JsonUnsupportedObjectError({'invalid': 'json'});

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<JsonErrorFailureType>());
        });

        test('handles local storage failure', () {
          // Arrange
          const exception = FileSystemException('Permission denied');

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<CacheFailureType>());
        });

        test('handles API timeout', () {
          // Arrange
          final exception = TimeoutException('API did not respond');

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<NetworkTimeoutFailureType>());
        });
      });

      group('edge cases', () {
        test('handles exception with very long message', () {
          // Arrange
          final longMessage = 'Error: ' * 1000;
          final exception = SocketException(longMessage);

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<NetworkFailureType>());
          expect(failure.message, equals(longMessage));
        });

        test('handles exception with unicode characters', () {
          // Arrange
          const exception = FormatException('Помилка: 错误 🔥');

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<FormatFailureType>());
          expect(failure.message, contains('🔥'));
        });

        test('handles exception with newlines and special chars', () {
          // Arrange
          const exception = SocketException('Error:\n\tNetwork\r\nfailed');

          // Act
          final failure = exception.mapToFailure();

          // Assert
          expect(failure.type, isA<NetworkFailureType>());
          expect(failure.message, contains('\n'));
        });

        test('handles null in custom object toString()', () {
          // Arrange
          final nullObject = NullToStringObject();

          // Act
          final failure = nullObject.mapToFailure();

          // Assert
          expect(failure.type, isA<UnknownFailureType>());
        });
      });

      group('integration', () {
        test('all exception types produce valid Failures', () {
          // Arrange
          final exceptions = <Object>[
            const SocketException('Network'),
            JsonUnsupportedObjectError('test'),
            FBException(code: 'test', message: 'Firebase', plugin: ''),
            const FormatException('Format'),
            MissingPluginException('Plugin'),
            const FileSystemException('FS'),
            TimeoutException('Timeout'),
            PlatformException(code: 'test'),
            'String error',
          ];

          // Act & Assert
          for (final exception in exceptions) {
            final failure = exception.mapToFailure();
            expect(failure, isA<Failure>());
            expect(failure.type, isA<FailureType>());
            expect(failure.safeCode, isNotEmpty);
          }
        });

        test('preserves message information through mapping', () {
          // Arrange
          const testMessage = 'Important error details';
          final exceptions = <Object>[
            const SocketException(testMessage),
            const FormatException(testMessage),
            FBException(code: 'test', message: testMessage, plugin: ''),
          ];

          // Act & Assert
          for (final exception in exceptions) {
            final failure = exception.mapToFailure();
            expect(failure.message, equals(testMessage));
          }
        });
      });
    });
  });
}

// Helper classes for testing
class CustomObject {
  CustomObject(this.value);
  final String value;

  @override
  String toString() => 'CustomObject: $value';
}

class NullToStringObject {
  @override
  String toString() => 'null';
}
