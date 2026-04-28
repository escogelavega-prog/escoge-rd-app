import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PremiumMenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool showArrow;
  final bool highlighted;
  final Widget? trailing;
  final double borderRadius;

  const PremiumMenuCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.showArrow = true,
    this.highlighted = false,
    this.trailing,
    this.borderRadius = 30,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: AppColors.lumenGold.withValues(alpha: 0.08),
          highlightColor: AppColors.lumenGold.withValues(alpha: 0.04),
          onTap: onTap,
          child: Ink(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
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
                color: highlighted
                    ? AppColors.glassStrokeGold
                    : AppColors.glassStroke,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.24),
                  blurRadius: 28,
                  spreadRadius: -8,
                  offset: const Offset(0, 14),
                ),
                BoxShadow(
                  color: highlighted
                      ? AppColors.lumenGold.withValues(alpha: 0.10)
                      : AppColors.lumenPurpleGlow.withValues(alpha: 0.08),
                  blurRadius: 20,
                  spreadRadius: -10,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                _PremiumIconContainer(
                  icon: icon,
                  highlighted: highlighted,
                ),
                const SizedBox(width: 16),

                // =========================
                // TEXT CONTENT
                // =========================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lora(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: highlighted
                              ? AppColors.lumenGoldSoft
                              : AppColors.lumenTextPrimary,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.lumenTextSecondary,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),

                // =========================
                // TRAILING
                // =========================
                if (trailing != null)
                  trailing!
                else if (showArrow)
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.lumenGold.withValues(
                        alpha: highlighted ? 0.14 : 0.08,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: highlighted
                            ? AppColors.glassStrokeGold
                            : AppColors.glassStroke,
                      ),
                    ),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: highlighted
                          ? AppColors.lumenGoldSoft
                          : AppColors.lumenTextMuted,
                      size: 24,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =========================
// PREMIUM ICON BLOCK
// =========================
class _PremiumIconContainer extends StatelessWidget {
  final IconData icon;
  final bool highlighted;

  const _PremiumIconContainer({
    required this.icon,
    required this.highlighted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: highlighted
              ? [
                  AppColors.lumenGoldBright,
                  AppColors.lumenGold,
                  AppColors.lumenGoldDeep,
                ]
              : [
                  AppColors.lumenPurpleGlow.withValues(alpha: 0.85),
                  AppColors.lumenBlueGlow.withValues(alpha: 0.72),
                ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color:
              highlighted ? AppColors.glassStrokeGold : AppColors.glassStroke,
        ),
        boxShadow: [
          BoxShadow(
            color: highlighted
                ? AppColors.lumenGold.withValues(alpha: 0.18)
                : Colors.black.withValues(alpha: 0.18),
            blurRadius: 18,
            spreadRadius: -6,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: highlighted ? AppColors.black : AppColors.lumenGoldSoft,
        size: 30,
      ),
    );
  }
}
