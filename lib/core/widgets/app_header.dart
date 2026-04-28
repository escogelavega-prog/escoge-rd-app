import 'dart:ui';

import 'package:escoge/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final double height;
  final EdgeInsetsGeometry padding;
  final bool centered;
  final bool useGradient;
  final double bottomRadius;
  final bool glass;
  final String? eyebrow;

  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.height = 180,
    this.padding = const EdgeInsets.fromLTRB(20, 18, 20, 22),
    this.centered = true,
    this.useGradient = true,
    this.bottomRadius = 30,
    this.glass = true,
    this.eyebrow,
  });

  @override
  Widget build(BuildContext context) {
    final header = Container(
      height: height,
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        gradient: useGradient
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.lumenPurpleGlow.withValues(alpha: 0.72),
                  AppColors.lumenBlueGlow.withValues(alpha: 0.62),
                  AppColors.lumenBackground.withValues(alpha: 0.88),
                ],
              )
            : null,
        color: useGradient ? null : AppColors.lumenCard.withValues(alpha: 0.88),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(bottomRadius),
          bottomRight: Radius.circular(bottomRadius),
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.glassStrokeGold.withValues(alpha: 0.72),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.32),
            blurRadius: 28,
            spreadRadius: -6,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -70,
            left: -40,
            right: -40,
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.1,
                  colors: [
                    AppColors.lumenGold.withValues(alpha: 0.16),
                    AppColors.lumenPurpleGlow.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  leading ?? const SizedBox(width: 42),
                  Expanded(
                    child: centered
                        ? const SizedBox()
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: _HeaderText(
                              title: title,
                              subtitle: subtitle,
                              centered: false,
                              eyebrow: eyebrow,
                            ),
                          ),
                  ),
                  if (actions != null && actions!.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: actions!,
                    )
                  else
                    const SizedBox(width: 42),
                ],
              ),
              if (centered)
                Expanded(
                  child: Center(
                    child: _HeaderText(
                      title: title,
                      subtitle: subtitle,
                      centered: true,
                      eyebrow: eyebrow,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );

    if (!glass) return header;

    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(bottomRadius),
        bottomRight: Radius.circular(bottomRadius),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: header,
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool centered;
  final String? eyebrow;

  const _HeaderText({
    required this.title,
    required this.subtitle,
    required this.centered,
    required this.eyebrow,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        if (eyebrow != null) ...[
          Text(
            eyebrow!.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
              color: AppColors.lumenGoldSoft,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Text(
          title,
          textAlign: centered ? TextAlign.center : TextAlign.left,
          style: GoogleFonts.lora(
            fontSize: 29,
            fontWeight: FontWeight.w700,
            color: AppColors.lumenTextPrimary,
            height: 1.08,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 9),
          Text(
            subtitle!,
            textAlign: centered ? TextAlign.center : TextAlign.left,
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              color: AppColors.lumenTextSecondary,
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }
}
