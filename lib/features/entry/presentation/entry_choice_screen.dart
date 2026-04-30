import 'package:escoge/core/constants/app_assets.dart';
import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/auth/presentation/login_screen.dart';
import 'package:escoge/features/auth/presentation/register_screen.dart';
import 'package:escoge/features/entry/presentation/public_home_screen.dart';
import 'package:escoge/features/onboarding/widgets/onboarding_action_button.dart';
import 'package:escoge/features/onboarding/widgets/onboarding_background.dart';
import 'package:escoge/features/onboarding/widgets/onboarding_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EntryChoiceScreen extends StatelessWidget {
  const EntryChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lumenBackground,
      body: OnboardingBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OnboardingCard(
                  child: Column(
                    children: [
                      Container(
                        width: 122,
                        height: 122,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.lumenCard.withValues(alpha: 0.82),
                          border: Border.all(
                            color: AppColors.lumenGold.withValues(alpha: 0.34),
                            width: 1.4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.lumenGold.withValues(
                                alpha: 0.16,
                              ),
                              blurRadius: 26,
                              spreadRadius: -6,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            AppAssets.logoMovimiento,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Container(
                                color: AppColors.lumenCard,
                                child: const Icon(
                                  Icons.auto_awesome_rounded,
                                  color: AppColors.lumenGold,
                                  size: 54,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 26),
                      Text(
                        '¿Cómo deseas\nentrar?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          height: 1.28,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Explora contenido espiritual o inicia sesión para acceder a las funciones disponibles según tu rol.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 15,
                          height: 1.62,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 42),
                OnboardingActionButton(
                  text: 'Explorar primero',
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const PublicHomeScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 22),
                OnboardingActionButton(
                  text: 'Iniciar sesión',
                  isPrimary: false,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Crear cuenta',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
