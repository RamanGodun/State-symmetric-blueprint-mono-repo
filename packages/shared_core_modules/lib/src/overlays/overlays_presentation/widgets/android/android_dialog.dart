// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs

import 'dart:async' show unawaited;

import 'package:flutter/material.dart'
    show
        AlertDialog,
        BuildContext,
        Center,
        ColorScheme,
        Column,
        Container,
        EdgeInsets,
        FontWeight,
        MainAxisAlignment,
        MainAxisSize,
        Material,
        MaterialTapTargetSize,
        MaterialType,
        Padding,
        Row,
        SingleChildScrollView,
        Size,
        SizedBox,
        Stack,
        StatelessWidget,
        TextAlign,
        TextButton,
        VisualDensity,
        VoidCallback,
        Widget,
        WidgetsBinding,
        debugPrint;
import 'package:shared_core_modules/public_api/base_modules/animations.dart'
    show AnimatedOverlayShell, AnimationEngine;
import 'package:shared_core_modules/public_api/base_modules/overlays.dart';
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart'
    show
        AppSpacing,
        BlurContainer,
        BoxDecorationFactory,
        ContextMediaX,
        OverlayBarrierFilter,
        ThemeXOnContext,
        UIConstants,
        WidgetPaddingX;
import 'package:shared_widgets/public_api/dividers.dart' show GlassTileDivider;
import 'package:shared_widgets/public_api/text_widgets.dart';

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
      unawaited(
        dispatcher.dismissCurrent(force: true).whenComplete(() {
          unawaited(
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
            }),
          );
        }),
      );
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
