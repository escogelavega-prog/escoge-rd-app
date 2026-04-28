import 'package:escoge/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final EdgeInsetsGeometry padding;
  final Widget? trailing;
  final String? eyebrow;
  final bool centered;
  final bool premium;
  final bool compact;

  const SectionTitle({
    super.key,
    required this.title,
    required this.subtitle,
    this.padding = const EdgeInsets.symmetric(horizontal: 2),
    this.trailing,
    this.eyebrow,
    this.centered = false,
    this.premium = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor =
        premium ? AppColors.lumenTextPrimary : AppColors.primaryBlue;

    final subtitleColor =
        premium ? AppColors.lumenTextSecondary : AppColors.textSecondary;

    final eyebrowColor = premium ? AppColors.lumenGoldSoft : AppColors.gold;

    final content = Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        if (eyebrow != null) ...[
          Text(
            eyebrow!.toUpperCase(),
            textAlign: centered ? TextAlign.center : TextAlign.left,
            style: GoogleFonts.poppins(
              fontSize: compact ? 10 : 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.3,
              color: eyebrowColor,
            ),
          ),
          SizedBox(height: compact ? 6 : 8),
        ],

        // =========================
        // TITLE
        // =========================
        Text(
          title,
          textAlign: centered ? TextAlign.center : TextAlign.left,
          maxLines: compact ? 1 : 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.lora(
            fontSize: compact ? 22 : 26,
            fontWeight: FontWeight.w700,
            height: 1.12,
            color: titleColor,
          ),
        ),

        SizedBox(height: compact ? 6 : 8),

        // =========================
        // SUBTITLE
        // =========================
        Text(
          subtitle,
          textAlign: centered ? TextAlign.center : TextAlign.left,
          maxLines: compact ? 2 : 3,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontSize: compact ? 12.5 : 13.5,
            fontWeight: FontWeight.w400,
            height: 1.5,
            color: subtitleColor,
          ),
        ),
      ],
    );

    return Padding(
      padding: padding,
      child: centered
          ? Column(
              children: [
                content,
                if (trailing != null) ...[
                  const SizedBox(height: 14),
                  trailing!,
                ],
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: content),
                if (trailing != null) ...[
                  const SizedBox(width: 14),
                  trailing!,
                ],
              ],
            ),
    );
  }
}

// =========================
// MINI SECTION TITLE
// =========================
class MiniSectionTitle extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const MiniSectionTitle({
    super.key,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return SectionTitle(
      title: title,
      subtitle: '',
      compact: true,
      premium: true,
      padding: EdgeInsets.zero,
      trailing: trailing,
    );
  }
}
