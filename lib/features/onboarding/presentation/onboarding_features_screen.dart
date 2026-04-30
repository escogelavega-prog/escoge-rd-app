import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/auth/presentation/login_screen.dart';
import 'package:escoge/features/onboarding/widgets/onboarding_page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingFeaturesScreen extends StatelessWidget {
  const OnboardingFeaturesScreen({super.key});

  Widget _featureTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: AppColors.lumenCard.withValues(alpha: 0.52),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.lumenGold.withValues(alpha: 0.12),
              border: Border.all(
                color: AppColors.lumenGold.withValues(alpha: 0.22),
              ),
            ),
            child: Icon(
              icon,
              color: AppColors.lumenGold,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: AppColors.white,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    color: AppColors.lumenTextSecondary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.lumenGold.withValues(alpha: 0.10),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.lumenGold,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingPageScaffold(
      onLoginTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Todo lo necesario',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Formación, liturgia y acompañamiento espiritual en una sola experiencia.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: AppColors.lumenTextSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 28),
          _featureTile(
            icon: Icons.menu_book_rounded,
            title: 'Biblia Católica',
            subtitle: 'Antiguo y Nuevo Testamento con lectura estructurada.',
          ),
          _featureTile(
            icon: Icons.auto_stories_rounded,
            title: 'Liturgia diaria',
            subtitle: 'Evangelio, lecturas, salmos y reflexión del día.',
          ),
          _featureTile(
            icon: Icons.volunteer_activism_rounded,
            title: 'Oración guiada',
            subtitle: 'Rosario, peticiones y recursos espirituales.',
          ),
          _featureTile(
            icon: Icons.calendar_month_rounded,
            title: 'Calendario litúrgico',
            subtitle: 'Celebraciones, santos y memoria eclesial.',
          ),
          _featureTile(
            icon: Icons.church_rounded,
            title: 'Retiros y comunidad',
            subtitle: 'Encuentros, actividades y vida pastoral.',
          ),
        ],
      ),
    );
  }
}
