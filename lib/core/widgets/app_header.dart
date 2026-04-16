import 'package:flutter/material.dart';

import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/core/theme/app_spacing.dart';

enum AppHeaderVariant {
  defaultBlue,
  immersiveDark,
}

class AppHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? rightWidget;
  final Widget? leftWidget;
  final EdgeInsetsGeometry? padding;
  final AppHeaderVariant variant;
  final String? backgroundImage;
  final double height;

  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.rightWidget,
    this.leftWidget,
    this.padding,
    this.variant = AppHeaderVariant.defaultBlue,
    this.backgroundImage,
    this.height = 170,
  });

  bool get _isImmersive => variant == AppHeaderVariant.immersiveDark;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final borderRadius = BorderRadius.vertical(
      bottom: Radius.circular(_isImmersive ? 30 : 34),
    );

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: height),
      padding: padding ??
          EdgeInsets.fromLTRB(
            AppSpacing.lg,
            _isImmersive ? 56 : 52,
            AppSpacing.lg,
            _isImmersive ? 28 : 24,
          ),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: _isImmersive
            ? const LinearGradient(
                colors: [
                  Color(0xFF08101F),
                  Color(0xFF101A32),
                  Color(0xFF162544),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : const LinearGradient(
                colors: [
                  AppColors.primaryBlue,
                  AppColors.secondaryBlue,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: _isImmersive ? 0.24 : 0.14),
            blurRadius: _isImmersive ? 30 : 22,
            offset: Offset(0, _isImmersive ? 14 : 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (backgroundImage != null && backgroundImage!.trim().isNotEmpty)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: borderRadius,
                child: Opacity(
                  opacity: _isImmersive ? 0.24 : 0.12,
                  child: Image.asset(
                    backgroundImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  gradient: _isImmersive
                      ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withValues(alpha: 0.05),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.26),
                          ],
                        )
                      : LinearGradient(
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
          if (_isImmersive)
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    color: AppColors.overlaySoft,
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
                  style: (_isImmersive
                          ? textTheme.titleLarge
                          : textTheme.headlineSmall)
                      ?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    height: 1.12,
                    letterSpacing: _isImmersive ? -0.3 : -0.2,
                  ),
                ),
                if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(
                        alpha: _isImmersive ? 0.74 : 0.80,
                      ),
                      height: 1.42,
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
