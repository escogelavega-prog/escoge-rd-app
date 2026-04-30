import 'dart:ui';

import 'package:escoge/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OnboardingCard extends StatelessWidget {
  final Widget child;

  const OnboardingCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(34),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 16,
          sigmaY: 16,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 28,
          ),
          decoration: BoxDecoration(
            color: AppColors.lumenCard.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(34),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.10),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
              BoxShadow(
                color: AppColors.lumenGold.withValues(alpha: 0.04),
                blurRadius: 18,
                spreadRadius: -10,
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.white.withValues(alpha: 0.05),
                AppColors.white.withValues(alpha: 0.015),
              ],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
