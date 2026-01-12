/// Tests for ProfileCubit
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ BLoC testing with bloc_test
///
/// Coverage:
/// - Initial state
/// - Prime profile fetch
/// - Refresh profile fetch
/// - Success and error states
/// - State reset functionality
library;

import 'dart:async';

import 'package:adapters_for_bloc/adapters_for_bloc.dart';
import 'package:app_on_cubit/features/profile/cubit/profile_page_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:features_dd_layers/public_api/profile/profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';
import 'package:shared_layers/public_api/domain_layer_shared.dart';

class MockProfileRepo extends Mock implements IProfileRepo {}

void main() {
  group('ProfileCubit', () {
    late MockProfileRepo mockRepo;
    late FetchProfileUseCase fetchProfileUseCase;

    setUp(() {
      mockRepo = MockProfileRepo();
      fetchProfileUseCase = FetchProfileUseCase(mockRepo);
    });

    test('initial state is loading', () {
      // Arrange & Act
      final cubit = ProfileCubit(fetchProfileUseCase);

      // Assert
      expect(cubit.state, isA<AsyncValueForBLoC<UserEntity>>());
      expect(cubit.state.isLoading, isTrue);

      cubit.close();
    });

    group('prime', () {
      blocTest<ProfileCubit, AsyncValueForBLoC<UserEntity>>(
        'emits data state when profile fetch succeeds',
        build: () {
          const userEntity = UserEntity(
            email: 'test@example.com',
            id: 'test-user-id',
            name: '',
            profileImage: '',
            point: 1,
            rank: '',
          );
          when(
            () => mockRepo.getProfile(uid: any(named: 'uid')),
          ).thenAnswer((_) async => const Right(userEntity));
          return ProfileCubit(fetchProfileUseCase);
        },
        act: (cubit) => cubit.prime('test-user-id'),
        wait: const Duration(milliseconds: 100),
        skip: 1,
        expect: () => [
          isA<AsyncValueForBLoC<UserEntity>>().having(
            (state) => state.hasValue,
            'has value',
            true,
          ),
        ],
        verify: (_) {
          verify(() => mockRepo.getProfile(uid: 'test-user-id')).called(1);
        },
      );

      blocTest<ProfileCubit, AsyncValueForBLoC<UserEntity>>(
        'emits error state when profile fetch fails',
        build: () {
          const failure = Failure(
            type: NetworkFailureType(),
            message: 'Profile fetch failed',
          );
          when(
            () => mockRepo.getProfile(uid: any(named: 'uid')),
          ).thenAnswer((_) async => const Left(failure));
          when(
            () => mockRepo.createUserProfile(any()),
          ).thenAnswer((_) async => const Right(null));
          return ProfileCubit(fetchProfileUseCase);
        },
        act: (cubit) => cubit.prime('test-user-id'),
        wait: const Duration(milliseconds: 100),
        skip: 1,
        expect: () => [
          isA<AsyncValueForBLoC<UserEntity>>().having(
            (state) => state.hasError,
            'has error',
            true,
          ),
        ],
      );

      blocTest<ProfileCubit, AsyncValueForBLoC<UserEntity>>(
        'creates profile if not found and fetches again',
        build: () {
          const userEntity = UserEntity(
            id: 'test-user-id',
            email: 'test@example.com',
            name: 'Test User',
            profileImage: '',
            point: 0,
            rank: '',
          );
          const notFoundFailure = Failure(
            type: ApiFailureType(),
            message: 'User not found',
            statusCode: 404,
          );
          var callCount = 0;
          when(() => mockRepo.getProfile(uid: any(named: 'uid'))).thenAnswer((
            _,
          ) async {
            callCount++;
            if (callCount == 1) {
              return const Left(notFoundFailure);
            }
            return const Right(userEntity);
          });
          when(
            () => mockRepo.createUserProfile(any()),
          ).thenAnswer((_) async => const Right(null));
          return ProfileCubit(fetchProfileUseCase);
        },
        act: (cubit) => cubit.prime('test-user-id'),
        wait: const Duration(milliseconds: 100),
        skip: 1,
        expect: () => [
          isA<AsyncValueForBLoC<UserEntity>>().having(
            (state) => state.hasValue,
            'has value',
            true,
          ),
        ],
        verify: (_) {
          verify(() => mockRepo.getProfile(uid: 'test-user-id')).called(2);
          verify(() => mockRepo.createUserProfile('test-user-id')).called(1);
        },
      );
    });

    group('refresh', () {
      blocTest<ProfileCubit, AsyncValueForBLoC<UserEntity>>(
        'refreshes profile and preserves UI state',
        build: () {
          const userEntity = UserEntity(
            id: 'test-user-id',
            email: 'test@example.com',
            name: 'Test User',
            profileImage: '',
            point: 0,
            rank: '',
          );
          when(
            () => mockRepo.getProfile(uid: any(named: 'uid')),
          ).thenAnswer((_) async => const Right(userEntity));
          return ProfileCubit(fetchProfileUseCase);
        },
        act: (cubit) async {
          await cubit.prime('test-user-id');
          await Future<void>.delayed(const Duration(milliseconds: 100));
          unawaited(cubit.refresh('test-user-id'));
        },
        wait: const Duration(milliseconds: 200),
        verify: (_) {
          verify(() => mockRepo.getProfile(uid: 'test-user-id')).called(2);
        },
      );
    });

    group('resetState', () {
      blocTest<ProfileCubit, AsyncValueForBLoC<UserEntity>>(
        'resets state to loading',
        build: () {
          const userEntity = UserEntity(
            id: 'test-user-id',
            email: 'test@example.com',
            name: 'Test User',
            profileImage: '',
            point: 0,
            rank: '',
          );
          when(
            () => mockRepo.getProfile(uid: any(named: 'uid')),
          ).thenAnswer((_) async => const Right(userEntity));
          return ProfileCubit(fetchProfileUseCase);
        },
        act: (cubit) async {
          await cubit.prime('test-user-id');
          await Future<void>.delayed(const Duration(milliseconds: 100));
          cubit.resetState();
        },
        wait: const Duration(milliseconds: 100),
        skip: 1,
        expect: () => [
          isA<AsyncValueForBLoC<UserEntity>>().having(
            (state) => state.hasValue,
            'has value',
            true,
          ),
          isA<AsyncValueForBLoC<UserEntity>>().having(
            (state) => state.isLoading,
            'is loading',
            true,
          ),
        ],
      );
    });

    group('close', () {
      test('closes successfully', () async {
        // Arrange
        final cubit = ProfileCubit(fetchProfileUseCase);

        // Act
        await cubit.close();

        // Assert
        expect(cubit.isClosed, isTrue);
      });
    });
  });
}
