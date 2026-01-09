// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs

import 'dart:async' show unawaited;

import 'package:flutter/cupertino.dart'
    show CupertinoAlertDialog, CupertinoDialogAction;
import 'package:flutter/material.dart'
    show
        BuildContext,
        Container,
        FontWeight,
        MainAxisAlignment,
        Row,
        Stack,
        StatelessWidget,
        TextAlign,
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
        BoxDecorationFactory,
        OverlayBarrierFilter,
        ThemeXOnContext,
        WidgetAlignX,
        WidgetPaddingX;
import 'package:shared_widgets/public_api/text_widgets.dart'
    show TextType, TextWidget;

/// 🍎 [IOSAppDialog] — Animated glass-style Cupertino dialog for iOS/macOS
/// - Fade + scale animation
/// - Improved visibility in light theme with soft gray transparent background
/// - Fully uses AppColors
//
final class IOSAppDialog extends StatelessWidget {
  /// ─────────────────────────────────────────
  const IOSAppDialog({
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
  final OverlayUIPresetProps? presetProps; // 🎨 Optional style preset
  final bool isInfoDialog;
  final bool isFromUserFlow;
  final AnimationEngine engine;

  //

  @override
  Widget build(BuildContext context) {
    //
    // final dispatcher = context.readDI(overlayDispatcherProvider);
    // final dispatcher = di<OverlayDispatcher>();
    final dispatcher = resolveOverlayDispatcher(context);
    //
    final isDark = context.isDarkMode;
    final colorScheme = context.colorScheme;
    final decoration = BoxDecorationFactory.iosDialog(isDark: isDark);

    return AnimatedOverlayShell(
      engine: engine,
      child: Stack(
        children: [
          OverlayBarrierFilter.resolve(
            isDark: isDark,
            level: OverlayBlurLevel.soft,
          ),

          Container(
            decoration: decoration,

            child: CupertinoAlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget(
                    title,
                    TextType.titleMedium,
                    color: colorScheme.errorContainer,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    isTextOnFewStrings: true,
                  ),
                ],
              ).centered().withPaddingTop(AppSpacing.s),

              content: TextWidget(
                content,
                TextType.titleSmall,
                fontWeight: FontWeight.w400,
                fontSize: 18,
                isTextOnFewStrings: true,
                alignment: TextAlign.start,
              ).withPaddingSymmetric(h: AppSpacing.m, v: AppSpacing.m),

              actions: isInfoDialog
                  ? [
                      CupertinoDialogAction(
                        onPressed: _dismissThen(dispatcher, onConfirm),
                        // onPressed: onConfirm ?? () => _fallback(dispatcher, onConfirm),
                        // onPressed: _wrapWithDismiss(dispatcher, onConfirm),
                        isDefaultAction: true,
                        child: TextWidget(
                          confirmText,
                          TextType.button,
                          color: colorScheme.primary,
                        ),
                      ),
                    ]
                  : [
                      CupertinoDialogAction(
                        onPressed: _dismissThen(dispatcher, onCancel),
                        // onPressed: onCancel ?? () => _fallback(dispatcher, onCancel),
                        // onPressed: _wrapWithDismiss(dispatcher, onCancel),
                        child: TextWidget(
                          cancelText,
                          TextType.button,
                          color: colorScheme.error,
                        ),
                      ),
                      CupertinoDialogAction(
                        onPressed: _dismissThen(dispatcher, onConfirm),
                        // onPressed: onConfirm ?? () => _fallback(dispatcher, onConfirm),
                        // onPressed: _wrapWithDismiss(dispatcher, onConfirm),
                        isDefaultAction: true,
                        child: TextWidget(
                          confirmText,
                          TextType.button,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
            ),
          ),
        ],
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
