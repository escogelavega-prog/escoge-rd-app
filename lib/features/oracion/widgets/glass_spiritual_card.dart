import 'dart:ui';

import 'package:escoge/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class GlassSpiritualCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double blur;
  final double fillOpacity;
  final double borderOpacity;
  final bool elevated;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final VoidCallback? onTap;

  const GlassSpiritualCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = 28,
    this.blur = 16,
    this.fillOpacity = 0.07,
    this.borderOpacity = 0.12,
    this.elevated = true,
    this.boxShadow,
    this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);

    final card = ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: gradient,
            color: gradient == null
                ? AppColors.white.withValues(alpha: fillOpacity)
                : null,
            border: Border.all(
              color: AppColors.white.withValues(alpha: borderOpacity),
              width: 1,
            ),
            boxShadow: elevated
                ? (boxShadow ??
                    [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.34),
                        blurRadius: 28,
                        spreadRadius: -10,
                        offset: const Offset(0, 16),
                      ),
                      BoxShadow(
                        color:
                            AppColors.lumenPurpleGlow.withValues(alpha: 0.16),
                        blurRadius: 26,
                        spreadRadius: -12,
                        offset: const Offset(0, 10),
                      ),
                    ])
                : null,
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.white.withValues(alpha: 0.07),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.08),
                        ],
                        stops: const [0.0, 0.25, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 18,
                right: 18,
                child: IgnorePointer(
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppColors.white.withValues(alpha: 0.18),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );

    if (onTap == null) return card;

    return InkWell(
      borderRadius: borderRadius,
      onTap: onTap,
      child: card,
    );
  }
}
