// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs

import 'package:core/base_modules/animations/module_core/_animation_engine.dart';
import 'package:core/base_modules/animations/overlays_animation/animation_wrapper/animated_overlay_shell.dart';
import 'package:core/base_modules/localization/module_widgets/text_widget.dart';
import 'package:core/base_modules/overlays/overlays_dispatcher/_overlay_dispatcher.dart';
import 'package:core/base_modules/overlays/overlays_dispatcher/overlay_dispatcher_provider.dart';
import 'package:core/base_modules/overlays/overlays_presentation/overlay_presets/overlay_preset_props.dart';
import 'package:core/base_modules/theme/ui_constants/_app_constants.dart';
import 'package:core/base_modules/theme/widgets_and_utils/barrier_filter.dart';
import 'package:core/base_modules/theme/widgets_and_utils/blur_wrapper.dart'
    show BlurContainer;
import 'package:core/base_modules/theme/widgets_and_utils/box_decorations/_box_decorations_factory.dart';
import 'package:core/base_modules/theme/widgets_and_utils/extensions/theme_x.dart';
import 'package:core/di_container_cubit/core/di.dart' show di;
import 'package:core/di_container_riverpod/read_di_x_on_context.dart';
import 'package:core/shared_presentation_layer/shared_widgets/divider.dart';
import 'package:core/utils_shared/extensions/context_extensions/_context_extensions.dart';
import 'package:core/utils_shared/extensions/extension_on_widget/_widget_x_barrel.dart';
import 'package:flutter/material.dart';

/// 💬 [AndroidDialog] — Platform-aware Material dialog with animation
/// - Built for Android: uses [AlertDialog] + entrance animation via [AnimationEngine]
/// - Triggered from overlay tasks or state dispatcher flows
/// - Handles fallback dismiss logic via 'onAnimatedDismiss'
//
final class AndroidDialog extends StatelessWidget {
  ///-------------------------------------------
  const AndroidDialog({
    required this.title,
    required this.content,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    required this.onCancel,
    required this.presetProps,
    required this.isInfoDialog,
    required this.isFromUserFlow,
    required this.engine,
    super.key,
  });

  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final OverlayUIPresetProps? presetProps;
  final bool isInfoDialog;
  final bool isFromUserFlow;
  final AnimationEngine engine;

  //

  @override
  Widget build(BuildContext context) {
    //
    // final dispatcher = di<OverlayDispatcher>();
    final dispatcher = context.readDI(overlayDispatcherProvider);
    //
    final isDark = context.isDarkMode;
    final colorScheme = context.colorScheme;
    final decoration = BoxDecorationFactory.androidDialog(isDark: isDark);

    /// 🧱 Animated dialog using fade + scale from [engine]
    return AnimatedOverlayShell(
      engine: engine,
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            /// 🧊 Fullscreen blurred barrier
            OverlayBarrierFilter.resolve(isDark: isDark),

            /// Dialog container
            Center(
              child: BlurContainer(
                child: Container(
                  width: context.screenWidth * 0.7,
                  padding: UIConstants.zeroPadding,
                  decoration: decoration,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xl,
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: AppSpacing.xxxm),
                              TextWidget(title, TextType.titleMedium),
                              const SizedBox(height: AppSpacing.xxxm),
                              TextWidget(
                                content,
                                TextType.bodyLarge,
                                fontWeight: FontWeight.w200,
                                isTextOnFewStrings: true,
                                alignment: TextAlign.center,
                              ),
                              const SizedBox(height: AppSpacing.xxxs),
                            ],
                          ),
                        ),

                        const GlassTileDivider(),

                        /// 🧩 Action buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: isInfoDialog
                              ? [
                                  _DialogButton(
                                    text: confirmText,
                                    colorScheme: colorScheme,
                                    onPressed: _handleConfirm(dispatcher),
                                    // onPressed: _wrapWithDismiss(dispatcher, onConfirm),
                                  ),
                                ]
                              : [
                                  _DialogButton(
                                    text: cancelText,
                                    colorScheme: colorScheme,
                                    onPressed: _handleCancel(dispatcher),
                                    // onPressed: _wrapWithDismiss(dispatcher, onCancel),
                                  ),
                                  _DialogButton(
                                    text: confirmText,
                                    colorScheme: colorScheme,
                                    onPressed: _handleConfirm(dispatcher),
                                    // onPressed: _wrapWithDismiss(dispatcher, onConfirm),
                                  ),
                                ],
                        ).withPaddingOnly(bottom: AppSpacing.xxxm),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Option with dialog auto-closing, when action is given
  // ignore: unused_element
  VoidCallback _wrapWithDismiss(
    OverlayDispatcher dispatcher,
    VoidCallback? action,
  ) {
    return () {
      dispatcher.dismissCurrent(force: true);
      action?.call();
    };
  }

  /// 🧭 Resolves cancel action: fallback to 'onAnimatedDismiss' if [onCancel] is null
  VoidCallback _handleCancel(OverlayDispatcher dispatcher) =>
      onCancel ??
      () {
        dispatcher.dismissCurrent(force: true);
        onCancel?.call();
      };

  /// 🧭 Resolves confirm action: fallback to 'onAnimatedDismiss' if [onConfirm] is null
  VoidCallback _handleConfirm(OverlayDispatcher dispatcher) =>
      onConfirm ??
      () {
        dispatcher.dismissCurrent(force: true);
        onConfirm?.call();
      };

  //
}

////

////

////

/// 🆗 [_DialogButton] — Compact dialog button (TextButton with zero padding)
/// - Uses TextType.button + primary color from theme
/// - Tap area is minimal but accessible (shrinks height and padding)
//
final class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.text,
    required this.colorScheme,
    required this.onPressed,
  });

  /// ───────────────────────────────────────────-
  //
  final String text;
  final ColorScheme colorScheme;
  final VoidCallback onPressed;
  //

  @override
  Widget build(BuildContext context) {
    //
    final color = colorScheme.primary;
    //
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
      child: TextWidget(text, TextType.button, color: color),
    );
  }

  //
}
