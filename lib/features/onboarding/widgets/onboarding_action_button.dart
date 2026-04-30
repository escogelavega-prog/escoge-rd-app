import 'package:escoge/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isPrimary;

  const OnboardingActionButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onTap == null;

    return SizedBox(
      width: double.infinity,
      height: 60,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isPrimary && !isDisabled
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.lumenGold,
                    AppColors.lumenGoldBright,
                  ],
                )
              : null,
          color: !isPrimary
              ? AppColors.lumenCard.withValues(alpha: 0.58)
              : isDisabled
                  ? AppColors.lumenGold.withValues(alpha: 0.45)
                  : null,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isPrimary
                ? Colors.transparent
                : AppColors.white.withValues(alpha: 0.10),
          ),
          boxShadow: isPrimary && !isDisabled
              ? [
                  BoxShadow(
                    color: AppColors.lumenGold.withValues(alpha: 0.18),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                    spreadRadius: -8,
                  ),
                ]
              : [],
        ),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            foregroundColor: isPrimary
                ? AppColors.lumenBackground
                : AppColors.white.withValues(alpha: 0.92),
            disabledForegroundColor:
                AppColors.lumenBackground.withValues(alpha: 0.70),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}
