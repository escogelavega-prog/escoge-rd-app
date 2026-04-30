import 'package:escoge/core/constants/app_assets.dart';
import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/onboarding/widgets/onboarding_background.dart';
import 'package:escoge/features/onboarding/widgets/onboarding_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingIntroScreen extends StatelessWidget {
  const OnboardingIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lumenBackground,
      body: OnboardingBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 118,
                  height: 118,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.lumenCard.withValues(alpha: 0.78),
                    border: Border.all(
                      color: AppColors.lumenGold.withValues(alpha: 0.34),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.lumenGold.withValues(alpha: 0.14),
                        blurRadius: 28,
                        spreadRadius: -8,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      AppAssets.logoMovimiento,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return const Icon(
                          Icons.auto_awesome_rounded,
                          color: AppColors.lumenGold,
                          size: 48,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 34),
                OnboardingCard(
                  child: Column(
                    children: [
                      Container(
                        width: 78,
                        height: 78,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white.withValues(alpha: 0.06),
                          border: Border.all(
                            color: AppColors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: const Icon(
                          Icons.auto_awesome_rounded,
                          color: AppColors.lumenGold,
                          size: 38,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'Bienvenido a Escoge RD',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: AppColors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Un espacio para vivir retiros, profundizar en la fe y acompañar tu camino espiritual.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: AppColors.lumenTextSecondary,
                          fontSize: 15,
                          height: 1.62,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
