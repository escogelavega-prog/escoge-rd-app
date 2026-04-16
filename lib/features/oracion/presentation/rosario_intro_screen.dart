import 'dart:ui';

import 'package:escoge/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'rosario_rezo_screen.dart';

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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RosarioRezoScreen(tipoMisterio: tipoMisterio),
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
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.22),
                    Colors.black.withValues(alpha: 0.30),
                    Colors.black.withValues(alpha: 0.52),
                    Colors.black.withValues(alpha: 0.74),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: AppColors.primaryBlue.withValues(alpha: 0.10),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
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
                            border: Border.all(
                              color: AppColors.white.withValues(alpha: 0.08),
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: AppColors.white,
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
                            color: AppColors.white,
                            height: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 46),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _HeroIntroCard(
                          titulo: tituloMisterio,
                          dias: diasCorrespondientes,
                          descripcion: descripcion,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          '¿Cómo te vamos a guiar?',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Esta experiencia está pensada para ayudarte a rezar con claridad y calma.',
                          style: GoogleFonts.poppins(
                            fontSize: 12.8,
                            height: 1.5,
                            color: AppColors.white.withValues(alpha: 0.72),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const _GuideStepCard(
                          number: '1',
                          title: 'Te mostraremos el misterio',
                          subtitle:
                              'Verás el título, una imagen y una breve meditación para concentrarte.',
                        ),
                        const SizedBox(height: 10),
                        const _GuideStepCard(
                          number: '2',
                          title: 'Irás oración por oración',
                          subtitle:
                              'La app te indicará cuándo corresponde Padre Nuestro, Ave María, Gloria y Jaculatoria.',
                        ),
                        const SizedBox(height: 10),
                        const _GuideStepCard(
                          number: '3',
                          title: 'Avanzarás paso a paso',
                          subtitle:
                              'Solo toca “Siguiente” y la app te irá guiando durante todo el rosario.',
                        ),
                        const SizedBox(height: 14),
                        const _SupportCard(
                          text:
                              'No necesitas memorizar todo. Esta experiencia está pensada para acompañarte con calma y claridad.',
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () => _openRosario(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentBlue,
                              foregroundColor: AppColors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Comenzar Rosario',
                              style: GoogleFonts.poppins(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: AppColors.white.withValues(
                                alpha: 0.06,
                              ),
                              foregroundColor: AppColors.white,
                              side: BorderSide(
                                color: AppColors.white.withValues(alpha: 0.75),
                                width: 1.2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Elegir otro misterio',
                              style: GoogleFonts.poppins(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
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
}

class _HeroIntroCard extends StatelessWidget {
  const _HeroIntroCard({
    required this.titulo,
    required this.dias,
    required this.descripcion,
  });

  final String titulo;
  final String dias;
  final String descripcion;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: SizedBox(
        height: 220,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/hoy_la_iglesia.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.34, 0.68, 1.0],
                    colors: [
                      Colors.black.withValues(alpha: 0.14),
                      Colors.black.withValues(alpha: 0.22),
                      AppColors.primaryBlue.withValues(alpha: 0.50),
                      Colors.black.withValues(alpha: 0.84),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              top: 16,
              child: Text(
                'Vas a rezar',
                style: GoogleFonts.poppins(
                  color: AppColors.goldSoft,
                  fontSize: 12.6,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: GoogleFonts.lora(
                      color: AppColors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      height: 1.08,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Corresponde a: $dias',
                    style: GoogleFonts.poppins(
                      color: AppColors.white.withValues(alpha: 0.88),
                      fontSize: 13.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    descripcion,
                    style: GoogleFonts.poppins(
                      color: AppColors.white.withValues(alpha: 0.90),
                      fontSize: 13.2,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
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
}

class _GuideStepCard extends StatelessWidget {
  const _GuideStepCard({
    required this.number,
    required this.title,
    required this.subtitle,
  });

  final String number;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.07),
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
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.06),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  number,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.gold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 13.2,
                        height: 1.5,
                        color: AppColors.white.withValues(alpha: 0.74),
                        fontWeight: FontWeight.w500,
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

class _SupportCard extends StatelessWidget {
  final String text;

  const _SupportCard({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.06),
                  ),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.gold,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: 13.8,
                    height: 1.55,
                    color: AppColors.white.withValues(alpha: 0.76),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}