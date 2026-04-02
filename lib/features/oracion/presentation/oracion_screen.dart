import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'evangelio_screen.dart';
import 'lecturas_screen.dart';
import 'rosario_screen.dart';

class OracionScreen extends StatelessWidget {
  const OracionScreen({super.key});

  static const Color primaryBlue = Color(0xFF0B1E66);
  static const Color secondaryBlue = Color(0xFF1736A2);
  static const Color gold = Color(0xFFD4AF37);
  static const Color softBackground = Color(0xFFF3F6FD);
  static const Color textPrimary = Color(0xFF1B2559);
  static const Color textSecondary = Color(0xFF667085);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBackground,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [secondaryBlue, primaryBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Column(
                  children: [
                    Text(
                      'Oración',
                      style: GoogleFonts.lora(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tu espacio diario con Dios',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.85),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: softBackground,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 22, 16, 120),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _HeroOracionCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LecturasScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      _SectionHeader(
                        title: 'Accesos principales',
                        subtitle:
                            'Abre lo más importante de tu recorrido espiritual.',
                      ),
                      const SizedBox(height: 14),
                      _ModuloCard(
                        titulo: 'Evangelio del Día',
                        subtitulo:
                            'Lee y medita la Palabra de Dios con una experiencia cuidada y contemplativa.',
                        icon: Icons.menu_book_rounded,
                        iconBg: const Color(0xFFEAF0FF),
                        iconColor: primaryBlue,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EvangelioScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 14),
                      _ModuloCard(
                        titulo: 'Santo Rosario',
                        subtitulo:
                            'Vive una experiencia guiada de oración contemplativa y profunda.',
                        icon: Icons.auto_awesome,
                        iconBg: const Color(0xFFFFF7E3),
                        iconColor: gold,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RosarioScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      _SectionHeader(
                        title: 'Tu camino de oración',
                        subtitle:
                            'Una puerta simple y elegante hacia la liturgia y la vida espiritual.',
                      ),
                      const SizedBox(height: 14),
                      _MiniHighlightCard(
                        icon: Icons.chrome_reader_mode_rounded,
                        title: 'Hoy en la Iglesia',
                        subtitle:
                            'Accede a las lecturas del día, contexto litúrgico y entrada directa al Evangelio.',
                        buttonText: 'Entrar',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LecturasScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      _SectionHeader(
                        title: 'Próximamente',
                        subtitle:
                            'Módulos que formarán parte del ecosistema espiritual de Escoge RD.',
                      ),
                      const SizedBox(height: 14),
                      const _ComingSoonCard(
                        titulo: 'Oraciones',
                        subtitulo: 'Muy pronto disponibles.',
                        icon: Icons.self_improvement,
                      ),
                      const SizedBox(height: 14),
                      const _ComingSoonCard(
                        titulo: 'Reflexiones',
                        subtitulo: 'Muy pronto disponibles.',
                        icon: Icons.lightbulb_outline,
                      ),
                      const SizedBox(height: 14),
                      const _ComingSoonCard(
                        titulo: 'Peticiones',
                        subtitulo: 'Muy pronto disponibles.',
                        icon: Icons.favorite_border_rounded,
                      ),
                    ],
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

class _HeroOracionCard extends StatelessWidget {
  const _HeroOracionCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A3DAB), Color(0xFF0B1E66)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.wb_sunny_outlined,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Hoy en la Iglesia',
            style: GoogleFonts.lora(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Descubre las lecturas del día, el evangelio y el contexto litúrgico en una experiencia premium y cercana.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              height: 1.65,
              color: Colors.white.withOpacity(0.88),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 13,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD4AF37), Color(0xFFF1C76B)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Abrir lecturas',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0B1E66),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({
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
          style: GoogleFonts.poppins(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: OracionScreen.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 13,
            height: 1.55,
            color: OracionScreen.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ModuloCard extends StatelessWidget {
  const _ModuloCard({
    required this.titulo,
    required this.subtitulo,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.onTap,
  });

  final String titulo;
  final String subtitulo;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE2E8F5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 54,
                width: 54,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: GoogleFonts.lora(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0B1E66),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitulo,
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        height: 1.55,
                        color: const Color(0xFF6D7693),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Color(0xFF0B1E66),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniHighlightCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onTap;

  const _MiniHighlightCard({
    this.icon = Icons.menu_book_rounded,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF0FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: OracionScreen.primaryBlue,
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
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: OracionScreen.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    height: 1.55,
                    color: OracionScreen.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: OracionScreen.primaryBlue,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      buttonText,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
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

class _ComingSoonCard extends StatelessWidget {
  const _ComingSoonCard({
    required this.titulo,
    required this.subtitulo,
    required this.icon,
  });

  final String titulo;
  final String subtitulo;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F5)),
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF3FB),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF7B86A7),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: GoogleFonts.lora(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF4B5678),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitulo,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    height: 1.5,
                    color: const Color(0xFF7B86A7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFFE2E8F5)),
            ),
            child: Text(
              'Pronto',
              style: GoogleFonts.poppins(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF7B86A7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
