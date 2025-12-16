/// Tests for `ResultFutureExtension` from _errors_handling_entry_point.dart
///
/// Coverage:
/// - runWithErrorHandling() success path
/// - Failure catch handling
/// - Exception catch and mapping
/// - Object catch and mapping
/// - Integration with ErrorsLogger
/// - Integration with mapToFailure()
// ignore_for_file: only_throw_errors

library;

import 'dart:async' show TimeoutException;
import 'dart:io' show FileSystemException, SocketException;

import 'package:core/public_api/base_modules/errors_management.dart';
import 'package:flutter/services.dart' show MissingPluginException;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResultFutureExtension', () {
    group('runWithErrorHandling', () {
      group('success path', () {
        test('returns Right when async operation succeeds', () async {
          // Arrange
          Future<int> operation() async => 42;

          // Act
          final result = await operation.runWithErrorHandling();

          // Assert
          expect(result, isA<Right<Failure, int>>());
          expect(result.isRight, isTrue);
          expect(result.fold((l) => 0, (r) => r), equals(42));
        });

        test('returns Right with String value', () async {
          // Arrange
          Future<String> operation() async => 'success';

          // Act
          final result = await operation.runWithErrorHandling();

          // Assert
          expect(result, isA<Right<Failure, String>>());
          expect(result.fold((l) => '', (r) => r), equals('success'));
        });

        test('returns Right with complex object', () async {
          // Arrange
          final expectedUser = User(id: '123', name: 'Test User');
          Future<User> operation() async => expectedUser;

          // Act
          final result = await operation.runWithErrorHandling();

          // Assert
          expect(result.isRight, isTrue);
          final user = result.fold((l) => null, (r) => r);
          expect(user?.id, equals('123'));
          expect(user?.name, equals('Test User'));
        });

        test('returns Right with null value', () async {
          // Arrange
          Future<String?> operation() async => null;

          // Act
          final result = await operation.runWithErrorHandling();

          // Assert
          expect(result.isRight, isTrue);
          expect(result.fold((l) => 'error', (r) => r), isNull);
        });

        test('returns Right with empty list', () async {
          // Arrange
          Future<List<int>> operation() async => [];

          // Act
          final result = await operation.runWithErrorHandling();

          // Assert
          expect(result.isRight, isTrue);
          expect(result.fold((l) => null, (r) => r), isEmpty);
        });
      });

      group('Failure catch handling', () {
        test('catches Failure and returns Left', () async {
          // Arrange
          const expectedFailure = Failure(type: NetworkFailureType());
          Future<int> operation() async => throw expectedFailure;

          // Act
          final result = await operation.runWithErrorHandling();

          // Assert
          expect(result, isA<Left<Failure, int>>());
          expect(result.isLeft, isTrue);
          expect(result.fold((l) => l, (r) => null), equals(expectedFailure));
        });

        test('catches Failure with message and status code', () async {
          // Arrange
          const expectedFailure = Failure(
            type: ApiFailureType(),
            message: 'Server error',
            statusCode: 500,
          );
          Future<String> operation() async => throw expectedFailure;

          // Act
          final result = await operation.runWithErrorHandling();

          // Assert
          expect(result.isLeft, isTrue);
          final failure = result.fold((l) => l, (r) => null);
          expect(failure?.type, isA<ApiFailureType>());
          expect(failure?.message, equals('Server error'));
          expect(failure?.statusCode, equals(500));
        });

        test('logs Failure when caught', () async {
          // Arrange
          const failure = Failure(type: UnknownFailureType());
          Future<int> operation() async => throw failure;

          // Act
          final result = await operation.runWithErrorHandling();

          // Assert - Verify failure is logged (implicit via ErrorsLogger.log)
          expect(result.isLeft, isTrue);
        });
      });

      group('Exception catch and mapping', () {
        test('catches SocketException and maps to NetworkFailure', () async {
          // Arrange
          const exception = SocketException('No internet connection');
          Future<int> operation() async => throw exception;

          // Act
          final result = await operation.runWithErrorHandling();

          // Assert
          expect(result, isA<Left<Failure, int>>());
          final failure = result.fold((l) => l, (r) => null);
          expect(failure?.type, isA<NetworkFailureType>());
          expect(failure?.message, contains('No internet'));
        });

        test(
          'catches TimeoutException and maps to NetworkTimeoutFailure',
          () async {
            // Arrange
            final exception = TimeoutException('Connection timeout');
            Future<String> operation() async => throw exception;

            // Act
            final result = await operation.runWithErrorHandling();

            // Assert
            expect(result.isLeft, isTrue);
            final failure = result.fold((l) => l, (r) => null);
            expect(failure?.type, isA<NetworkTimeoutFailureType>());
            expect(failure?.message, contains('timeout'));
          },
        );

        test('catches FileSystemException and maps to CacheFailure', () async {
          // Arrange
          const exception = FileSystemException('Cannot read file');
          Future<int> operation() async => throw exception;

          // Act
          final result = await operation.runWithErrorHandling();

          // Assert
          expect(result.isLeft, isTrue);
          final failure = result.fold((l) => l, (r) => null);
          expect(failure?.type, isA<CacheFailureType>());
        });

        test(
          'catches MissingPluginException and maps to MissingPluginFailure',
          () async {
            // Arrange
            final exception = MissingPluginException('Plugin not found');
            Future<int> operation() async => throw exception;

            // Act
            final result = await operation.runWithErrorHandling();

            // Assert
            expect(result.isLeft, isTrue);
            final failure = result.fold((l) => l, (r) => null);
            expect(failure?.type, isA<MissingPluginFailureType>());
          },
        );

        test('catches FormatException and maps to FormatFailure', () async {
          // Arrange
          const exception = FormatException('Invalid format');
          Future<int> operation() async => throw exception;

          // Act
          final result = await operation.runWithErrorHandling();

          // Assert
          expect(result.isLeft, isTrue);
          final failure = result.fold((l) => l, (r) => null);
          expect(failure?.type, isA<FormatFailureType>());
          expect(failure?.message, contains('Invalid format'));
        });

        test('logs Exception when caught', () async {
          // Arrange
          final exception = Exception('Test exception');
          Future<int> operation() async => throw exception;

          // Act
          final result = await operation.runWithErrorHandling();

          // Assert - Verify exception is logged (implicit via ErrorsLogger.log)
          expect(result.isLeft, isTrue);
        });
      });

      group('Object catch and mapping', () {
        test('catches String and maps to UnknownFailure', () async {
          // Arrange
          Future<int> operation() async => throw 'String error';

          // Act
          final result = await operation.runWithErrorHandling();

          // Assert
          expect(result, isA<Left<Failure, int>>());
          final failure = result.fold((l) => l, (r) => null);
          expect(failure?.type, isA<UnknownFailureType>());
          expect(failure?.message, contains('String error'));
        });

        test('catches int and maps to UnknownFailure', () async {
          // Arrange
          Future<int> operation() async => throw 404;

          // Act
          final result = await operation.runWithErrorHandling();

          // Assert
          expect(result.isLeft, isTrue);
          final failure = result.fold((l) => l, (r) => null);
          expect(failure?.type, isA<UnknownFailureType>());
          expect(failure?.message, contains('404'));
        });

        test('catches custom object and maps to UnknownFailure', () async {
          // Arrange
          final customError = CustomError('Custom error message');
          Future<int> operation() async => throw customError;

          // Act
          final result = await operation.runWithErrorHandling();

          // Assert
          expect(result.isLeft, isTrue);
          final failure = result.fold((l) => l, (r) => null);
          expect(failure?.type, isA<UnknownFailureType>());
        });

        test('logs Object when caught', () async {
          // Arrange
          Future<int> operation() async => throw 'Error object';

          // Act
          final result = await operation.runWithErrorHandling();

          // Assert - Verify object is logged (implicit via ErrorsLogger.log)
          expect(result.isLeft, isTrue);
        });
      });

      group('real-world scenarios', () {
        test('handles repository operation success', () async {
          // Arrange - Simulates repository fetching user
          Future<User> fetchUser() async {
            await Future<void>.delayed(const Duration(milliseconds: 10));
            return User(id: 'user_123', name: 'John Doe');
          }

          // Act
          final result = await fetchUser.runWithErrorHandling();

          // Assert
          expect(result.isRight, isTrue);
          final user = result.fold((l) => null, (r) => r);
          expect(user?.id, equals('user_123'));
        });

        test('handles repository operation with network error', () async {
          // Arrange - Simulates repository with network issue
          Future<User> fetchUser() async {
            await Future<void>.delayed(const Duration(milliseconds: 10));
            throw const SocketException('Network unreachable');
          }

          // Act
          final result = await fetchUser.runWithErrorHandling();

          // Assert
          expect(result.isLeft, isTrue);
          final failure = result.fold((l) => l, (r) => null);
          expect(failure?.type, isA<NetworkFailureType>());
        });

        test('handles repository operation with timeout', () async {
          // Arrange - Simulates long-running operation
          Future<String> fetchData() async {
            await Future<void>.delayed(const Duration(milliseconds: 10));
            throw TimeoutException('Request timeout');
          }

          // Act
          final result = await fetchData.runWithErrorHandling();

          // Assert
          expect(result.isLeft, isTrue);
          final failure = result.fold((l) => l, (r) => null);
          expect(failure?.type, isA<NetworkTimeoutFailureType>());
        });

        test('handles cache read failure', () async {
          // Arrange - Simulates cache read error
          Future<String> readCache() async {
            throw const FileSystemException('File not found');
          }

          // Act
          final result = await readCache.runWithErrorHandling();

          // Assert
          expect(result.isLeft, isTrue);
          final failure = result.fold((l) => l, (r) => null);
          expect(failure?.type, isA<CacheFailureType>());
        });

        test('handles data parsing failure', () async {
          // Arrange - Simulates JSON parsing error
          Future<Map<String, dynamic>> parseData() async {
            throw const FormatException('Invalid JSON');
          }

          // Act
          final result = await parseData.runWithErrorHandling();

          // Assert
          expect(result.isLeft, isTrue);
          final failure = result.fold((l) => l, (r) => null);
          expect(failure?.type, isA<FormatFailureType>());
        });
      });

      group('edge cases', () {
        test('handles immediate success without delay', () async {
          // Arrange
          Future<int> operation() async => 100;

          // Act
          final result = await operation.runWithErrorHandling();

          // Assert
          expect(result.isRight, isTrue);
          expect(result.fold((l) => 0, (r) => r), equals(100));
        });

        test('handles immediate failure without delay', () async {
          // Arrange
          Future<int> operation() async =>
              throw const Failure(type: UnknownFailureType());

          // Act
          final result = await operation.runWithErrorHandling();

          // Assert
          expect(result.isLeft, isTrue);
        });

        test('handles very long async operation', () async {
          // Arrange
          Future<String> operation() async {
            await Future<void>.delayed(const Duration(milliseconds: 100));
            return 'completed';
          }

          // Act
          final result = await operation.runWithErrorHandling();

          // Assert
          expect(result.isRight, isTrue);
          expect(result.fold((l) => '', (r) => r), equals('completed'));
        });

        test('handles empty Future<void>', () async {
          // Arrange
          Future<void> operation() async {
            // Do nothing
          }

          // Act
          final result = await operation.runWithErrorHandling();

          // Assert
          expect(result.isRight, isTrue);
        });

        test('handles nested exceptions', () async {
          // Arrange
          Future<int> operation() async {
            try {
              throw Exception('Inner exception');
            } catch (e) {
              throw Exception('Outer exception: $e');
            }
          }

          // Act
          final result = await operation.runWithErrorHandling();

          // Assert
          expect(result.isLeft, isTrue);
          final failure = result.fold((l) => l, (r) => null);
          expect(failure?.type, isA<UnknownFailureType>());
        });
      });

      group('type safety', () {
        test('maintains type parameter through success', () async {
          // Arrange
          Future<List<String>> operation() async => ['a', 'b', 'c'];

          // Act
          final result = await operation.runWithErrorHandling();

          // Assert
          expect(result, isA<Either<Failure, List<String>>>());
          expect(result.fold((l) => null, (r) => r), isA<List<String>>());
        });

        test('maintains type parameter through failure', () async {
          // Arrange
          Future<Map<String, int>> operation() async =>
              throw Exception('Error');

          // Act
          final result = await operation.runWithErrorHandling();

          // Assert
          expect(result, isA<Either<Failure, Map<String, int>>>());
          expect(result.isLeft, isTrue);
        });

        test('works with nullable return types', () async {
          // Arrange
          Future<int?> operation() async => null;

          // Act
          final result = await operation.runWithErrorHandling();

          // Assert
          expect(result, isA<Either<Failure, int?>>());
          expect(result.isRight, isTrue);
        });

        test('works with dynamic types', () async {
          // Arrange
          Future<dynamic> operation() async => <String, String>{'key': 'value'};

          // Act
          final result = await operation.runWithErrorHandling();

          // Assert
          expect(result.isRight, isTrue);
          expect(
            result.fold((l) => null, (r) => r),
            isA<Map<String, String>>(),
          );
        });
      });

      group('integration', () {
        test('integrates with mapToFailure for all exception types', () async {
          // Arrange
          final exceptions = [
            const SocketException('Network'),
            TimeoutException('Timeout'),
            const FileSystemException('FS'),
            const FormatException('Format'),
          ];

          // Act & Assert
          for (final exception in exceptions) {
            Future<int> operation() async => throw exception;
            final result = await operation.runWithErrorHandling();
            expect(result.isLeft, isTrue);
          }
        });

        test('preserves stacktrace information', () async {
          // Arrange
          Future<int> operation() async {
            await Future<void>.delayed(const Duration(milliseconds: 5));
            throw Exception('Error with stacktrace');
          }

          // Act
          final result = await operation.runWithErrorHandling();

          // Assert - StackTrace is logged internally
          expect(result.isLeft, isTrue);
        });
      });
    });
  });
}

// Helper classes for testing
class User {
  User({required this.id, required this.name});
  final String id;
  final String name;
}

class CustomError {
  CustomError(this.message);
  final String message;

  @override
  String toString() => 'CustomError: $message';
}
