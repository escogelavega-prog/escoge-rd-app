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
  });

  @override
  Widget build(BuildContext context) {
    final headerContent = Container(
      height: height,
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        gradient:
            useGradient
                ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryBlue,
                    AppColors.secondaryBlue,
                  ],
                )
                : null,
        color: useGradient ? null : AppColors.primaryBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(bottomRadius),
          bottomRight: Radius.circular(bottomRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              leading ?? const SizedBox(width: 40),
              Expanded(
                child: centered
                    ? const SizedBox()
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: _HeaderText(
                          title: title,
                          subtitle: subtitle,
                          centered: false,
                        ),
                      ),
              ),
              if (actions != null && actions!.isNotEmpty)
                Row(mainAxisSize: MainAxisSize.min, children: actions!)
              else
                const SizedBox(width: 40),
            ],
          ),
          if (centered)
            Expanded(
              child: Center(
                child: _HeaderText(
                  title: title,
                  subtitle: subtitle,
                  centered: true,
                ),
              ),
            ),
        ],
      ),
    );

    return headerContent;
  }
}

class _HeaderText extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool centered;

  const _HeaderText({
    required this.title,
    required this.subtitle,
    required this.centered,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: centered ? TextAlign.center : TextAlign.left,
          style: GoogleFonts.lora(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.1,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            textAlign: centered ? TextAlign.center : TextAlign.left,
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.88),
              height: 1.45,
            ),
          ),
        ],
      ],
    );
  }
}