import 'dart:ui';

import 'package:escoge/app/routes/app_page_route.dart';
import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/oracion/presentation/rosario_intro_screen.dart';
import 'package:escoge/features/oracion/widgets/glass_spiritual_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      AppPageRoute(
        page: RosarioIntroScreen(tipoMisterio: misterio),
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
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _topBar(context)),
                SliverToBoxAdapter(child: _description()),
                SliverToBoxAdapter(child: _hero(context, misterioDelDia)),
                SliverToBoxAdapter(child: _sectionTitle()),
                SliverToBoxAdapter(child: _options(context, misterioDelDia)),
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
              'Santo Rosario',
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

  Widget _description() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
      child: Text(
        'Una guía espiritual para acompañarte paso a paso, incluso si hoy es tu primera vez.',
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 13.2,
          color: AppColors.white.withValues(alpha: 0.82),
        ),
      ),
    );
  }

  Widget _hero(BuildContext context, String misterio) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: GlassSpiritualCard(
        radius: 30,
        blur: 18,
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: 220,
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
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
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
                      getTituloMisterio(misterio),
                      style: GoogleFonts.lora(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      getDiaTexto(misterio),
                      style: GoogleFonts.poppins(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _cta(context, misterio),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cta(BuildContext context, String misterio) {
    return GestureDetector(
      onTap: () => _openRosario(context, misterio),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: AppColors.lumenGold.withValues(alpha: 0.15),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome, color: AppColors.lumenGold),
            const SizedBox(width: 8),
            Text(
              'Comenzar ahora',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
      child: Text(
        'Elige un misterio',
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _options(BuildContext context, String misterioDelDia) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      child: Column(
        children: [
          _item(context, 'Misterios Gozosos', 'gozosos', misterioDelDia),
          const SizedBox(height: 10),
          _item(context, 'Misterios Dolorosos', 'dolorosos', misterioDelDia),
          const SizedBox(height: 10),
          _item(context, 'Misterios Gloriosos', 'gloriosos', misterioDelDia),
          const SizedBox(height: 10),
          _item(context, 'Misterios Luminosos', 'luminosos', misterioDelDia),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, String title, String key, String current) {
    final active = key == current;

    return GestureDetector(
      onTap: () => _openRosario(context, key),
      child: AnimatedScale(
        scale: active ? 1.02 : 1,
        duration: const Duration(milliseconds: 160),
        child: GlassSpiritualCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: active ? AppColors.lumenGoldBright : AppColors.white,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.lora(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
