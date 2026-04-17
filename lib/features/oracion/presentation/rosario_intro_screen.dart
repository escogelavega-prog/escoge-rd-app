import 'package:escoge/app/routes/app_page_route.dart';
import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/oracion/presentation/rosario_rezo_screen.dart';
import 'package:escoge/features/oracion/widgets/glass_spiritual_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class RosarioIntroScreen extends StatelessWidget {
  const RosarioIntroScreen({
    super.key,
    required this.tipoMisterio,
  });

  final String tipoMisterio;

  String get tituloMisterio {
    switch (tipoMisterio) {
      case 'gozosos':
        return 'Misterios Gozosos';
      case 'dolorosos':
        return 'Misterios Dolorosos';
      case 'gloriosos':
        return 'Misterios Gloriosos';
      case 'luminosos':
        return 'Misterios Luminosos';
      default:
        return 'Misterios Gozosos';
    }
  }

  String get diasCorrespondientes {
    switch (tipoMisterio) {
      case 'gozosos':
        return 'Lunes y sábado';
      case 'dolorosos':
        return 'Martes y viernes';
      case 'gloriosos':
        return 'Miércoles y domingo';
      case 'luminosos':
        return 'Jueves';
      default:
        return 'Lunes y sábado';
    }
  }

  String get descripcion {
    switch (tipoMisterio) {
      case 'gozosos':
        return 'Meditan los momentos de alegría en la vida de Jesús y María.';
      case 'dolorosos':
        return 'Meditan la pasión y el sufrimiento de Cristo por amor a nosotros.';
      case 'gloriosos':
        return 'Meditan la victoria de Cristo y la gloria de María.';
      case 'luminosos':
        return 'Meditan momentos claves de la vida pública de Jesús.';
      default:
        return 'Meditan los momentos de alegría en la vida de Jesús y María.';
    }
  }

  void _openRosario(BuildContext context) {
    HapticFeedback.mediumImpact();

    Navigator.push(
      context,
      AppPageRoute(
        page: RosarioRezoScreen(
          tipoMisterio: tipoMisterio,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/backgrounds/lecturas.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.25),
                    Colors.black.withValues(alpha: 0.85),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _topBar(context),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        _hero(),
                        const SizedBox(height: 20),
                        _guideSection(),
                        const SizedBox(height: 18),
                        _support(),
                        const SizedBox(height: 20),
                        _primaryButton(context),
                        const SizedBox(height: 10),
                        _secondaryButton(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withValues(alpha: 0.08),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Guía del Rosario',
              textAlign: TextAlign.center,
              style: GoogleFonts.lora(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 46),
        ],
      ),
    );
  }

  Widget _hero() {
    return GlassSpiritualCard(
      radius: 30,
      blur: 18,
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 230,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/hoy_la_iglesia.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.15),
                      Colors.black.withValues(alpha: 0.85),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tituloMisterio,
                    style: GoogleFonts.lora(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    diasCorrespondientes,
                    style: GoogleFonts.poppins(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    descripcion,
                    style: GoogleFonts.poppins(
                      color: Colors.white.withValues(alpha: 0.85),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _guideSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Cómo te vamos a guiar?',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        _guideCard('1', 'Verás el misterio', 'Imagen + meditación breve'),
        const SizedBox(height: 10),
        _guideCard('2', 'Oración guiada', 'Paso a paso claro'),
        const SizedBox(height: 10),
        _guideCard('3', 'Avance continuo', 'Solo toca siguiente'),
      ],
    );
  }

  Widget _guideCard(String number, String title, String subtitle) {
    return GlassSpiritualCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.lumenGold.withValues(alpha: 0.2),
            child: Text(number),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _support() {
    return GlassSpiritualCard(
      child: Text(
        'No necesitas memorizar todo. Te guiamos completamente.',
        style: GoogleFonts.poppins(color: Colors.white70),
      ),
    );
  }

  Widget _primaryButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _openRosario(context),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [
              AppColors.lumenGold,
              AppColors.lumenGoldBright,
            ],
          ),
        ),
        child: Center(
          child: Text(
            'Comenzar Rosario',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _secondaryButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
        ),
        child: Center(
          child: Text(
            'Elegir otro misterio',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
