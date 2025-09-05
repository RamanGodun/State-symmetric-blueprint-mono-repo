/*

part of 'overlay_service.dart';

/// 🎭 [_AnimatedOverlayWidget] — fading & scaling animation for overlay content
/// 🧼 Responsive, theme-aware, adaptive presentation
//
final class _AnimatedOverlayWidget extends HookWidget {
  ///-----------------------------------------
  //
  final String message;
  final IconData icon;
  final OverlayPosition position;

  const _AnimatedOverlayWidget({
    required this.message,
    required this.icon,
    required this.position,
  });
  //

  @override
  Widget build(BuildContext context) {
    //
    final animationController = useAnimationController(
      duration: AppDurations.ms600,
    )..forward();

    final opacity = animationController.drive(
      Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: Curves.easeOut)),
    );

    final scale = animationController.drive(
      Tween<double>(
        begin: 0.8,
        end: 1,
      ).chain(CurveTween(curve: Curves.elasticOut)),
    );

    final isDark = context.isDarkMode;
    final size = MediaQuery.of(context).size;

    final top = switch (position) {
      OverlayPosition.top => size.height * 0.15,
      OverlayPosition.center => size.height * 0.4,
      OverlayPosition.bottom => size.height * 0.8,
    };

    final backgroundColor =
        isDark
            ? AppColors.overlayDarkBackground
            : AppColors.overlayLightBackground70;
    final textColor = isDark ? AppColors.white : AppColors.black;
    final borderColor =
        isDark ? AppColors.overlayDarkBorder10 : AppColors.overlayLightBorder12;

    return Stack(
      children: [
        Positioned(
          top: top,
          left: size.width * 0.1,
          right: size.width * 0.1,
          child: FadeTransition(
            opacity: opacity,
            child: ScaleTransition(
              scale: scale,
              child: GestureDetector(
                onTap: OverlayNotificationService._removeOverlay,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, color: textColor, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextWidget(
                            message,
                            TextType.titleSmall,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  //
}



 */
