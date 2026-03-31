import 'package:escoge/features/oracion/presentation/evangelio_screen.dart';
import 'package:escoge/features/oracion/services/lecturas_service.dart';
import 'package:escoge/features/oracion/widgets/evangelio_feature_image.dart';
import 'package:escoge/features/oracion/widgets/oracion_header.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LecturasScreen extends StatefulWidget {
  const LecturasScreen({super.key});

  @override
  State<LecturasScreen> createState() => _LecturasScreenState();
}

class _LecturasScreenState extends State<LecturasScreen> {
  late Future<LecturasDayData> _futureLecturas;

  @override
  void initState() {
    super.initState();
    _futureLecturas = LecturasService.getLecturasDelDia();
  }

  String safe(String? value) => (value ?? '').trim();

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

    const backgroundTop = Color(0xFF081B4B);
    const backgroundBottom = Color(0xFF0C2A66);
    const gold = Color(0xFFD4AF37);
    const softGold = Color(0xFFF4E7B2);
    const textPrimary = Color(0xFF10224F);
    const textBody = Color(0xFF2D3653);

    return Scaffold(
      backgroundColor: backgroundTop,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [backgroundTop, backgroundBottom],
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<LecturasDayData>(
            future: _futureLecturas,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: gold),
                );
              }

              if (snapshot.hasError || !snapshot.hasData) {
                return _ErrorState(
                  onRetry: () {
                    setState(() {
                      _futureLecturas = LecturasService.getLecturasDelDia();
                    });
                  },
                );
              }

              final data = snapshot.data!;

              final fecha = safe(data.fecha);
              final tiempoLiturgico = safe(data.tiempoLiturgico);
              final descripcionLiturgica = safe(data.descripcionLiturgica);

              final primeraLecturaCita = safe(data.primeraLecturaCita);
              final primeraLecturaContenido = safe(
                data.primeraLecturaContenido,
              );

              final salmoCita = safe(data.salmoCita);
              final salmoContenido = safe(data.salmoContenido);

              final segundaLecturaCita = safe(data.segundaLecturaCita);
              final segundaLecturaContenido = safe(
                data.segundaLecturaContenido,
              );

              final evangelioCita = safe(data.evangelioCita);
              final evangelioIntroduccion = safe(data.evangelioIntroduccion);
              final evangelioContenido = safe(data.evangelioContenido);
              final evangelioDestacado = safe(data.evangelioDestacado);

              final hasSegundaLectura = segundaLecturaCita.isNotEmpty &&
                  segundaLecturaContenido.isNotEmpty;

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: OracionHeader(
                      title: 'Lecturas del Día',
                      subtitle:
                          'La liturgia diaria para acompañar tu encuentro con Dios',
                      onBackTap: Navigator.canPop(context)
                          ? () => Navigator.pop(context)
                          : null,
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
                      child: EvangelioFeatureImage(
                        imagePath: 'assets/images/fondo2.png',
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
                      child: _LiturgiaEditorialCard(
                        fecha: fecha,
                        tiempoLiturgico: tiempoLiturgico,
                        descripcionLiturgica: descripcionLiturgica,
                        gold: gold,
                        softGold: softGold,
                        textPrimary: textPrimary,
                        textBody: textBody,
                      ),
                    ),
                  ),
                  if (primeraLecturaCita.isNotEmpty ||
                      primeraLecturaContenido.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: _ReadingCard(
                          label: 'Primera lectura',
                          cita: primeraLecturaCita,
                          contenido: primeraLecturaContenido,
                          gold: gold,
                          textPrimary: textPrimary,
                          textBody: textBody,
                        ),
                      ),
                    ),
                  if (salmoCita.isNotEmpty || salmoContenido.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: _ReadingCard(
                          label: 'Salmo',
                          cita: salmoCita,
                          contenido: salmoContenido,
                          gold: gold,
                          textPrimary: textPrimary,
                          textBody: textBody,
                          isPsalm: true,
                        ),
                      ),
                    ),
                  if (hasSegundaLectura)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: _ReadingCard(
                          label: 'Segunda lectura',
                          cita: segundaLecturaCita,
                          contenido: segundaLecturaContenido,
                          gold: gold,
                          textPrimary: textPrimary,
                          textBody: textBody,
                        ),
                      ),
                    ),
                  if (evangelioCita.isNotEmpty ||
                      evangelioIntroduccion.isNotEmpty ||
                      evangelioContenido.isNotEmpty ||
                      evangelioDestacado.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                        child: _EvangelioSpotlightCard(
                          cita: evangelioCita,
                          introduccion: evangelioIntroduccion,
                          contenido: evangelioContenido,
                          destacado: evangelioDestacado,
                          gold: gold,
                        ),
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 34),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const EvangelioScreen(),
                                  ),
                                );
                              },
                              child: const Text('Meditar Evangelio'),
                            ),
                          ),
                          if (Navigator.canPop(context)) ...[
                            const SizedBox(height: 14),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Volver',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white.withValues(alpha: 0.85),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LiturgiaEditorialCard extends StatelessWidget {
  const _LiturgiaEditorialCard({
    required this.fecha,
    required this.tiempoLiturgico,
    required this.descripcionLiturgica,
    required this.gold,
    required this.softGold,
    required this.textPrimary,
    required this.textBody,
  });

  final String fecha;
  final String tiempoLiturgico;
  final String descripcionLiturgica;
  final Color gold;
  final Color softGold;
  final Color textPrimary;
  final Color textBody;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFDF8EC), Color(0xFFF6EFD8)],
        ),
        border: Border.all(color: const Color(0xFFE6D7A6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hoy en la Iglesia',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF8A6A00),
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 10),
          if (fecha.isNotEmpty)
            Text(
              fecha,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF7A6840),
              ),
            ),
          const SizedBox(height: 12),
          Text(
            tiempoLiturgico.isNotEmpty ? tiempoLiturgico : 'Liturgia del día',
            style: GoogleFonts.lora(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              height: 1.15,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: 70,
            height: 4,
            decoration: BoxDecoration(
              color: gold,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          if (descripcionLiturgica.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              descripcionLiturgica,
              style: GoogleFonts.poppins(
                fontSize: 15,
                height: 1.7,
                color: textBody,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: softGold,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'Contenido litúrgico del día',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF8A6A00),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadingCard extends StatelessWidget {
  const _ReadingCard({
    required this.label,
    required this.cita,
    required this.contenido,
    required this.gold,
    required this.textPrimary,
    required this.textBody,
    this.isPsalm = false,
  });

  final String label;
  final String cita;
  final String contenido;
  final Color gold;
  final Color textPrimary;
  final Color textBody;
  final bool isPsalm;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTag(label: label, gold: gold),
          if (cita.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              cita,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
          ],
          if (contenido.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              contenido,
              style: isPsalm
                  ? GoogleFonts.lora(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.9,
                      color: textBody,
                    )
                  : GoogleFonts.lora(
                      fontSize: 16,
                      height: 1.9,
                      color: textBody,
                    ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EvangelioSpotlightCard extends StatelessWidget {
  const _EvangelioSpotlightCard({
    required this.cita,
    required this.introduccion,
    required this.contenido,
    required this.destacado,
    required this.gold,
  });

  final String cita;
  final String introduccion;
  final String contenido;
  final String destacado;
  final Color gold;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F2A66), Color(0xFF091D4F)],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTag(label: 'Evangelio del día', gold: gold, darkMode: true),
          if (cita.isNotEmpty) ...[
            const SizedBox(height: 18),
            Text(
              cita,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: gold,
              ),
            ),
          ],
          if (introduccion.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              introduccion,
              style: GoogleFonts.lora(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                height: 1.3,
                color: Colors.white,
              ),
            ),
          ],
          if (contenido.isNotEmpty) ...[
            const SizedBox(height: 18),
            Text(
              contenido,
              style: GoogleFonts.poppins(
                fontSize: 15,
                height: 1.9,
                color: Colors.white.withValues(alpha: 0.92),
              ),
            ),
          ],
          if (destacado.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF173673),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
              ),
              child: Text(
                destacado,
                style: GoogleFonts.lora(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 1.55,
                  color: gold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionTag extends StatelessWidget {
  const _SectionTag({
    required this.label,
    required this.gold,
    this.darkMode = false,
  });

  final String label;
  final Color gold;
  final bool darkMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color:
            darkMode ? gold.withValues(alpha: 0.16) : const Color(0xFFF4E7B2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: darkMode ? gold : const Color(0xFF7A5A00),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD4AF37);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.menu_book_rounded, size: 54, color: gold),
            const SizedBox(height: 18),
            Text(
              'No fue posible cargar las lecturas del día.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Intenta nuevamente para continuar con la liturgia diaria.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.6,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: gold,
                foregroundColor: const Color(0xFF081B4B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 14,
                ),
              ),
              child: Text(
                'Reintentar',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
