import 'package:escoge/features/auth/presentation/login_screen.dart';
import 'package:escoge/features/auth/presentation/register_screen.dart';
import 'package:escoge/features/onboarding/widgets/onboarding_action_button.dart';
import 'package:escoge/features/onboarding/widgets/onboarding_background.dart';
import 'package:escoge/features/oracion/presentation/evangelio_screen.dart';
import 'package:escoge/features/oracion/presentation/lecturas_screen.dart';
import 'package:escoge/features/retiros/presentation/retiros_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PublicHomeScreen extends StatelessWidget {
  const PublicHomeScreen({super.key});

  static const Color gold = Color(0xFFD4AF37);

  Widget _quickItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: gold.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: gold,
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
                          color: Colors.white,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
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
        ),
      ),
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingBackground(
        child: SafeArea(
          child: Column(
            children: [
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
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(22, 12, 22, 22),
                  child: Column(
                    children: [
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(26),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFF101935).withValues(alpha: 0.76),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.14),
                              blurRadius: 24,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 66,
                              height: 66,
                              decoration: BoxDecoration(
                                color: gold.withValues(alpha: 0.14),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.explore_rounded,
                                color: gold,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Explora Escoge RD',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lora(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Descubre contenido espiritual, vive la experiencia del Evangelio diario y conoce los próximos retiros disponibles para ti.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 14,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 26),
                            _quickItem(
                              context,
                              Icons.menu_book_rounded,
                              'Evangelio del día',
                              'Lee y reflexiona con la Palabra.',
                              onTap: () => _push(
                                context,
                                const EvangelioScreen(),
                              ),
                            ),
                            _quickItem(
                              context,
                              Icons.article_rounded,
                              'Lecturas y liturgia',
                              'Consulta el contenido diario completo.',
                              onTap: () => _push(
                                context,
                                const LecturasScreen(),
                              ),
                            ),
                            _quickItem(
                              context,
                              Icons.church_rounded,
                              'Retiros públicos',
                              'Conoce actividades y próximos encuentros.',
                              onTap: () => _push(
                                context,
                                const RetirosScreen(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: gold.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: gold.withValues(alpha: 0.14),
                          ),
                        ),
                        child: Text(
                          'Crea una cuenta para desbloquear tu camino espiritual completo dentro de Escoge RD.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white.withValues(alpha: 0.90),
                            fontSize: 13,
                            height: 1.55,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
