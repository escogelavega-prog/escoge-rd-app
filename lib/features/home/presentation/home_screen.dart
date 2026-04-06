import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:escoge/features/oracion/services/lecturas_service.dart';
import 'package:escoge/features/oracion/presentation/evangelio_screen.dart';
import 'package:escoge/features/oracion/presentation/lecturas_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onOpenOracion;
  final VoidCallback? onOpenRetiros;
  final VoidCallback? onOpenContenido;

  const HomeScreen({
    super.key,
    this.onOpenOracion,
    this.onOpenRetiros,
    this.onOpenContenido,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const gold = Color(0xFFD4AF37);
  static const softGold = Color(0xFFE8C76A);

  LecturasDayData? data;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await LecturasService.getLecturasDelDiaConFallback();
    if (!mounted) return;

    setState(() {
      data = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final evangelio = data?.evangelio ?? {};
    final reflexion = data?.reflexion ?? {};
    final santo = data?.santoDelDia ?? <String, dynamic>{};

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/backgrounds/home.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.35),
            ),
          ),
          SafeArea(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(color: softGold),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data?.titulo ?? 'Hoy en la Iglesia',
                          style: GoogleFonts.lora(
                            color: Colors.white,
                            fontSize: 28,
                            height: 1.2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data?.tiempoLiturgico ?? '',
                          style: GoogleFonts.poppins(
                            color: softGold,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 22),
                        _glassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Evangelio del día',
                                style: GoogleFonts.poppins(
                                  color: gold,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                evangelio['cita']?.toString() ?? '',
                                style: GoogleFonts.poppins(
                                  color: softGold,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                evangelio['titulo']?.toString() ?? '',
                                style: GoogleFonts.lora(
                                  color: Colors.white,
                                  fontSize: 20,
                                  height: 1.35,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 14),
                              _actionTextButton(
                                'Leer Evangelio',
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const EvangelioScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        _glassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Accesos rápidos',
                                style: GoogleFonts.poppins(
                                  color: gold,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: _miniActionChip(
                                      'Oración',
                                      Icons.auto_awesome,
                                      () {
                                        if (widget.onOpenOracion != null) {
                                          widget.onOpenOracion!();
                                          return;
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _miniActionChip(
                                      'Retiros',
                                      Icons.landscape_rounded,
                                      () {
                                        if (widget.onOpenRetiros != null) {
                                          widget.onOpenRetiros!();
                                          return;
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _miniActionChip(
                                      'Contenido',
                                      Icons.menu_book_rounded,
                                      () {
                                        if (widget.onOpenContenido != null) {
                                          widget.onOpenContenido!();
                                          return;
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _miniSecondaryButton(
                                'Lecturas del día',
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LecturasScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (santo.isNotEmpty)
                          _glassCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Santo del día',
                                  style: GoogleFonts.poppins(
                                    color: gold,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  santo['titulo']?.toString() ??
                                      santo['nombre']?.toString() ??
                                      '',
                                  style: GoogleFonts.lora(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  santo['texto']?.toString() ??
                                      santo['descripcion']?.toString() ??
                                      santo['contenido']?.toString() ??
                                      '',
                                  style: GoogleFonts.lora(
                                    color: Colors.white70,
                                    fontSize: 15,
                                    height: 1.55,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (santo.isNotEmpty) const SizedBox(height: 20),
                        _glassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reflexión',
                                style: GoogleFonts.poppins(
                                  color: gold,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                reflexion['texto']?.toString() ?? '',
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.lora(
                                  color: Colors.white,
                                  fontSize: 16,
                                  height: 1.55,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _actionTextButton(
                                'Ver completa',
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LecturasScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        _glassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Vive la experiencia',
                                style: GoogleFonts.lora(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Sumérgete en la oración, participa en retiros y fortalece tu fe cada día.',
                                style: GoogleFonts.lora(
                                  color: Colors.white70,
                                  fontSize: 15,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withOpacity(0.06),
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _actionTextButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: gold,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _miniSecondaryButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(0.06),
          border: Border.all(
            color: Colors.white.withOpacity(0.06),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wb_twilight_rounded, color: gold, size: 18),
            const SizedBox(width: 8),
            Text(
              text,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniActionChip(
    String text,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white.withOpacity(0.06),
          border: Border.all(
            color: Colors.white.withOpacity(0.06),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: gold, size: 20),
            const SizedBox(height: 8),
            Text(
              text,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
