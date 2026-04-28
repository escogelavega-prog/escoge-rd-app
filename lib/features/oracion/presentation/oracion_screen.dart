import 'package:escoge/app/routes/app_page_route.dart';
import 'package:escoge/core/theme/app_backgrounds.dart';
import 'package:escoge/core/widgets/app_background.dart';
import 'package:escoge/core/widgets/app_header.dart';
import 'package:escoge/core/widgets/premium_menu_card.dart';
import 'package:escoge/core/widgets/section_title.dart';
import 'package:escoge/features/oracion/presentation/evangelio_screen.dart';
import 'package:escoge/features/oracion/presentation/lecturas_screen.dart';
import 'package:flutter/material.dart';
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
                    height: 150,
                    centered: false,
                    bottomRadius: 34,
                    leading: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.06),
                        border: Border.all(
                          color: const Color(0x2AFFFFFF),
                        ),
                      ),
                      child: Icon(
                        PhosphorIcons.handsPraying(
                          PhosphorIconsStyle.light,
                        ),
                        color: const Color(0xFFD4AF37),
                        size: 22,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
                    child: Column(
                      children: [
                        _HeroPrayerCard(),
                        const SizedBox(height: 26),
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
                    _PrayerOfDayCard(),
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
      ),
    );
  }
}

// =========================
// HERO CARD
// =========================
class _HeroPrayerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0x33D4AF37),
            Color(0x14FFFFFF),
            Color(0x08FFFFFF),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0x26FFFFFF),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 24,
            spreadRadius: -8,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.10),
              ),
            ),
            child: const Text(
              'Espacio sagrado',
              style: TextStyle(
                color: Color(0xFFF1DE9E),
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '“Señor, enséñanos a orar.”',
            style: TextStyle(
              color: Color(0xFFF8F5FA),
              fontSize: 28,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Vive cada día desde la Palabra, el silencio, la contemplación y la comunión con la Iglesia.',
            style: TextStyle(
              color: Color(0xFFD5CEDF),
              fontSize: 13.5,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: const [
              Icon(
                Icons.wb_twilight_rounded,
                color: Color(0xFFD4AF37),
                size: 18,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Un momento diario puede transformar tu camino interior.',
                  style: TextStyle(
                    color: Color(0xFFF8F5FA),
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

// =========================
// ORACIÓN DEL DÍA
// =========================
class _PrayerOfDayCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.10),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.light_mode_rounded,
                color: Color(0xFFD4AF37),
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'Oración breve del día',
                style: TextStyle(
                  color: Color(0xFFF1DE9E),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          Text(
            'Señor Jesús, guía mis pasos en este día, ilumina mi mente, fortalece mi corazón y hazme instrumento de tu paz.',
            style: TextStyle(
              color: Color(0xFFF8F5FA),
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.55,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Que todo lo que viva hoy me acerque más a Ti.',
            style: TextStyle(
              color: Color(0xFFD5CEDF),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
