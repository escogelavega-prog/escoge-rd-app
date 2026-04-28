import 'package:escoge/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  danger,
}

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final Widget? leading;
  final bool loading;
  final bool fullWidth;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.leading,
    this.loading = false,
    this.fullWidth = true,
    this.height = 56,
    this.borderRadius = 22,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.textStyle,
  });

  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.leading,
    this.loading = false,
    this.fullWidth = true,
    this.height = 56,
    this.borderRadius = 22,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.textStyle,
  }) : variant = AppButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.leading,
    this.loading = false,
    this.fullWidth = true,
    this.height = 56,
    this.borderRadius = 22,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.textStyle,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.outline({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.leading,
    this.loading = false,
    this.fullWidth = true,
    this.height = 56,
    this.borderRadius = 22,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.textStyle,
  }) : variant = AppButtonVariant.outline;

  const AppButton.ghost({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.leading,
    this.loading = false,
    this.fullWidth = true,
    this.height = 52,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.symmetric(horizontal: 18),
    this.textStyle,
  }) : variant = AppButtonVariant.ghost;

  const AppButton.danger({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.leading,
    this.loading = false,
    this.fullWidth = true,
    this.height = 56,
    this.borderRadius = 22,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.textStyle,
  }) : variant = AppButtonVariant.danger;

  @override
  Widget build(BuildContext context) {
    final bool disabled = onPressed == null || loading;
    final _ButtonStyleData style = _resolveStyle(disabled);

    final content = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading) ...[
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(style.foreground),
            ),
          ),
          const SizedBox(width: 10),
        ] else if (leading != null) ...[
          leading!,
          const SizedBox(width: 10),
        ] else if (icon != null) ...[
          Icon(
            icon,
            size: 19,
            color: style.foreground,
          ),
          const SizedBox(width: 10),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyle ??
                GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.25,
                  color: style.foreground,
                ),
          ),
        ),
      ],
    );

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: disabled ? 0.58 : 1,
      child: SizedBox(
        width: fullWidth ? double.infinity : null,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: style.gradient,
            color: style.gradient == null ? style.background : null,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: style.border,
              width: 1,
            ),
            boxShadow: style.shadows,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: disabled ? null : onPressed,
              borderRadius: BorderRadius.circular(borderRadius),
              splashColor: style.splash,
              highlightColor: style.highlight,
              child: Padding(
                padding: padding,
                child: Center(child: content),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _ButtonStyleData _resolveStyle(bool disabled) {
    switch (variant) {
      case AppButtonVariant.primary:
        return _ButtonStyleData(
          foreground: AppColors.black,
          background: AppColors.lumenGold,
          border: AppColors.lumenGoldBright.withValues(alpha: 0.65),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.lumenGoldBright.withValues(alpha: disabled ? 0.55 : 1),
              AppColors.lumenGold.withValues(alpha: disabled ? 0.55 : 1),
              AppColors.lumenGoldDeep.withValues(alpha: disabled ? 0.55 : 1),
            ],
          ),
          shadows: disabled
              ? const []
              : [
                  BoxShadow(
                    color: AppColors.lumenGold.withValues(alpha: 0.22),
                    blurRadius: 24,
                    spreadRadius: -6,
                    offset: const Offset(0, 12),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.22),
                    blurRadius: 20,
                    spreadRadius: -8,
                    offset: const Offset(0, 10),
                  ),
                ],
          splash: Colors.black.withValues(alpha: 0.08),
          highlight: Colors.black.withValues(alpha: 0.04),
        );

      case AppButtonVariant.secondary:
        return _ButtonStyleData(
          foreground: AppColors.lumenTextPrimary,
          background: AppColors.glassFillStrong,
          border: AppColors.glassStrokeGold,
          gradient: AppColors.cardGlassGradient,
          shadows: disabled
              ? const []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.20),
                    blurRadius: 22,
                    spreadRadius: -6,
                    offset: const Offset(0, 10),
                  ),
                ],
          splash: AppColors.lumenGold.withValues(alpha: 0.08),
          highlight: AppColors.lumenGold.withValues(alpha: 0.04),
        );

      case AppButtonVariant.outline:
        return _ButtonStyleData(
          foreground: AppColors.lumenGoldSoft,
          background: Colors.transparent,
          border: AppColors.glassStrokeGold,
          gradient: null,
          shadows: const [],
          splash: AppColors.lumenGold.withValues(alpha: 0.08),
          highlight: AppColors.lumenGold.withValues(alpha: 0.04),
        );

      case AppButtonVariant.ghost:
        return _ButtonStyleData(
          foreground: AppColors.lumenTextSecondary,
          background: Colors.transparent,
          border: Colors.transparent,
          gradient: null,
          shadows: const [],
          splash: AppColors.lumenGold.withValues(alpha: 0.06),
          highlight: AppColors.lumenGold.withValues(alpha: 0.03),
        );

      case AppButtonVariant.danger:
        return _ButtonStyleData(
          foreground: AppColors.white,
          background: AppColors.error,
          border: AppColors.error.withValues(alpha: 0.85),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.error.withValues(alpha: disabled ? 0.55 : 0.95),
              AppColors.error.withValues(alpha: disabled ? 0.45 : 0.72),
            ],
          ),
          shadows: disabled
              ? const []
              : [
                  BoxShadow(
                    color: AppColors.error.withValues(alpha: 0.18),
                    blurRadius: 22,
                    spreadRadius: -6,
                    offset: const Offset(0, 10),
                  ),
                ],
          splash: Colors.white.withValues(alpha: 0.08),
          highlight: Colors.white.withValues(alpha: 0.04),
        );
    }
  }
}

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double size;
  final double iconSize;
  final bool highlighted;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.size = 46,
    this.iconSize = 21,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: highlighted
              ? AppColors.lumenGold.withValues(alpha: 0.14)
              : AppColors.glassFill,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color:
                highlighted ? AppColors.glassStrokeGold : AppColors.glassStroke,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.16),
              blurRadius: 18,
              spreadRadius: -8,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(18),
            splashColor: AppColors.lumenGold.withValues(alpha: 0.08),
            child: Icon(
              icon,
              size: iconSize,
              color: highlighted
                  ? AppColors.lumenGoldSoft
                  : AppColors.lumenTextSecondary,
            ),
          ),
        ),
      ),
    );

    if (tooltip == null) return child;

    return Tooltip(
      message: tooltip!,
      child: child,
    );
  }
}

class _ButtonStyleData {
  final Color foreground;
  final Color background;
  final Color border;
  final Gradient? gradient;
  final List<BoxShadow> shadows;
  final Color splash;
  final Color highlight;

  const _ButtonStyleData({
    required this.foreground,
    required this.background,
    required this.border,
    required this.gradient,
    required this.shadows,
    required this.splash,
    required this.highlight,
  });
}
