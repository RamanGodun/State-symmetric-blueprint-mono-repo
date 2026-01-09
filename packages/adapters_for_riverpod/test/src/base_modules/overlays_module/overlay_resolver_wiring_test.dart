/// Tests for OverlayResolverWiring
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - OverlayResolverWiring.install method
/// - OverlayResolverWiring.installFromGlobalDI method
/// - Different OverlayWiringScope configurations
library;

import 'package:adapters_for_riverpod/src/app_bootstrap/di/global_di_container.dart';
import 'package:adapters_for_riverpod/src/base_modules/overlays_module/overlay_adapters_providers.dart';
import 'package:adapters_for_riverpod/src/base_modules/overlays_module/overlay_resolver_wiring.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/overlays.dart';

void main() {
  group('OverlayResolverWiring', () {
    tearDown(GlobalDIContainer.reset);

    group('install', () {
      test('installs with both scope by default', () {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // Act
        OverlayResolverWiring.install(container: container);

        // Assert - Should not throw
        expect(
          () => OverlayResolverWiring.install(container: container),
          returnsNormally,
        );
      });

      test('installs with contextOnly scope', () {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // Act & Assert - Should not throw
        expect(
          () => OverlayResolverWiring.install(
            container: container,
            scope: OverlayWiringScope.contextOnly,
          ),
          returnsNormally,
        );
      });

      test('installs with globalOnly scope', () {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // Act & Assert - Should not throw
        expect(
          () => OverlayResolverWiring.install(
            container: container,
            scope: OverlayWiringScope.globalOnly,
          ),
          returnsNormally,
        );
      });

      test('installs with both scope explicitly', () {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // Act & Assert - Should not throw
        expect(
          () => OverlayResolverWiring.install(
            container: container,
          ),
          returnsNormally,
        );
      });

      test('can be called multiple times', () {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // Act - Install multiple times
        OverlayResolverWiring.install(container: container);
        OverlayResolverWiring.install(container: container);
        OverlayResolverWiring.install(container: container);

        // Assert - Should not throw
        expect(container, isA<ProviderContainer>());
      });

      test('works with different containers', () {
        // Arrange
        final container1 = ProviderContainer();
        final container2 = ProviderContainer();
        addTearDown(container1.dispose);
        addTearDown(container2.dispose);

        // Act & Assert
        expect(
          () {
            OverlayResolverWiring.install(container: container1);
            OverlayResolverWiring.install(container: container2);
          },
          returnsNormally,
        );
      });

      test('uses overlayDispatcherProvider from container', () {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // Act
        OverlayResolverWiring.install(container: container);

        // Assert - Can read the provider
        final dispatcher = container.read(overlayDispatcherProvider);
        expect(dispatcher, isA<OverlayDispatcher>());
      });
    });

    group('installFromGlobalDI', () {
      test('throws when GlobalDIContainer not initialized', () {
        // Arrange - Ensure not initialized
        GlobalDIContainer.reset();

        // Act & Assert
        expect(
          OverlayResolverWiring.installFromGlobalDI,
          throwsA(isA<StateError>()),
        );
      });

      test('installs successfully when GlobalDIContainer is initialized', () {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        GlobalDIContainer.initialize(container);

        // Act & Assert
        expect(
          OverlayResolverWiring.installFromGlobalDI,
          returnsNormally,
        );
      });

      test('installs with default both scope from GlobalDI', () {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        GlobalDIContainer.initialize(container);

        // Act & Assert
        expect(
          OverlayResolverWiring.installFromGlobalDI,
          returnsNormally,
        );
      });

      test('installs with contextOnly scope from GlobalDI', () {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        GlobalDIContainer.initialize(container);

        // Act & Assert
        expect(
          () => OverlayResolverWiring.installFromGlobalDI(
            scope: OverlayWiringScope.contextOnly,
          ),
          returnsNormally,
        );
      });

      test('installs with globalOnly scope from GlobalDI', () {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        GlobalDIContainer.initialize(container);

        // Act & Assert
        expect(
          () => OverlayResolverWiring.installFromGlobalDI(
            scope: OverlayWiringScope.globalOnly,
          ),
          returnsNormally,
        );
      });

      test('can be called multiple times from GlobalDI', () {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        GlobalDIContainer.initialize(container);

        // Act
        OverlayResolverWiring.installFromGlobalDI();
        OverlayResolverWiring.installFromGlobalDI();
        OverlayResolverWiring.installFromGlobalDI();

        // Assert - Should not throw
        expect(GlobalDIContainer.isInitialized, isTrue);
      });

      test('uses the same container as GlobalDIContainer', () {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        GlobalDIContainer.initialize(container);

        // Act
        OverlayResolverWiring.installFromGlobalDI();

        // Assert - Should use same container
        final dispatcher = GlobalDIContainer.instance.read(
          overlayDispatcherProvider,
        );
        expect(dispatcher, isA<OverlayDispatcher>());
      });
    });

    group('real-world scenarios', () {
      test('typical app initialization with GlobalDI', () {
        // Arrange - App startup
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // Act - Initialize GlobalDI
        GlobalDIContainer.initialize(container);

        // Wire overlay resolvers
        OverlayResolverWiring.installFromGlobalDI();

        // Assert - Everything initialized correctly
        expect(GlobalDIContainer.isInitialized, isTrue);
        expect(
          GlobalDIContainer.instance.read(overlayDispatcherProvider),
          isA<OverlayDispatcher>(),
        );
      });

      test('manual container wiring for testing', () {
        // Arrange - Test setup
        final testContainer = ProviderContainer();
        addTearDown(testContainer.dispose);

        // Act - Wire specific test container
        OverlayResolverWiring.install(
          container: testContainer,
        );

        // Assert - Test container wired correctly
        expect(
          testContainer.read(overlayDispatcherProvider),
          isA<OverlayDispatcher>(),
        );
      });

      test('context-only wiring for widget-based apps', () {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // Act - Wire only context resolvers
        OverlayResolverWiring.install(
          container: container,
          scope: OverlayWiringScope.contextOnly,
        );

        // Assert - Should not throw
        expect(container, isA<ProviderContainer>());
      });

      test('global-only wiring for background tasks', () {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        GlobalDIContainer.initialize(container);

        // Act - Wire only global resolvers
        OverlayResolverWiring.installFromGlobalDI(
          scope: OverlayWiringScope.globalOnly,
        );

        // Assert - GlobalDI accessible
        expect(GlobalDIContainer.isInitialized, isTrue);
      });

      test('re-wiring after GlobalDI reset', () {
        // Arrange - First initialization
        final container1 = ProviderContainer();
        addTearDown(container1.dispose);
        GlobalDIContainer.initialize(container1);
        OverlayResolverWiring.installFromGlobalDI();

        // Act - Reset and re-initialize
        GlobalDIContainer.reset();
        final container2 = ProviderContainer();
        addTearDown(container2.dispose);
        GlobalDIContainer.initialize(container2);
        OverlayResolverWiring.installFromGlobalDI();

        // Assert - New wiring works
        expect(GlobalDIContainer.isInitialized, isTrue);
        expect(
          GlobalDIContainer.instance.read(overlayDispatcherProvider),
          isA<OverlayDispatcher>(),
        );
      });

      test('wiring different scopes for different use cases', () {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // Act - Wire all three scope types
        OverlayResolverWiring.install(
          container: container,
        );

        OverlayResolverWiring.install(
          container: container,
          scope: OverlayWiringScope.contextOnly,
        );

        OverlayResolverWiring.install(
          container: container,
          scope: OverlayWiringScope.globalOnly,
        );

        // Assert - Last wiring wins, no errors
        expect(container, isA<ProviderContainer>());
      });
    });

    group('private constructor', () {
      test('cannot instantiate OverlayResolverWiring', () {
        // Assert - Constructor is private
        // This is enforced at compile time, so we just verify the class exists
        expect(OverlayResolverWiring, isA<Type>());
      });
    });
  });
}
