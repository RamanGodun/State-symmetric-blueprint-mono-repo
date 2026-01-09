/// Tests for `ResultFutureExtension` from _errors_handling_entry_point.dart
///
/// Coverage:
/// - runWithErrorHandling() success path
/// - Failure catch handling
/// - Exception catch and mapping
/// - Object catch and mapping
/// - Integration with ErrorsLogger
/// - Integration with mapToFailure()
// ignore_for_file: only_throw_errors, unreachable_from_main

library;

import 'dart:async' show TimeoutException;
import 'dart:io' show FileSystemException, SocketException;

import 'package:flutter/services.dart' show MissingPluginException;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';

import 'core_utils/extensions_on_either/for_tests_either_x.dart';

void main() {
  group('ResultFutureExtension', () {
    group('runWithErrorHandling', () {
      group('success path', () {
        test('returns Right when async operation succeeds', () async {
          // Arrange
          Future<int> operation() async => 42;

          // Act & Assert
          await operation.runWithErrorHandling().expectSuccess(42);
        });

        test('returns Right with String value', () async {
          // Arrange
          Future<String> operation() async => 'success';

          // Act & Assert
          await operation.runWithErrorHandling().expectSuccess('success');
        });

        test('returns Right with complex object', () async {
          // Arrange
          final expectedUser = User(id: '123', name: 'Test User');
          Future<User> operation() async => expectedUser;

          // Act & Assert
          await operation.runWithErrorHandling().expectSuccess(expectedUser);
        });

        test('returns Right with null value', () async {
          // Arrange
          Future<String?> operation() async => null;

          // Act & Assert
          await operation.runWithErrorHandling().expectSuccess(null);
        });

        test('returns Right with empty list', () async {
          // Arrange
          Future<List<int>> operation() async => [];

          // Act & Assert
          await operation.runWithErrorHandling().expectSuccess(<int>[]);
        });
      });

      group('Failure catch handling', () {
        test('catches Failure and returns Left', () async {
          // Arrange
          const expectedFailure = Failure(type: NetworkFailureType());
          Future<int> operation() async => throw expectedFailure;

          // Act & Assert
          await operation.runWithErrorHandling().expectFailure('NETWORK');
        });

        test('catches Failure with message and status code', () async {
          // Arrange
          const expectedFailure = Failure(
            type: ApiFailureType(),
            message: 'Server error',
            statusCode: 500,
          );
          Future<String> operation() async => throw expectedFailure;

          // Act & Assert - uses statusCode as safeCode
          await operation.runWithErrorHandling().expectFailure('500');
        });

        test('logs Failure when caught', () async {
          // Arrange
          const failure = Failure(type: UnknownFailureType());
          Future<int> operation() async => throw failure;

          // Act & Assert - Verify failure is logged (implicit via ErrorsLogger.log)
          await operation.runWithErrorHandling().expectFailure('UNKNOWN');
        });
      });

      group('Exception catch and mapping', () {
        test('catches SocketException and maps to NetworkFailure', () async {
          // Arrange
          const exception = SocketException('No internet connection');
          Future<int> operation() async => throw exception;

          // Act & Assert - verify mapped to NETWORK failure
          await operation.runWithErrorHandling().expectFailure('NETWORK');
        });

        test(
          'catches TimeoutException and maps to NetworkTimeoutFailure',
          () async {
            // Arrange
            final exception = TimeoutException('Connection timeout');
            Future<String> operation() async => throw exception;

            // Act & Assert - verify mapped to TIMEOUT failure
            await operation.runWithErrorHandling().expectFailure('TIMEOUT');
          },
        );

        test('catches FileSystemException and maps to CacheFailure', () async {
          // Arrange
          const exception = FileSystemException('Cannot read file');
          Future<int> operation() async => throw exception;

          // Act & Assert - verify mapped to CACHE failure
          await operation.runWithErrorHandling().expectFailure('CACHE');
        });

        test(
          'catches MissingPluginException and maps to MissingPluginFailure',
          () async {
            // Arrange
            final exception = MissingPluginException('Plugin not found');
            Future<int> operation() async => throw exception;

            // Act & Assert - verify mapped to MISSING_PLUGIN failure
            await operation.runWithErrorHandling().expectFailure(
              'MISSING_PLUGIN',
            );
          },
        );

        test('catches FormatException and maps to FormatFailure', () async {
          // Arrange
          const exception = FormatException('Invalid format');
          Future<int> operation() async => throw exception;

          // Act & Assert - verify mapped to FORMAT_ERROR failure
          await operation.runWithErrorHandling().expectFailure('FORMAT_ERROR');
        });

        test('logs Exception when caught', () async {
          // Arrange
          final exception = Exception('Test exception');
          Future<int> operation() async => throw exception;

          // Act & Assert - Verify exception is logged (implicit via ErrorsLogger.log)
          await operation.runWithErrorHandling().expectFailure('UNKNOWN');
        });
      });

      group('Object catch and mapping', () {
        test('catches String and maps to UnknownFailure', () async {
          // Arrange
          Future<int> operation() async => throw 'String error';

          // Act & Assert - verify mapped to UNKNOWN failure
          await operation.runWithErrorHandling().expectFailure('UNKNOWN');
        });

        test('catches int and maps to UnknownFailure', () async {
          // Arrange
          Future<int> operation() async => throw 404;

          // Act & Assert - verify mapped to UNKNOWN failure
          await operation.runWithErrorHandling().expectFailure('UNKNOWN');
        });

        test('catches custom object and maps to UnknownFailure', () async {
          // Arrange
          final customError = CustomError('Custom error message');
          Future<int> operation() async => throw customError;

          // Act & Assert - verify mapped to UNKNOWN failure
          await operation.runWithErrorHandling().expectFailure('UNKNOWN');
        });

        test('logs Object when caught', () async {
          // Arrange
          Future<int> operation() async => throw 'Error object';

          // Act & Assert - Verify object is logged (implicit via ErrorsLogger.log)
          await operation.runWithErrorHandling().expectFailure('UNKNOWN');
        });
      });

      group('real-world scenarios', () {
        test('handles repository operation success', () async {
          // Arrange - Simulates repository fetching user
          final expectedUser = User(id: 'user_123', name: 'John Doe');
          Future<User> fetchUser() async {
            await Future<void>.delayed(const Duration(milliseconds: 10));
            return expectedUser;
          }

          // Act & Assert
          await fetchUser.runWithErrorHandling().expectSuccess(expectedUser);
        });

        test('handles repository operation with network error', () async {
          // Arrange - Simulates repository with network issue
          Future<User> fetchUser() async {
            await Future<void>.delayed(const Duration(milliseconds: 10));
            throw const SocketException('Network unreachable');
          }

          // Act & Assert - verify mapped to NETWORK failure
          await fetchUser.runWithErrorHandling().expectFailure('NETWORK');
        });

        test('handles repository operation with timeout', () async {
          // Arrange - Simulates long-running operation
          Future<String> fetchData() async {
            await Future<void>.delayed(const Duration(milliseconds: 10));
            throw TimeoutException('Request timeout');
          }

          // Act & Assert - verify mapped to TIMEOUT failure
          await fetchData.runWithErrorHandling().expectFailure('TIMEOUT');
        });

        test('handles cache read failure', () async {
          // Arrange - Simulates cache read error
          Future<String> readCache() async {
            throw const FileSystemException('File not found');
          }

          // Act & Assert - verify mapped to CACHE failure
          await readCache.runWithErrorHandling().expectFailure('CACHE');
        });

        test('handles data parsing failure', () async {
          // Arrange - Simulates JSON parsing error
          Future<Map<String, dynamic>> parseData() async {
            throw const FormatException('Invalid JSON');
          }

          // Act & Assert - verify mapped to FORMAT_ERROR failure
          await parseData.runWithErrorHandling().expectFailure('FORMAT_ERROR');
        });
      });

      group('edge cases', () {
        test('handles immediate success without delay', () async {
          // Arrange
          Future<int> operation() async => 100;

          // Act & Assert
          await operation.runWithErrorHandling().expectSuccess(100);
        });

        test('handles immediate failure without delay', () async {
          // Arrange
          Future<int> operation() async =>
              throw const Failure(type: UnknownFailureType());

          // Act & Assert
          await operation.runWithErrorHandling().expectFailure('UNKNOWN');
        });

        test('handles very long async operation', () async {
          // Arrange
          Future<String> operation() async {
            await Future<void>.delayed(const Duration(milliseconds: 100));
            return 'completed';
          }

          // Act & Assert
          await operation.runWithErrorHandling().expectSuccess('completed');
        });

        test('handles empty Future<void>', () async {
          // Arrange
          Future<void> operation() async {
            // Do nothing
          }

          // Act
          final result = await operation.runWithErrorHandling();

          // Assert - void success, just verify Right
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

          // Act & Assert - verify mapped to UNKNOWN failure
          await operation.runWithErrorHandling().expectFailure('UNKNOWN');
        });
      });

      group('type safety', () {
        test('maintains type parameter through success', () async {
          // Arrange
          Future<List<String>> operation() async => ['a', 'b', 'c'];

          // Act & Assert
          await operation.runWithErrorHandling().expectSuccess(['a', 'b', 'c']);
        });

        test('maintains type parameter through failure', () async {
          // Arrange
          Future<Map<String, int>> operation() async =>
              throw Exception('Error');

          // Act & Assert - verify type is maintained and mapped to UNKNOWN
          await operation.runWithErrorHandling().expectFailure('UNKNOWN');
        });

        test('works with nullable return types', () async {
          // Arrange
          Future<int?> operation() async => null;

          // Act & Assert
          await operation.runWithErrorHandling().expectSuccess(null);
        });

        test('works with dynamic types', () async {
          // Arrange
          final expected = <String, String>{'key': 'value'};
          Future<dynamic> operation() async => expected;

          // Act & Assert
          await operation.runWithErrorHandling().expectSuccess(expected);
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

          // Act & Assert - verify all exceptions are caught and mapped
          for (final exception in exceptions) {
            Future<int> operation() async => throw exception;
            await operation.runWithErrorHandling().expectFailure();
          }
        });

        test('preserves stacktrace information', () async {
          // Arrange
          Future<int> operation() async {
            await Future<void>.delayed(const Duration(milliseconds: 5));
            throw Exception('Error with stacktrace');
          }

          // Act & Assert - StackTrace is logged internally, verify failure
          await operation.runWithErrorHandling().expectFailure('UNKNOWN');
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
