// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs

import 'package:core/src/base_modules/animations/module_core/animation__engine.dart';
import 'package:core/src/base_modules/animations/overlays_animation/animation_wrapper/animated_overlay_shell.dart';
import 'package:core/src/base_modules/localization/module_widgets/text_widget.dart';
import 'package:core/src/base_modules/overlays/overlays_dispatcher/overlay_dispatcher.dart';
import 'package:core/src/base_modules/overlays/overlays_presentation/overlay_presets/overlay_preset_props.dart';
import 'package:core/src/base_modules/overlays/utils/ports/overlay_dispatcher_locator.dart'
    show resolveOverlayDispatcher;
import 'package:core/src/base_modules/ui_design/ui_constants/_app_constants.dart';
import 'package:core/src/base_modules/ui_design/widgets_and_utils/barrier_filter.dart';
import 'package:core/src/base_modules/ui_design/widgets_and_utils/blur_wrapper.dart'
    show BlurContainer;
import 'package:core/src/base_modules/ui_design/widgets_and_utils/box_decorations/_box_decorations_factory.dart';
import 'package:core/src/base_modules/ui_design/widgets_and_utils/extensions/theme_x.dart';
import 'package:core/src/shared_presentation_layer/extensions/context_extensions/_context_extensions.dart';
import 'package:core/src/shared_presentation_layer/extensions/extension_on_widget/_widget_x.dart';
import 'package:core/src/shared_presentation_layer/widgets_shared/divider.dart';
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
    // final dispatcher = context.readDI(overlayDispatcherProvider);
    final dispatcher = resolveOverlayDispatcher(context);
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
                              TextWidget(
                                title,
                                TextType.titleMedium,
                                color: colorScheme.errorContainer,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                              const SizedBox(height: AppSpacing.xm),
                              TextWidget(
                                content,
                                TextType.titleSmall,
                                fontWeight: FontWeight.w400,
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
                                    onPressed: _dismissThen(
                                      dispatcher,
                                      onConfirm,
                                    ),
                                    // onPressed: _handleConfirm(dispatcher),
                                    // onPressed: _wrapWithDismiss(dispatcher, onConfirm),
                                  ),
                                ]
                              : [
                                  _DialogButton(
                                    text: cancelText,
                                    colorScheme: colorScheme,
                                    onPressed: _dismissThen(
                                      dispatcher,
                                      onCancel,
                                    ),
                                    // onPressed: _handleCancel(dispatcher),
                                    // onPressed: _wrapWithDismiss(dispatcher, onCancel),
                                  ),
                                  _DialogButton(
                                    text: confirmText,
                                    colorScheme: colorScheme,
                                    onPressed: _dismissThen(
                                      dispatcher,
                                      onConfirm,
                                    ),
                                    // onPressed: _handleConfirm(dispatcher),
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

  /// ✅ Dismiss overlay, then run callback (if available)
  VoidCallback _dismissThen(
    OverlayDispatcher dispatcher,
    VoidCallback? action,
  ) {
    return () {
      dispatcher.dismissCurrent(force: true).whenComplete(() {
        Future.microtask(() {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            debugPrint(
              '[Overlay] confirm tapped → running action after dismiss (postFrame)',
            );
            final run = action ?? () {};
            try {
              run();
            } on Object catch (e, st) {
              debugPrint('❌ onConfirm action threw: $e\n$st');
            }
          });
        });
      });
    };
  }

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
