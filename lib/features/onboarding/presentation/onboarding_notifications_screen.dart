import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/auth/presentation/login_screen.dart';
import 'package:escoge/features/onboarding/widgets/onboarding_page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingNotificationsScreen extends StatelessWidget {
  const OnboardingNotificationsScreen({super.key});

  Widget _item({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.lumenGold.withValues(alpha: 0.12),
              border: Border.all(
                color: AppColors.lumenGold.withValues(alpha: 0.20),
              ),
            ),
            child: Icon(
              icon,
              color: AppColors.lumenGold,
              size: 24,
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
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.lumenGold.withValues(alpha: 0.14),
              border: Border.all(
                color: AppColors.lumenGold.withValues(alpha: 0.24),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.lumenGold.withValues(alpha: 0.08),
                  blurRadius: 20,
                  spreadRadius: -6,
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: AppColors.lumenGold,
              size: 38,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Mantente conectado',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Recibe recordatorios espirituales, eventos importantes y acompañamiento diario según tu ritmo.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: AppColors.lumenTextSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 24),
          _item(
            icon: Icons.schedule_rounded,
            title: 'Rutina de oración',
            subtitle:
                'Recordatorios suaves para fortalecer tu disciplina espiritual.',
          ),
          _item(
            icon: Icons.wb_sunny_rounded,
            title: 'Mañana y noche',
            subtitle: 'Inicia y termina el día con guía espiritual.',
          ),
          _item(
            icon: Icons.calendar_month_rounded,
            title: 'Calendario litúrgico',
            subtitle: 'Solemnidades, santos y celebraciones importantes.',
          ),
          _item(
            icon: Icons.tune_rounded,
            title: 'Control personal',
            subtitle: 'Decide qué notificaciones deseas recibir.',
          ),
        ],
      ),
    );
  }
}
