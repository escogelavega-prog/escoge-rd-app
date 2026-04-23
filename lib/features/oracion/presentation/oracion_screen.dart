import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:escoge/features/oracion/presentation/evangelio_screen.dart';
import 'package:escoge/features/oracion/presentation/lecturas_screen.dart';

class OracionScreen extends StatelessWidget {
  const OracionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundTop = Color(0xFF07122A);
    const backgroundBottom = Color(0xFF0D1B3D);
    const gold = Color(0xFFD4AF37);
    const softGold = Color(0xFFE8C96A);
    const textPrimary = Color(0xFFF8F6F1);
    const textSecondary = Color(0xFFCAD3E3);
    const glass = Color(0x1AFFFFFF);
    const glassBorder = Color(0x26FFFFFF);

    return Scaffold(
      backgroundColor: backgroundBottom,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              backgroundTop,
              backgroundBottom,
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _TopHeader(),
                      const SizedBox(height: 24),
                      _HeroPrayerCard(
                        gold: gold,
                        softGold: softGold,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'Camino espiritual',
                        style: GoogleFonts.lora(
                          color: textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Accede al Evangelio, lecturas, rosario y espacios de oración en una experiencia contemplativa y ordenada.',
                        style: GoogleFonts.poppins(
                          color: textSecondary,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _GlassOptionCard(
                      icon: Icons.menu_book_rounded,
                      title: 'Evangelio del día',
                      subtitle:
                          'Meditación diaria con lectura principal y reflexión.',
                      badge: 'Hoy',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EvangelioScreen(),
                          ),
                        );
                      },
                      gold: gold,
                      softGold: softGold,
                      glass: glass,
                      glassBorder: glassBorder,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                    const SizedBox(height: 14),
                    _GlassOptionCard(
                      icon: Icons.auto_stories_rounded,
                      title: 'Lecturas del día',
                      subtitle:
                          'Primera lectura, salmo, segunda lectura y contexto litúrgico.',
                      badge: 'Liturgia',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LecturasScreen(),
                          ),
                        );
                      },
                      gold: gold,
                      softGold: softGold,
                      glass: glass,
                      glassBorder: glassBorder,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                    const SizedBox(height: 14),
                    _GlassOptionCard(
                      icon: Icons.brightness_3_rounded,
                      title: 'Rosario',
                      subtitle:
                          'Ora los misterios con una experiencia guiada y profunda.',
                      badge: 'Oración',
                      onTap: () {
                        _showComingSoon(context, 'Rosario');
                      },
                      gold: gold,
                      softGold: softGold,
                      glass: glass,
                      glassBorder: glassBorder,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                    const SizedBox(height: 14),
                    _GlassOptionCard(
                      icon: Icons.favorite_outline_rounded,
                      title: 'Peticiones',
                      subtitle:
                          'Presenta intenciones y acompaña a otros con tu oración.',
                      badge: 'Comunidad',
                      onTap: () {
                        _showComingSoon(context, 'Peticiones');
                      },
                      gold: gold,
                      softGold: softGold,
                      glass: glass,
                      glassBorder: glassBorder,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                    const SizedBox(height: 22),
                    _PrayerOfDayCard(
                      gold: gold,
                      softGold: softGold,
                      glass: glass,
                      glassBorder: glassBorder,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _showComingSoon(BuildContext context, String modulo) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$modulo estará disponible muy pronto.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader();

  @override
  Widget build(BuildContext context) {
    const textPrimary = Color(0xFFF8F6F1);
    const textSecondary = Color(0xFFCAD3E3);
    const gold = Color(0xFFD4AF37);

    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [
                Color(0x19D4AF37),
                Color(0x14FFFFFF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: const Color(0x22FFFFFF)),
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            color: gold,
            size: 22,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Oración',
                style: GoogleFonts.lora(
                  color: textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Encuentro diario con Dios',
                style: GoogleFonts.poppins(
                  color: textSecondary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroPrayerCard extends StatelessWidget {
  final Color gold;
  final Color softGold;
  final Color textPrimary;
  final Color textSecondary;

  const _HeroPrayerCard({
    required this.gold,
    required this.softGold,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0x33D4AF37),
            Color(0x14FFFFFF),
            Color(0x08FFFFFF),
          ],
        ),
        border: Border.all(color: const Color(0x22FFFFFF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0x14FFFFFF),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0x20FFFFFF)),
            ),
            child: Text(
              'Espacio sagrado',
              style: GoogleFonts.poppins(
                color: softGold,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '“Señor, enséñanos a orar.”',
            style: GoogleFonts.lora(
              color: textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Vive cada día desde la Palabra, el silencio, la contemplación y la comunión con la Iglesia.',
            style: GoogleFonts.poppins(
              color: textSecondary,
              fontSize: 13.5,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Icon(Icons.wb_twilight_rounded, color: gold, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Un momento diario puede transformar tu camino interior.',
                  style: GoogleFonts.poppins(
                    color: textPrimary.withOpacity(0.92),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GlassOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String badge;
  final VoidCallback onTap;
  final Color gold;
  final Color softGold;
  final Color glass;
  final Color glassBorder;
  final Color textPrimary;
  final Color textSecondary;

  const _GlassOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.onTap,
    required this.gold,
    required this.softGold,
    required this.glass,
    required this.glassBorder,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Ink(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: glass,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: glassBorder),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x18000000),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0x26D4AF37),
                          Color(0x12FFFFFF),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: const Color(0x24FFFFFF)),
                    ),
                    child: Icon(icon, color: gold, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: GoogleFonts.poppins(
                                  color: textPrimary,
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0x14FFFFFF),
                                borderRadius: BorderRadius.circular(999),
                                border:
                                    Border.all(color: const Color(0x18FFFFFF)),
                              ),
                              child: Text(
                                badge,
                                style: GoogleFonts.poppins(
                                  color: softGold,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          subtitle,
                          style: GoogleFonts.poppins(
                            color: textSecondary,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w400,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: textPrimary.withOpacity(0.78),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PrayerOfDayCard extends StatelessWidget {
  final Color gold;
  final Color softGold;
  final Color glass;
  final Color glassBorder;
  final Color textPrimary;
  final Color textSecondary;

  const _PrayerOfDayCard({
    required this.gold,
    required this.softGold,
    required this.glass,
    required this.glassBorder,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: glass,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: glassBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.light_mode_rounded, color: gold, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Oración breve del día',
                    style: GoogleFonts.poppins(
                      color: softGold,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Señor Jesús, guía mis pasos en este día, ilumina mi mente, fortalece mi corazón y hazme instrumento de tu paz.',
                style: GoogleFonts.lora(
                  color: textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Que todo lo que viva hoy me acerque más a Ti.',
                style: GoogleFonts.poppins(
                  color: textSecondary,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
