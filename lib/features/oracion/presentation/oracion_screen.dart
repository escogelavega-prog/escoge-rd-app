import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'evangelio_screen.dart';
import 'lecturas_screen.dart';
import 'rosario_screen.dart';

class OracionScreen extends StatelessWidget {
  const OracionScreen({super.key});

  static const Color primaryBlue = Color(0xFF0B1E66);
  static const Color secondaryBlue = Color(0xFF12308E);
  static const Color gold = Color(0xFFD4AF37);
  static const Color softBackground = Color(0xFFF4F6FB);

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
              const SizedBox(height: 10),

              /// HEADER
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
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
                        color: Colors.white.withValues(alpha: .85),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

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
                    children: [
                      /// HERO PRINCIPAL
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

                      const SizedBox(height: 26),

                      /// ACCESO DIRECTO AL EVANGELIO
                      _ModuloCard(
                        titulo: 'Evangelio del Día',
                        subtitulo:
                            'Lee y medita la Palabra de Dios con una experiencia guiada.',
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

                      const SizedBox(height: 18),

                      /// SECCIÓN
                      Text(
                        'Tu camino de oración',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6D7693),
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// ROSARIO
                      _ModuloCard(
                        titulo: 'Santo Rosario',
                        subtitulo:
                            'Vive una experiencia guiada de oración contemplativa.',
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

                      const SizedBox(height: 18),

                      /// PRÓXIMAMENTE
                      Text(
                        'Próximamente',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6D7693),
                        ),
                      ),

                      const SizedBox(height: 12),

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
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Hoy en la Iglesia',
            style: GoogleFonts.lora(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Accede a las lecturas del día, contexto litúrgico y entrada directa al Evangelio.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              height: 1.6,
              color: Colors.white.withValues(alpha: .88),
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
                'Entrar',
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
                color: Colors.black.withValues(alpha: .05),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 52,
                width: 52,
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
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0B1E66),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitulo,
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        height: 1.5,
                        color: const Color(0xFF6D7693),
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
