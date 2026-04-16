import 'dart:ui';

import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/oracion/presentation/rosario_intro_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RosarioScreen extends StatelessWidget {
  const RosarioScreen({super.key});

  String getMisterioDelDia(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
      case DateTime.saturday:
        return 'gozosos';
      case DateTime.tuesday:
      case DateTime.friday:
        return 'dolorosos';
      case DateTime.wednesday:
      case DateTime.sunday:
        return 'gloriosos';
      case DateTime.thursday:
        return 'luminosos';
      default:
        return 'gozosos';
    }
  }

  String getTituloMisterio(String key) {
    switch (key) {
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

  String getDiaTexto(String key) {
    switch (key) {
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

  void _openRosario(BuildContext context, String misterio) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RosarioIntroScreen(tipoMisterio: misterio),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final misterioDelDia = getMisterioDelDia(DateTime.now());

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
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
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
                            'Santo Rosario',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lora(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 46),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
                    child: Text(
                      'Una guía espiritual para acompañarte paso a paso, incluso si hoy vas a rezarlo por primera vez.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13.2,
                        color: AppColors.white.withValues(alpha: 0.82),
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 96),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _RosarioDelDiaCard(
                          titulo: getTituloMisterio(misterioDelDia),
                          diaTexto: getDiaTexto(misterioDelDia),
                          onTap: () => _openRosario(context, misterioDelDia),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Elige un misterio',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'También puedes escoger manualmente el rosario que deseas rezar.',
                          style: GoogleFonts.poppins(
                            fontSize: 12.8,
                            height: 1.5,
                            color: AppColors.white.withValues(alpha: 0.72),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _RosarioOptionCard(
                          title: 'Misterios Gozosos',
                          subtitle: 'Lunes y sábado',
                          icon: Icons.wb_sunny_outlined,
                          highlighted: misterioDelDia == 'gozosos',
                          onTap: () => _openRosario(context, 'gozosos'),
                        ),
                        const SizedBox(height: 10),
                        _RosarioOptionCard(
                          title: 'Misterios Dolorosos',
                          subtitle: 'Martes y viernes',
                          icon: Icons.favorite_border_rounded,
                          highlighted: misterioDelDia == 'dolorosos',
                          onTap: () => _openRosario(context, 'dolorosos'),
                        ),
                        const SizedBox(height: 10),
                        _RosarioOptionCard(
                          title: 'Misterios Gloriosos',
                          subtitle: 'Miércoles y domingo',
                          icon: Icons.auto_awesome_rounded,
                          highlighted: misterioDelDia == 'gloriosos',
                          onTap: () => _openRosario(context, 'gloriosos'),
                        ),
                        const SizedBox(height: 10),
                        _RosarioOptionCard(
                          title: 'Misterios Luminosos',
                          subtitle: 'Jueves',
                          icon: Icons.light_mode_outlined,
                          highlighted: misterioDelDia == 'luminosos',
                          onTap: () => _openRosario(context, 'luminosos'),
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

class _RosarioDelDiaCard extends StatelessWidget {
  const _RosarioDelDiaCard({
    required this.titulo,
    required this.diaTexto,
    this.onTap,
  });

  final String titulo;
  final String diaTexto;
  final VoidCallback? onTap;

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
            Positioned(
              left: 18,
              right: 18,
              top: 16,
              child: Text(
                'Rosario del día',
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
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Hoy corresponde: $diaTexto',
                    style: GoogleFonts.poppins(
                      color: AppColors.white.withValues(alpha: 0.88),
                      fontSize: 13.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _HeroActionButton(
                    label: 'Comenzar ahora',
                    onTap: onTap,
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

class _HeroActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _HeroActionButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_awesome,
              color: AppColors.gold,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: AppColors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RosarioOptionCard extends StatelessWidget {
  const _RosarioOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.highlighted,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool highlighted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: highlighted ? 0.10 : 0.07),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: highlighted
                  ? AppColors.gold.withValues(alpha: 0.55)
                  : AppColors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: highlighted
                      ? AppColors.gold.withValues(alpha: 0.16)
                      : AppColors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: highlighted ? AppColors.gold : AppColors.white,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.lora(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12.8,
                        color: AppColors.white.withValues(alpha: 0.72),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: highlighted
                    ? AppColors.gold
                    : AppColors.white.withValues(alpha: 0.74),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
