import 'package:escoge/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;
  final double borderRadius;
  final Color? color;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin = EdgeInsets.zero,
    this.onTap,
    this.borderRadius = 28,
    this.color,
    this.borderColor,
    this.boxShadow,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null
            ? (color ?? AppColors.lumenCard.withValues(alpha: 0.88))
            : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? AppColors.glassStroke,
          width: 1,
        ),
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 26,
                spreadRadius: -4,
                offset: const Offset(0, 14),
              ),
              BoxShadow(
                color: AppColors.lumenBlueGlow.withValues(alpha: 0.10),
                blurRadius: 18,
                spreadRadius: -6,
                offset: const Offset(0, 6),
              ),
            ],
      ),
      child: child,
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: AppColors.lumenGold.withValues(alpha: 0.08),
        highlightColor: AppColors.lumenGold.withValues(alpha: 0.04),
        onTap: onTap,
        child: card,
      ),
    );
  }
}

// =========================
// GLASS PREMIUM CARD
// =========================
class AppGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;
  final double borderRadius;
  final bool highlighted;

  const AppGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin = EdgeInsets.zero,
    this.onTap,
    this.borderRadius = 30,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final glass = AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        gradient: highlighted
            ? AppColors.cardGlassGradient
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.glassFillStrong,
                  AppColors.glassFill,
                ],
              ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color:
              highlighted ? AppColors.glassStrokeGold : AppColors.glassStroke,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 28,
            spreadRadius: -4,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: AppColors.lumenPurpleGlow.withValues(alpha: 0.10),
            blurRadius: 18,
            spreadRadius: -8,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return glass;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: AppColors.lumenGold.withValues(alpha: 0.08),
        onTap: onTap,
        child: glass,
      ),
    );
  }
}

// =========================
// SECTION CARD
// =========================
class AppSectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final EdgeInsetsGeometry margin;
  final bool premium;

  const AppSectionCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.margin = const EdgeInsets.only(bottom: 18),
    this.premium = true,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final cardWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: premium
              ? textTheme.titleLarge?.copyWith(
                  color: AppColors.lumenGoldSoft,
                  fontWeight: FontWeight.w700,
                )
              : textTheme.titleMedium?.copyWith(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w700,
                ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: textTheme.bodyMedium?.copyWith(
              color: premium ? AppColors.lumenTextSecondary : Colors.black54,
              height: 1.55,
            ),
          ),
        ],
        const SizedBox(height: 16),
        child,
      ],
    );

    if (premium) {
      return AppGlassCard(
        margin: margin,
        highlighted: true,
        child: cardWidget,
      );
    }

    return AppCard(
      margin: margin,
      child: cardWidget,
    );
  }
}
