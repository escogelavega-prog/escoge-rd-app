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
            54,
            AppSpacing.lg,
            22,
          ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBlue,
            AppColors.secondaryBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
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
                    height: 1.15,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 5),
                  Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.82),
                      height: 1.3,
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
