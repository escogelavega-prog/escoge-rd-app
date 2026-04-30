import 'dart:ui';

import 'package:escoge/app/routes/app_page_route.dart';
import 'package:escoge/core/theme/app_backgrounds.dart';
import 'package:escoge/core/widgets/app_background.dart';
import 'package:escoge/core/widgets/app_header.dart';
import 'package:escoge/core/widgets/premium_menu_card.dart';
import 'package:escoge/core/widgets/section_title.dart';
import 'package:escoge/features/oracion/presentation/evangelio_screen.dart';
import 'package:escoge/features/oracion/presentation/lecturas_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class OracionScreen extends StatelessWidget {
  const OracionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground.spiritual(
        background: AppBackgrounds.oracion,
        scrollable: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  AppHeader(
                    title: 'Oración',
                    subtitle: 'Encuentro diario con Dios',
                    eyebrow: 'Vida espiritual',
                    height: 165,
                    centered: false,
                    bottomRadius: 38,
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFD4AF37).withValues(alpha: 0.20),
                            Colors.white.withValues(alpha: 0.04),
                          ],
                        ),
                        border: Border.all(
                          color: const Color(0x40D4AF37),
                        ),
                      ),
                      child: Icon(
                        PhosphorIcons.handsPraying(
                          PhosphorIconsStyle.light,
                        ),
                        color: const Color(0xFFD4AF37),
                        size: 24,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
                    child: Column(
                      children: [
                        const _HeroPrayerCard(),
                        const SizedBox(height: 28),
                        const SectionTitle(
                          title: 'Camino espiritual',
                          subtitle:
                              'Accede al Evangelio, lecturas, rosario y espacios de oración en una experiencia contemplativa.',
                          premium: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // =========================
            // MENÚ PRINCIPAL
            // =========================
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    PremiumMenuCard(
                      icon: PhosphorIcons.bookOpen(
                        PhosphorIconsStyle.light,
                      ),
                      title: 'Evangelio del día',
                      subtitle:
                          'Meditación diaria con lectura principal y reflexión.',
                      highlighted: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          AppPageRoute(
                            page: const EvangelioScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    PremiumMenuCard(
                      icon: PhosphorIcons.books(
                        PhosphorIconsStyle.light,
                      ),
                      title: 'Lecturas del día',
                      subtitle:
                          'Primera lectura, salmo y contexto litúrgico diario.',
                      onTap: () {
                        Navigator.push(
                          context,
                          AppPageRoute(
                            page: const LecturasScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    PremiumMenuCard(
                      icon: PhosphorIcons.circlesThreePlus(
                        PhosphorIconsStyle.light,
                      ),
                      title: 'Rosario',
                      subtitle: 'Ora los misterios con una experiencia guiada.',
                      onTap: () {
                        _showComingSoon(context, 'Rosario');
                      },
                    ),
                    const SizedBox(height: 14),
                    PremiumMenuCard(
                      icon: PhosphorIcons.heartStraight(
                        PhosphorIconsStyle.light,
                      ),
                      title: 'Peticiones',
                      subtitle:
                          'Presenta intenciones y acompaña a otros con oración.',
                      onTap: () {
                        _showComingSoon(context, 'Peticiones');
                      },
                    ),
                    const SizedBox(height: 24),
                    const _PrayerOfDayCard(),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _showComingSoon(BuildContext context, String modulo) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$modulo estará disponible muy pronto.'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF151B31),
      ),
    );
  }
}

// =========================
// HERO CARD
// =========================
class _HeroPrayerCard extends StatelessWidget {
  const _HeroPrayerCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0x33D4AF37),
                const Color(0x141A2342),
                Colors.white.withValues(alpha: 0.04),
              ],
            ),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: const Color(0x35D4AF37),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.24),
                blurRadius: 30,
                spreadRadius: -10,
                offset: const Offset(0, 14),
              ),
              BoxShadow(
                color: const Color(0x40D4AF37).withValues(alpha: 0.06),
                blurRadius: 30,
                spreadRadius: -12,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.10),
                  ),
                ),
                child: Text(
                  'Espacio sagrado',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFF1DE9E),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                '“Señor, enséñanos a orar.”',
                style: GoogleFonts.lora(
                  color: const Color(0xFFF8F5FA),
                  fontSize: 31,
                  fontWeight: FontWeight.w700,
                  height: 1.18,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Vive cada día desde la Palabra, el silencio, la contemplación y la comunión con la Iglesia.',
                style: GoogleFonts.poppins(
                  color: const Color(0xFFD5CEDF),
                  fontSize: 13.5,
                  height: 1.65,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(
                    Icons.wb_twilight_rounded,
                    color: Color(0xFFD4AF37),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Un momento diario puede transformar tu camino interior.',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFF8F5FA),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================
// ORACIÓN DEL DÍA
// =========================
class _PrayerOfDayCard extends StatelessWidget {
  const _PrayerOfDayCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: const Color(0x24D4AF37),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 26,
                spreadRadius: -12,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.light_mode_rounded,
                    color: Color(0xFFD4AF37),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Oración breve del día',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFF1DE9E),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Señor Jesús, guía mis pasos en este día, ilumina mi mente, fortalece mi corazón y hazme instrumento de tu paz.',
                style: GoogleFonts.lora(
                  color: const Color(0xFFF8F5FA),
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Que todo lo que viva hoy me acerque más a Ti.',
                style: GoogleFonts.poppins(
                  color: const Color(0xFFD5CEDF),
                  fontSize: 13,
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
