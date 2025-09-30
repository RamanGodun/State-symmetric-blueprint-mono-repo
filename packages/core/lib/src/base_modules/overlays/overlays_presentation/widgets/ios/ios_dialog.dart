// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs

import 'package:core/src/base_modules/animations/module_core/animation__engine.dart';
import 'package:core/src/base_modules/animations/overlays_animation/animation_wrapper/animated_overlay_shell.dart';
import 'package:core/src/base_modules/localization/module_widgets/text_widget.dart';
import 'package:core/src/base_modules/overlays/core/enums_for_overlay_module.dart';
import 'package:core/src/base_modules/overlays/overlays_dispatcher/overlay_dispatcher.dart';
import 'package:core/src/base_modules/overlays/overlays_presentation/overlay_presets/overlay_preset_props.dart';
import 'package:core/src/base_modules/overlays/utils/ports/overlay_dispatcher_locator.dart'
    show resolveOverlayDispatcher;
import 'package:core/src/base_modules/ui_design/ui_constants/_app_constants.dart';
import 'package:core/src/base_modules/ui_design/widgets_and_utils/barrier_filter.dart';
import 'package:core/src/base_modules/ui_design/widgets_and_utils/box_decorations/_box_decorations_factory.dart';
import 'package:core/src/base_modules/ui_design/widgets_and_utils/extensions/theme_x.dart';
import 'package:core/src/shared_presentation_layer/extensions/extension_on_widget/_widget_x.dart';
import 'package:flutter/cupertino.dart';

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
