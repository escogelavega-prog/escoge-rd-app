import 'package:escoge/app/routes/app_page_route.dart';
import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/auth/presentation/login_screen.dart';
import 'package:escoge/features/auth/presentation/register_screen.dart';
import 'package:escoge/features/onboarding/widgets/onboarding_action_button.dart';
import 'package:escoge/features/onboarding/widgets/onboarding_background.dart';
import 'package:escoge/features/oracion/presentation/evangelio_screen.dart';
import 'package:escoge/features/oracion/presentation/lecturas_screen.dart';
import 'package:escoge/features/retiros/presentation/retiros_screen.dart';
import 'package:escoge/features/oracion/widgets/glass_spiritual_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PublicHomeScreen extends StatelessWidget {
  const PublicHomeScreen({super.key});

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
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.lumenGold.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: AppColors.lumenGold,
                size: 24,
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
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      color: AppColors.white.withValues(alpha: 0.72),
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white38,
              size: 15,
            ),
          ],
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
              /// 🔥 HEADER
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => _push(context, const LoginScreen()),
                      child: Text(
                        'Ya tengo cuenta',
                        style: GoogleFonts.poppins(
                          color: AppColors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// 🔥 CONTENIDO
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(22, 12, 22, 22),
                  child: Column(
                    children: [
                      const SizedBox(height: 18),

                      /// 🔥 HERO PREMIUM
                      GlassSpiritualCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    AppColors.lumenGold.withValues(alpha: 0.16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.lumenGold
                                        .withValues(alpha: 0.18),
                                    blurRadius: 18,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.explore_rounded,
                                color: AppColors.lumenGold,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Explora Escoge RD',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lora(
                                color: AppColors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Descubre contenido espiritual, vive el Evangelio del día y encuentra retiros disponibles.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: AppColors.white.withValues(alpha: 0.74),
                                fontSize: 14,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// 🔥 ACCESOS
                      _quickItem(
                        context,
                        Icons.menu_book_rounded,
                        'Evangelio del día',
                        'Lee y reflexiona con la Palabra.',
                        onTap: () => _push(context, const EvangelioScreen()),
                      ),
                      _quickItem(
                        context,
                        Icons.article_rounded,
                        'Lecturas y liturgia',
                        'Consulta el contenido completo.',
                        onTap: () => _push(context, const LecturasScreen()),
                      ),
                      _quickItem(
                        context,
                        Icons.church_rounded,
                        'Retiros públicos',
                        'Descubre próximos encuentros.',
                        onTap: () => _push(context, const RetirosScreen()),
                      ),

                      const SizedBox(height: 20),

                      /// 🔥 MENSAJE
                      GlassSpiritualCard(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Crea una cuenta para vivir una experiencia espiritual completa dentro de Escoge RD.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: AppColors.white.withValues(alpha: 0.85),
                            fontSize: 13,
                            height: 1.55,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// 🔥 CTA
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 0, 22, 18),
                child: Column(
                  children: [
                    OnboardingActionButton(
                      text: 'Crear cuenta',
                      onTap: () => _push(context, const RegisterScreen()),
                    ),
                    const SizedBox(height: 10),
                    OnboardingActionButton(
                      text: 'Iniciar sesión',
                      isPrimary: false,
                      onTap: () => _push(context, const LoginScreen()),
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
