import 'package:flutter/material.dart';

import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/core/theme/app_spacing.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? rightWidget;
  final Widget? leftWidget;
  final EdgeInsetsGeometry? padding;

  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.rightWidget,
    this.leftWidget,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: padding ??
          const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            52,
            AppSpacing.lg,
            24,
          ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryBlue,
            AppColors.secondaryBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(34),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(34),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.04),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.06),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (leftWidget != null)
            Align(
              alignment: Alignment.centerLeft,
              child: leftWidget!,
            ),
          if (rightWidget != null)
            Align(
              alignment: Alignment.centerRight,
              child: rightWidget!,
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 68),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    letterSpacing: -0.2,
                  ),
                ),
                if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.80),
                      height: 1.38,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
