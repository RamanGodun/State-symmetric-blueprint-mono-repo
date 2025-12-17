import 'package:core/src/base_modules/animations/module_core/animation__engine.dart';
import 'package:core/src/base_modules/overlays/core/platform_mapper.dart';
import 'package:core/src/base_modules/overlays/overlays_presentation/overlay_presets/overlay_preset_props.dart';
import 'package:core/src/base_modules/overlays/overlays_presentation/widgets/android/android_banner.dart';
import 'package:core/src/base_modules/overlays/overlays_presentation/widgets/android/android_dialog.dart';
import 'package:core/src/base_modules/overlays/overlays_presentation/widgets/android/android_snackbar.dart';
import 'package:core/src/base_modules/overlays/overlays_presentation/widgets/ios/ios_banner.dart';
import 'package:core/src/base_modules/overlays/overlays_presentation/widgets/ios/ios_dialog.dart';
import 'package:core/src/base_modules/overlays/overlays_presentation/widgets/ios/ios_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlatformMapper', () {
    late AnimationEngine engine;
    late OverlayUIPresetProps presetProps;

    setUp(() {
      engine = FallbackAnimationEngine();
      presetProps = OverlayUIPresetProps(
        icon: Icons.info,
        color: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.all(16),
        behavior: SnackBarBehavior.floating,
      );
    });

    group('resolveAppDialog', () {
      test('returns IOSAppDialog for iOS platform', () {
        // Arrange
        const platform = TargetPlatform.iOS;

        // Act
        final widget = PlatformMapper.resolveAppDialog(
          platform: platform,
          engine: engine,
          title: 'Test Title',
          content: 'Test Content',
          confirmText: 'OK',
          cancelText: 'Cancel',
          onConfirm: () {},
          onCancel: () {},
          presetProps: presetProps,
          isInfoDialog: false,
          isFromUserFlow: true,
        );

        // Assert
        expect(widget, isA<IOSAppDialog>());
      });

      test('returns AndroidDialog for Android platform', () {
        // Arrange
        const platform = TargetPlatform.android;

        // Act
        final widget = PlatformMapper.resolveAppDialog(
          platform: platform,
          engine: engine,
          title: 'Test Title',
          content: 'Test Content',
          confirmText: 'OK',
          cancelText: 'Cancel',
          onConfirm: () {},
          onCancel: () {},
          presetProps: presetProps,
          isInfoDialog: false,
          isFromUserFlow: true,
        );

        // Assert
        expect(widget, isA<AndroidDialog>());
      });

      test('returns IOSAppDialog for unsupported platforms (default)', () {
        // Arrange
        const platforms = [
          TargetPlatform.linux,
          TargetPlatform.macOS,
          TargetPlatform.windows,
          TargetPlatform.fuchsia,
        ];

        for (final platform in platforms) {
          // Act
          final widget = PlatformMapper.resolveAppDialog(
            platform: platform,
            engine: engine,
            title: 'Test Title',
            content: 'Test Content',
            confirmText: 'OK',
            cancelText: 'Cancel',
            onConfirm: () {},
            onCancel: () {},
            presetProps: presetProps,
            isInfoDialog: false,
            isFromUserFlow: true,
          );

          // Assert
          expect(
            widget,
            isA<IOSAppDialog>(),
            reason: 'Platform $platform should default to IOSAppDialog',
          );
        }
      });

      test('passes all parameters correctly to iOS dialog', () {
        // Arrange
        const platform = TargetPlatform.iOS;
        const title = 'Warning';
        const content = 'Are you sure?';
        const confirmText = 'Yes';
        const cancelText = 'No';
        var confirmCalled = false;
        var cancelCalled = false;
        void onConfirm() => confirmCalled = true;
        void onCancel() => cancelCalled = true;

        // Act
        final widget =
            PlatformMapper.resolveAppDialog(
                  platform: platform,
                  engine: engine,
                  title: title,
                  content: content,
                  confirmText: confirmText,
                  cancelText: cancelText,
                  onConfirm: onConfirm,
                  onCancel: onCancel,
                  presetProps: presetProps,
                  isInfoDialog: true,
                  isFromUserFlow: false,
                )
                as IOSAppDialog;

        // Assert
        expect(widget.title, equals(title));
        expect(widget.content, equals(content));
        expect(widget.confirmText, equals(confirmText));
        expect(widget.cancelText, equals(cancelText));
        expect(widget.isInfoDialog, isTrue);
        expect(widget.isFromUserFlow, isFalse);
        expect(widget.presetProps, equals(presetProps));
        expect(widget.engine, equals(engine));

        // Verify callbacks work
        widget.onConfirm?.call();
        widget.onCancel?.call();
        expect(confirmCalled, isTrue);
        expect(cancelCalled, isTrue);
      });

      test('passes all parameters correctly to Android dialog', () {
        // Arrange
        const platform = TargetPlatform.android;
        const title = 'Error';
        const content = 'Something went wrong';
        const confirmText = 'Retry';
        const cancelText = 'Dismiss';
        var confirmCalled = false;
        void onConfirm() => confirmCalled = true;

        // Act
        final widget =
            PlatformMapper.resolveAppDialog(
                  platform: platform,
                  engine: engine,
                  title: title,
                  content: content,
                  confirmText: confirmText,
                  cancelText: cancelText,
                  onConfirm: onConfirm,
                  onCancel: null,
                  presetProps: presetProps,
                  isInfoDialog: false,
                  isFromUserFlow: true,
                )
                as AndroidDialog;

        // Assert
        expect(widget.title, equals(title));
        expect(widget.content, equals(content));
        expect(widget.confirmText, equals(confirmText));
        expect(widget.cancelText, equals(cancelText));
        expect(widget.isInfoDialog, isFalse);
        expect(widget.isFromUserFlow, isTrue);

        // Verify callback works
        widget.onConfirm?.call();
        expect(confirmCalled, isTrue);
      });

      test('handles null callbacks gracefully', () {
        // Arrange
        const platform = TargetPlatform.iOS;

        // Act
        final widget =
            PlatformMapper.resolveAppDialog(
                  platform: platform,
                  engine: engine,
                  title: 'Info',
                  content: 'Just a message',
                  confirmText: 'OK',
                  cancelText: '',
                  onConfirm: null,
                  onCancel: null,
                  presetProps: presetProps,
                  isInfoDialog: true,
                  isFromUserFlow: false,
                )
                as IOSAppDialog;

        // Assert - should not throw
        expect(widget.onConfirm, isNull);
        expect(widget.onCancel, isNull);
      });
    });

    group('resolveAppBanner', () {
      test('returns IOSBanner for iOS platform', () {
        // Arrange
        const platform = TargetPlatform.iOS;

        // Act
        final widget = PlatformMapper.resolveAppBanner(
          platform: platform,
          engine: engine,
          message: 'Test Banner',
          icon: Icons.info,
          presetProps: presetProps,
        );

        // Assert
        expect(widget, isA<IOSBanner>());
      });

      test('returns AndroidBanner for Android platform', () {
        // Arrange
        const platform = TargetPlatform.android;

        // Act
        final widget = PlatformMapper.resolveAppBanner(
          platform: platform,
          engine: engine,
          message: 'Test Banner',
          icon: Icons.info,
          presetProps: presetProps,
        );

        // Assert
        expect(widget, isA<AndroidBanner>());
      });

      test('returns IOSBanner for unsupported platforms (default)', () {
        // Arrange
        const platforms = [
          TargetPlatform.linux,
          TargetPlatform.macOS,
          TargetPlatform.windows,
          TargetPlatform.fuchsia,
        ];

        for (final platform in platforms) {
          // Act
          final widget = PlatformMapper.resolveAppBanner(
            platform: platform,
            engine: engine,
            message: 'Test Banner',
            icon: Icons.info,
            presetProps: presetProps,
          );

          // Assert
          expect(
            widget,
            isA<IOSBanner>(),
            reason: 'Platform $platform should default to IOSBanner',
          );
        }
      });

      test('passes all parameters correctly to iOS banner', () {
        // Arrange
        const platform = TargetPlatform.iOS;
        const message = 'Success message';
        const icon = Icons.check_circle;

        // Act
        final widget =
            PlatformMapper.resolveAppBanner(
                  platform: platform,
                  engine: engine,
                  message: message,
                  icon: icon,
                  presetProps: presetProps,
                )
                as IOSBanner;

        // Assert
        expect(widget.message, equals(message));
        expect(widget.icon, equals(icon));
        expect(widget.props, equals(presetProps));
        expect(widget.engine, equals(engine));
      });

      test('passes all parameters correctly to Android banner', () {
        // Arrange
        const platform = TargetPlatform.android;
        const message = 'Warning message';
        const icon = Icons.warning;

        // Act
        final widget =
            PlatformMapper.resolveAppBanner(
                  platform: platform,
                  engine: engine,
                  message: message,
                  icon: icon,
                  presetProps: presetProps,
                )
                as AndroidBanner;

        // Assert
        expect(widget.message, equals(message));
        expect(widget.icon, equals(icon));
        expect(widget.props, equals(presetProps));
        expect(widget.engine, equals(engine));
      });

      test('handles different icon types', () {
        // Arrange
        const icons = [
          Icons.error,
          Icons.info,
          Icons.warning,
          Icons.check,
          Icons.notification_important,
        ];

        for (final icon in icons) {
          // Act
          final widget =
              PlatformMapper.resolveAppBanner(
                    platform: TargetPlatform.iOS,
                    engine: engine,
                    message: 'Test',
                    icon: icon,
                    presetProps: presetProps,
                  )
                  as IOSBanner;

          // Assert
          expect(widget.icon, equals(icon));
        }
      });
    });

    group('resolveAppSnackbar', () {
      test('returns IOSToastBubble for iOS platform', () {
        // Arrange
        const platform = TargetPlatform.iOS;

        // Act
        final widget = PlatformMapper.resolveAppSnackbar(
          platform: platform,
          engine: engine,
          message: 'Test Snackbar',
          icon: Icons.info,
          presetProps: presetProps,
        );

        // Assert
        expect(widget, isA<IOSToastBubble>());
      });

      test('returns AndroidSnackbarCard for Android platform', () {
        // Arrange
        const platform = TargetPlatform.android;

        // Act
        final widget = PlatformMapper.resolveAppSnackbar(
          platform: platform,
          engine: engine,
          message: 'Test Snackbar',
          icon: Icons.info,
          presetProps: presetProps,
        );

        // Assert
        expect(widget, isA<AndroidSnackbarCard>());
      });

      test('returns IOSToastBubble for unsupported platforms (default)', () {
        // Arrange
        const platforms = [
          TargetPlatform.linux,
          TargetPlatform.macOS,
          TargetPlatform.windows,
          TargetPlatform.fuchsia,
        ];

        for (final platform in platforms) {
          // Act
          final widget = PlatformMapper.resolveAppSnackbar(
            platform: platform,
            engine: engine,
            message: 'Test Snackbar',
            icon: Icons.info,
            presetProps: presetProps,
          );

          // Assert
          expect(
            widget,
            isA<IOSToastBubble>(),
            reason: 'Platform $platform should default to IOSToastBubble',
          );
        }
      });

      test('passes all parameters correctly to iOS snackbar', () {
        // Arrange
        const platform = TargetPlatform.iOS;
        const message = 'Operation completed';
        const icon = Icons.done;

        // Act
        final widget =
            PlatformMapper.resolveAppSnackbar(
                  platform: platform,
                  engine: engine,
                  message: message,
                  icon: icon,
                  presetProps: presetProps,
                )
                as IOSToastBubble;

        // Assert
        expect(widget.message, equals(message));
        expect(widget.icon, equals(icon));
        expect(widget.props, equals(presetProps));
        expect(widget.engine, equals(engine));
      });

      test('passes all parameters correctly to Android snackbar', () {
        // Arrange
        const platform = TargetPlatform.android;
        const message = 'File saved';
        const icon = Icons.save;

        // Act
        final widget =
            PlatformMapper.resolveAppSnackbar(
                  platform: platform,
                  engine: engine,
                  message: message,
                  icon: icon,
                  presetProps: presetProps,
                )
                as AndroidSnackbarCard;

        // Assert
        expect(widget.message, equals(message));
        expect(widget.icon, equals(icon));
        expect(widget.props, equals(presetProps));
        expect(widget.engine, equals(engine));
      });

      test('handles empty messages gracefully', () {
        // Arrange
        const platform = TargetPlatform.iOS;
        const message = '';

        // Act
        final widget =
            PlatformMapper.resolveAppSnackbar(
                  platform: platform,
                  engine: engine,
                  message: message,
                  icon: Icons.info,
                  presetProps: presetProps,
                )
                as IOSToastBubble;

        // Assert
        expect(widget.message, equals(''));
      });
    });

    group('Platform consistency', () {
      test('all resolve methods use same platform logic', () {
        // Arrange
        const testPlatforms = [
          TargetPlatform.iOS,
          TargetPlatform.android,
          TargetPlatform.linux,
        ];

        for (final platform in testPlatforms) {
          // Act
          final dialog = PlatformMapper.resolveAppDialog(
            platform: platform,
            engine: engine,
            title: 'Test',
            content: 'Test',
            confirmText: 'OK',
            cancelText: 'Cancel',
            onConfirm: () {},
            onCancel: () {},
            presetProps: presetProps,
            isInfoDialog: false,
            isFromUserFlow: true,
          );

          final banner = PlatformMapper.resolveAppBanner(
            platform: platform,
            engine: engine,
            message: 'Test',
            icon: Icons.info,
            presetProps: presetProps,
          );

          final snackbar = PlatformMapper.resolveAppSnackbar(
            platform: platform,
            engine: engine,
            message: 'Test',
            icon: Icons.info,
            presetProps: presetProps,
          );

          // Assert - iOS or default
          if (platform == TargetPlatform.iOS ||
              platform == TargetPlatform.linux) {
            expect(dialog, isA<IOSAppDialog>());
            expect(banner, isA<IOSBanner>());
            expect(snackbar, isA<IOSToastBubble>());
          }

          // Assert - Android
          if (platform == TargetPlatform.android) {
            expect(dialog, isA<AndroidDialog>());
            expect(banner, isA<AndroidBanner>());
            expect(snackbar, isA<AndroidSnackbarCard>());
          }
        }
      });
    });
  });
}
