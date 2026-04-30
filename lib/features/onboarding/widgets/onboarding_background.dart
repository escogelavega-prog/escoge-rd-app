import 'package:escoge/core/theme/app_backgrounds.dart';
import 'package:escoge/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OnboardingBackground extends StatelessWidget {
  final Widget child;

  const OnboardingBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// FONDO BASE OFICIAL UNIFICADO
        Positioned.fill(
          child: Image.asset(
            AppBackgrounds.home,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.screenGradient,
                ),
              );
            },
          ),
        ),

        /// OVERLAY PRINCIPAL LUMEN / SACRO
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.34),
                  Colors.black.withValues(alpha: 0.62),
                  AppColors.lumenBackground.withValues(alpha: 0.97),
                ],
              ),
            ),
          ),
        ),

        /// GLOW RADIAL SUPERIOR
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.22),
                radius: 1.08,
                colors: [
                  AppColors.lumenGold.withValues(alpha: 0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        /// VIGNETTE SUAVE
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.black.withValues(alpha: 0.08),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.08),
                ],
              ),
            ),
          ),
        ),

        child,
      ],
    );
  }
}
