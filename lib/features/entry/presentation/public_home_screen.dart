import 'package:escoge/app/routes/app_page_route.dart';
import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/auth/presentation/login_screen.dart';
import 'package:escoge/features/auth/presentation/register_screen.dart';
import 'package:escoge/features/onboarding/widgets/onboarding_action_button.dart';
import 'package:escoge/features/onboarding/widgets/onboarding_background.dart';
import 'package:escoge/features/oracion/presentation/evangelio_screen.dart';
import 'package:escoge/features/oracion/presentation/lecturas_screen.dart';
import 'package:escoge/features/oracion/widgets/glass_spiritual_card.dart';
import 'package:escoge/features/retiros/presentation/retiros_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PublicHomeScreen extends StatelessWidget {
  const PublicHomeScreen({super.key});

  static const String _logoPath = 'assets/images/logo_movimiento.png';

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      AppPageRoute(page: screen),
    );
  }

  Widget _quickItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GlassSpiritualCard(
        onTap: onTap,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.lumenGold.withValues(alpha: 0.12),
                border: Border.all(
                  color: AppColors.lumenGold.withValues(alpha: 0.18),
                ),
              ),
              child: Icon(
                icon,
                color: AppColors.lumenGold,
                size: 25,
              ),
            ),
            const SizedBox(width: 16),
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
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      color: AppColors.lumenTextSecondary,
                      fontSize: 12.8,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.white.withValues(alpha: 0.28),
              size: 15,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return GlassSpiritualCard(
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.lumenCard.withValues(alpha: 0.62),
              border: Border.all(
                color: AppColors.lumenGold.withValues(alpha: 0.28),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.lumenGold.withValues(alpha: 0.14),
                  blurRadius: 24,
                  spreadRadius: -8,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                _logoPath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return const Icon(
                    Icons.auto_awesome_rounded,
                    color: AppColors.lumenGold,
                    size: 42,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Explora Escoge RD',
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(
              color: AppColors.white,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Una experiencia espiritual para descubrir el Evangelio, vivir la liturgia y encontrar retiros transformadores.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: AppColors.lumenTextSecondary,
              fontSize: 14,
              height: 1.65,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard() {
    return GlassSpiritualCard(
      padding: const EdgeInsets.all(18),
      child: Text(
        'Crea una cuenta para acceder a una experiencia espiritual completa, personalizada y conectada con tu comunidad.',
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          color: AppColors.white.withValues(alpha: 0.84),
          fontSize: 13,
          height: 1.6,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: OnboardingBackground(
        child: SafeArea(
          child: Column(
            children: [
              /// HEADER SUPERIOR
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => _push(context, const LoginScreen()),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lumenCard.withValues(alpha: 0.52),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: AppColors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: Text(
                          'Ya tengo cuenta',
                          style: GoogleFonts.poppins(
                            color: AppColors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// CONTENIDO
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(22, 12, 22, 22),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),

                      /// HERO
                      _buildHeroCard(context),

                      const SizedBox(height: 26),

                      /// ACCESOS RÁPIDOS
                      _quickItem(
                        context,
                        Icons.menu_book_rounded,
                        'Evangelio del día',
                        'Lee, medita y profundiza en la Palabra.',
                        onTap: () => _push(
                          context,
                          const EvangelioScreen(),
                        ),
                      ),

                      _quickItem(
                        context,
                        Icons.auto_stories_rounded,
                        'Lecturas y liturgia',
                        'Consulta lecturas, salmos y calendario.',
                        onTap: () => _push(
                          context,
                          const LecturasScreen(),
                        ),
                      ),

                      _quickItem(
                        context,
                        Icons.church_rounded,
                        'Retiros públicos',
                        'Encuentra encuentros y experiencias vivenciales.',
                        onTap: () => _push(
                          context,
                          const RetirosScreen(),
                        ),
                      ),

                      const SizedBox(height: 18),

                      /// MENSAJE
                      _buildMessageCard(),
                    ],
                  ),
                ),
              ),

              /// CTA FINAL
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 0, 22, 18),
                child: Column(
                  children: [
                    OnboardingActionButton(
                      text: 'Crear cuenta',
                      onTap: () => _push(
                        context,
                        const RegisterScreen(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    OnboardingActionButton(
                      text: 'Iniciar sesión',
                      isPrimary: false,
                      onTap: () => _push(
                        context,
                        const LoginScreen(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
