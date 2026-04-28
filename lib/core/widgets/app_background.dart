import 'package:escoge/core/theme/app_backgrounds.dart';
import 'package:escoge/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  // Nombre nuevo
  final String? backgroundImage;

  // Nombre anterior, mantenido para compatibilidad
  final String? background;

  final double? overlayOpacity;

  final bool safeArea;
  final bool scrollable;
  final EdgeInsetsGeometry? padding;
  final Alignment imageAlignment;
  final BoxFit imageFit;
  final bool enableTopGlow;
  final bool enableBottomFade;
  final bool enableCenterGlow;
  final bool useGradientOverlay;

  const AppBackground({
    super.key,
    required this.child,
    this.backgroundImage,
    this.background,
    this.overlayOpacity,
    this.safeArea = true,
    this.scrollable = false,
    this.padding,
    this.imageAlignment = Alignment.center,
    this.imageFit = BoxFit.cover,
    this.enableTopGlow = true,
    this.enableBottomFade = true,
    this.enableCenterGlow = true,
    this.useGradientOverlay = true,
  });

  @override
  Widget build(BuildContext context) {
    final String? resolvedBackground = backgroundImage ?? background;

    final double topOpacity = overlayOpacity ?? AppOverlay.lumenTop;
    final double middleOpacity = overlayOpacity != null
        ? (overlayOpacity! * 0.72).clamp(0.0, 1.0)
        : AppOverlay.lumenImage;
    final double bottomOpacity = overlayOpacity != null
        ? (overlayOpacity! * 1.22).clamp(0.0, 1.0)
        : AppOverlay.lumenBottom;

    final content = padding != null
        ? Padding(
            padding: padding!,
            child: child,
          )
        : child;

    final body = scrollable
        ? SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: content,
          )
        : content;

    final wrapped = safeArea ? SafeArea(child: body) : body;

    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.screenGradient,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (resolvedBackground != null)
            Positioned.fill(
              child: Image.asset(
                resolvedBackground,
                fit: imageFit,
                alignment: imageAlignment,
              ),
            ),
          if (useGradientOverlay)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: topOpacity),
                      Colors.black.withValues(alpha: middleOpacity),
                      Colors.black.withValues(alpha: bottomOpacity),
                    ],
                  ),
                ),
              ),
            ),
          if (enableTopGlow)
            Positioned(
              top: -120,
              left: -60,
              right: -60,
              child: Container(
                height: 260,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.15,
                    colors: [
                      AppColors.lumenGold.withValues(alpha: 0.10),
                      AppColors.lumenPurpleGlow.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          if (enableCenterGlow)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.15),
                    radius: 0.95,
                    colors: [
                      AppColors.lumenBlueGlow.withValues(alpha: 0.14),
                      AppColors.lumenPurpleGlow.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          if (enableBottomFade)
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.bottomFadeGradient,
                ),
              ),
            ),
          Positioned.fill(
            child: Container(
              color: AppColors.overlaySoft,
            ),
          ),
          wrapped,
        ],
      ),
    );
  }

  static Widget spiritual({
    required Widget child,
    String background = AppBackgrounds.uniform,
    bool scrollable = true,
    EdgeInsetsGeometry? padding,
    double? overlayOpacity,
  }) {
    return AppBackground(
      backgroundImage: background,
      overlayOpacity: overlayOpacity,
      scrollable: scrollable,
      padding: padding,
      child: child,
    );
  }

  static Widget home({
    required Widget child,
    bool scrollable = true,
    EdgeInsetsGeometry? padding,
    double? overlayOpacity,
  }) {
    return AppBackground(
      backgroundImage: AppBackgrounds.home,
      overlayOpacity: overlayOpacity,
      scrollable: scrollable,
      padding: padding,
      child: child,
    );
  }

  static Widget liturgy({
    required Widget child,
    bool scrollable = true,
    EdgeInsetsGeometry? padding,
    double? overlayOpacity,
  }) {
    return AppBackground(
      backgroundImage: AppBackgrounds.liturgia,
      overlayOpacity: overlayOpacity,
      scrollable: scrollable,
      padding: padding,
      child: child,
    );
  }

  static Widget form({
    required Widget child,
    bool scrollable = true,
    EdgeInsetsGeometry? padding,
    double? overlayOpacity,
  }) {
    return AppBackground(
      backgroundImage: AppBackgrounds.formulario,
      overlayOpacity: overlayOpacity,
      scrollable: scrollable,
      padding: padding,
      child: child,
    );
  }
}
