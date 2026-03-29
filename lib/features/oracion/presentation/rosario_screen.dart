import 'package:escoge/features/oracion/presentation/rosario_intro_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RosarioScreen extends StatelessWidget {
  const RosarioScreen({super.key});

  static const Color softBackground = Color(0xFFF4F6FB);
  static const Color primaryBlue = Color(0xFF0B1E66);
  static const Color secondaryBlue = Color(0xFF1A3DAB);
  static const Color gold = Color(0xFFD4AF37);

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
      backgroundColor: softBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryBlue, secondaryBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(34),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.14),
                                ),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Santo Rosario',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lora(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 58),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Una guía espiritual para acompañarte paso a paso, incluso si hoy vas a rezarlo por primera vez.',
                        style: GoogleFonts.poppins(
                          color: Colors.white.withValues(alpha: 0.88),
                          fontSize: 14.5,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _RosarioDelDiaCard(
                    titulo: getTituloMisterio(misterioDelDia),
                    diaTexto: getDiaTexto(misterioDelDia),
                    onTap: () => _openRosario(context, misterioDelDia),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Elige un misterio',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'También puedes escoger manualmente el rosario que deseas rezar.',
                    style: GoogleFonts.poppins(
                      fontSize: 14.5,
                      color: const Color(0xFF6D7693),
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _RosarioOptionCard(
                    title: 'Misterios Gozosos',
                    subtitle: 'Lunes y sábado',
                    icon: Icons.wb_sunny_outlined,
                    highlighted: misterioDelDia == 'gozosos',
                    onTap: () => _openRosario(context, 'gozosos'),
                  ),
                  const SizedBox(height: 14),
                  _RosarioOptionCard(
                    title: 'Misterios Dolorosos',
                    subtitle: 'Martes y viernes',
                    icon: Icons.favorite_border_rounded,
                    highlighted: misterioDelDia == 'dolorosos',
                    onTap: () => _openRosario(context, 'dolorosos'),
                  ),
                  const SizedBox(height: 14),
                  _RosarioOptionCard(
                    title: 'Misterios Gloriosos',
                    subtitle: 'Miércoles y domingo',
                    icon: Icons.auto_awesome_rounded,
                    highlighted: misterioDelDia == 'gloriosos',
                    onTap: () => _openRosario(context, 'gloriosos'),
                  ),
                  const SizedBox(height: 14),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0B1E66), Color(0xFF1A3DAB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rosario del día',
            style: GoogleFonts.poppins(
              color: const Color(0xFFFFE8A3),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            titulo,
            style: GoogleFonts.lora(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hoy corresponde: $diaTexto',
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.88),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: const Color(0xFF1A2340),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                'Comenzar ahora',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
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
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: highlighted ? const Color(0xFFFFF8E8) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: highlighted
                  ? const Color(0xFFD4AF37)
                  : const Color(0xFFE5EAF5),
              width: highlighted ? 1.4 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: highlighted
                      ? const Color(0xFFD4AF37)
                      : const Color(0xFFF3F6FD),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: highlighted
                      ? const Color(0xFF1A2340)
                      : const Color(0xFF0B1E66),
                  size: 24,
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
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0B1E66),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        color: const Color(0xFF6D7693),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: highlighted
                    ? const Color(0xFFD4AF37)
                    : const Color(0xFF98A2BD),
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
