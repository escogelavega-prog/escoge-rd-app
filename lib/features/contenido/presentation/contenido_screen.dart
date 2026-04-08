import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:escoge/core/theme/app_backgrounds.dart';
import 'package:escoge/core/widgets/app_background.dart';
import 'package:escoge/core/widgets/app_card.dart';

class ContenidoScreen extends StatelessWidget {
  const ContenidoScreen({super.key});

  static const Color primaryBlue = Color(0xFF0B1E66);
  static const Color gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        background: AppBackgrounds.home,
        overlayOpacity: 0.18,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _ContenidoHeader(),
                SizedBox(height: 22),
                _ContenidoIntroCard(),
                SizedBox(height: 26),
                _SectionTitle(
                  title: 'Explora',
                  subtitle:
                      'Historia, noticias y materiales que fortalecen la identidad del movimiento.',
                ),
                SizedBox(height: 14),
                _ContentCategoryCard(
                  icon: Icons.campaign_rounded,
                  title: 'Noticias del movimiento',
                  subtitle:
                      'Novedades, actividades y actualizaciones de Escoge RD.',
                ),
                SizedBox(height: 14),
                _ContentCategoryCard(
                  icon: Icons.account_balance_rounded,
                  title: 'Historia del movimiento',
                  subtitle:
                      'Conoce nuestros inicios y el camino recorrido en República Dominicana.',
                ),
                SizedBox(height: 14),
                _ContentCategoryCard(
                  icon: Icons.photo_library_rounded,
                  title: 'Multimedia y testimonios',
                  subtitle:
                      'Fotos, videos y experiencias que inspiran y conectan.',
                ),
                SizedBox(height: 26),
                _SectionTitle(
                  title: 'Próximamente',
                  subtitle:
                      'Nuevos contenidos institucionales y formativos seguirán enriqueciendo este espacio.',
                ),
                SizedBox(height: 14),
                _FutureCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContenidoHeader extends StatelessWidget {
  const _ContenidoHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contenido',
          style: GoogleFonts.lora(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Historia, noticias y recursos del movimiento.',
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.white.withOpacity(0.80),
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _ContenidoIntroCard extends StatelessWidget {
  const _ContenidoIntroCard();

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      borderRadius: 32,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.explore_rounded,
              color: Color(0xFFD4AF37),
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Descubre más de Escoge RD',
                  style: GoogleFonts.lora(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Accede a contenido institucional, materiales del movimiento y experiencias que fortalecen la comunidad.',
                  style: GoogleFonts.poppins(
                    fontSize: 13.2,
                    height: 1.55,
                    color: Colors.white.withOpacity(0.82),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentCategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ContentCategoryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      onTap: () {},
      borderRadius: 28,
      child: Row(
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              icon,
              color: ContenidoScreen.gold,
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
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12.4,
                    height: 1.45,
                    color: Colors.white.withOpacity(0.76),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white,
            size: 16,
          ),
        ],
      ),
    );
  }
}

class _FutureCard extends StatelessWidget {
  const _FutureCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      borderRadius: 30,
      color: Colors.white.withOpacity(0.92),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: ContenidoScreen.gold.withOpacity(0.16),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.public_rounded,
              color: ContenidoScreen.gold,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Diócesis de República Dominicana',
                  style: GoogleFonts.poppins(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: ContenidoScreen.primaryBlue,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'En una próxima actualización podrás conocer una breve historia de las distintas diócesis del país.',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.lora(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 12.5,
            color: Colors.white.withOpacity(0.75),
            height: 1.45,
          ),
        ),
      ],
    );
  }
}
