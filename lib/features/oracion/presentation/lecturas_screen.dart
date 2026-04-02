import 'package:escoge/features/oracion/services/liturgia_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LecturasScreen extends StatefulWidget {
  const LecturasScreen({super.key});

  @override
  State<LecturasScreen> createState() => _LecturasScreenState();
}

class _LecturasScreenState extends State<LecturasScreen> {
  final LiturgiaService _liturgiaService = LiturgiaService();

  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _liturgia;

  @override
  void initState() {
    super.initState();
    _cargarLiturgia();
  }

  Future<void> _cargarLiturgia() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final data = await _liturgiaService.obtenerLiturgiaDelDia();

      if (!mounted) return;

      setState(() {
        _liturgia = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error =
            'No se pudieron cargar las lecturas del día. Verifica Firestore y tu conexión.';
        _isLoading = false;
      });
    }
  }

  String _safeText(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    return value.toString();
  }

  Map<String, dynamic>? _safeMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    const deepBlue = Color(0xFF0B1E66);
    const royalBlue = Color(0xFF1736A2);
    const softBlueBg = Color(0xFFF3F6FD);
    const gold = Color(0xFFD4AF37);
    const white = Colors.white;
    const textPrimary = Color(0xFF1B2559);
    const textSecondary = Color(0xFF667085);

    final primeraLectura = _safeMap(_liturgia?['primeraLectura']);
    final salmo = _safeMap(_liturgia?['salmo']);
    final segundaLectura = _safeMap(_liturgia?['segundaLectura']);
    final evangelio = _safeMap(_liturgia?['evangelio']);

    final tituloDia = _safeText(
      _liturgia?['tituloDia'],
      fallback: 'Lecturas del día',
    );
    final celebracion = _safeText(_liturgia?['celebracion']);
    final tiempoLiturgico = _safeText(_liturgia?['tiempoLiturgico']);
    final colorLiturgico = _safeText(_liturgia?['colorLiturgico']);

    return Scaffold(
      backgroundColor: softBlueBg,
      body: RefreshIndicator(
        onRefresh: _cargarLiturgia,
        color: deepBlue,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [deepBlue, royalBlue],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).maybePop(),
                              child: Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: white.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: white.withOpacity(0.10),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: white,
                                  size: 18,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Oración',
                                    style: GoogleFonts.poppins(
                                      color: white.withOpacity(0.75),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Lecturas del día',
                                    style: GoogleFonts.poppins(
                                      color: white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: gold.withOpacity(0.16),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'Hoy',
                                style: GoogleFonts.poppins(
                                  color: gold,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            gradient: LinearGradient(
                              colors: [
                                white.withOpacity(0.10),
                                white.withOpacity(0.04),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: white.withOpacity(0.10),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: gold.withOpacity(0.16),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  tituloDia,
                                  style: GoogleFonts.poppins(
                                    color: gold,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                celebracion.isNotEmpty
                                    ? celebracion
                                    : 'Liturgia del día',
                                style: GoogleFonts.lora(
                                  color: white,
                                  fontSize: 27,
                                  height: 1.25,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  if (tiempoLiturgico.isNotEmpty)
                                    _TopChip(text: tiempoLiturgico),
                                  if (colorLiturgico.isNotEmpty)
                                    _TopChip(text: 'Color: $colorLiturgico'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, -14),
                child: Container(
                  decoration: const BoxDecoration(
                    color: softBlueBg,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
                    child: _buildBody(
                      primeraLectura: primeraLectura,
                      salmo: salmo,
                      segundaLectura: segundaLectura,
                      evangelio: evangelio,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      deepBlue: deepBlue,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody({
    required Map<String, dynamic>? primeraLectura,
    required Map<String, dynamic>? salmo,
    required Map<String, dynamic>? segundaLectura,
    required Map<String, dynamic>? evangelio,
    required Color textPrimary,
    required Color textSecondary,
    required Color deepBlue,
  }) {
    const white = Colors.white;

    if (_isLoading) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            const CircularProgressIndicator(
              color: Color(0xFF0B1E66),
              strokeWidth: 2.5,
            ),
            const SizedBox(height: 16),
            Text(
              'Cargando lecturas del día...',
              style: GoogleFonts.poppins(
                color: textSecondary,
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 38,
              color: Color(0xFF0B1E66),
            ),
            const SizedBox(height: 14),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: textSecondary,
                fontSize: 13.5,
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: _cargarLiturgia,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: deepBlue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'Intentar de nuevo',
                  style: GoogleFonts.poppins(
                    color: white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_liturgia == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.menu_book_rounded,
              size: 40,
              color: Color(0xFF0B1E66),
            ),
            const SizedBox(height: 14),
            Text(
              'Aún no hay lecturas disponibles para hoy.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Cuando agregues el documento del día en Firestore, aquí se mostrarán automáticamente.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: textSecondary,
                fontSize: 13,
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (primeraLectura != null)
          _ReadingCard(
            sectionLabel: 'Primera lectura',
            title: _safeText(
              primeraLectura['titulo'],
              fallback: 'Primera lectura',
            ),
            cita: _safeText(primeraLectura['cita']),
            content: _safeText(primeraLectura['texto']),
          ),
        if (primeraLectura != null) const SizedBox(height: 18),
        if (salmo != null)
          _PsalmCard(
            cita: _safeText(salmo['cita']),
            respuesta: _safeText(salmo['respuesta']),
            content: _safeText(salmo['texto']),
          ),
        if (salmo != null) const SizedBox(height: 18),
        if (segundaLectura != null)
          _ReadingCard(
            sectionLabel: 'Segunda lectura',
            title: _safeText(
              segundaLectura['titulo'],
              fallback: 'Segunda lectura',
            ),
            cita: _safeText(segundaLectura['cita']),
            content: _safeText(segundaLectura['texto']),
          ),
        if (segundaLectura != null) const SizedBox(height: 18),
        if (evangelio != null)
          _ReadingCard(
            sectionLabel: 'Evangelio',
            title: _safeText(
              evangelio['titulo'],
              fallback: 'Evangelio del día',
            ),
            cita: _safeText(evangelio['cita']),
            content: _safeText(evangelio['texto']),
            isHighlighted: true,
          ),
        if (primeraLectura == null &&
            salmo == null &&
            segundaLectura == null &&
            evangelio == null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.chrome_reader_mode_rounded,
                  size: 40,
                  color: Color(0xFF0B1E66),
                ),
                const SizedBox(height: 14),
                Text(
                  'El documento existe, pero aún no contiene lecturas configuradas.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Agrega primeraLectura, salmo, segundaLectura o evangelio dentro del documento de hoy.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: textSecondary,
                    fontSize: 13,
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _TopChip extends StatelessWidget {
  final String text;

  const _TopChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ReadingCard extends StatelessWidget {
  final String sectionLabel;
  final String title;
  final String cita;
  final String content;
  final bool isHighlighted;

  const _ReadingCard({
    required this.sectionLabel,
    required this.title,
    required this.cita,
    required this.content,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    const white = Colors.white;
    const textPrimary = Color(0xFF1B2559);
    const textSecondary = Color(0xFF667085);
    const deepBlue = Color(0xFF0B1E66);
    const gold = Color(0xFFD4AF37);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(24),
        border: isHighlighted
            ? Border.all(
                color: gold.withOpacity(0.45),
                width: 1.2,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sectionLabel.isNotEmpty)
            Text(
              sectionLabel,
              style: GoogleFonts.poppins(
                color: isHighlighted ? deepBlue : textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.lora(
              color: textPrimary,
              fontSize: 23,
              height: 1.35,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (cita.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: isHighlighted
                    ? gold.withOpacity(0.16)
                    : deepBlue.withOpacity(0.07),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                cita,
                style: GoogleFonts.poppins(
                  color: isHighlighted ? const Color(0xFF8A6A00) : deepBlue,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
          const SizedBox(height: 18),
          Container(
            width: 56,
            height: 4,
            decoration: BoxDecoration(
              color: isHighlighted ? gold : deepBlue.withOpacity(0.22),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            content.isNotEmpty
                ? content
                : 'No hay contenido disponible en esta lectura.',
            style: GoogleFonts.lora(
              color: textPrimary,
              fontSize: 16.5,
              height: 1.9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _PsalmCard extends StatelessWidget {
  final String cita;
  final String respuesta;
  final String content;

  const _PsalmCard({
    required this.cita,
    required this.respuesta,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    const white = Colors.white;
    const textPrimary = Color(0xFF1B2559);
    const textSecondary = Color(0xFF667085);
    const deepBlue = Color(0xFF0B1E66);
    const gold = Color(0xFFD4AF37);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Salmo',
            style: GoogleFonts.poppins(
              color: textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            respuesta.isNotEmpty ? respuesta : 'Salmo responsorial',
            style: GoogleFonts.lora(
              color: textPrimary,
              fontSize: 23,
              height: 1.35,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (cita.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: deepBlue.withOpacity(0.07),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                cita,
                style: GoogleFonts.poppins(
                  color: deepBlue,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
          const SizedBox(height: 18),
          Container(
            width: 56,
            height: 4,
            decoration: BoxDecoration(
              color: gold,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 18),
          if (respuesta.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: gold.withOpacity(0.10),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                respuesta,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF8A6A00),
                  fontSize: 14,
                  height: 1.6,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          if (respuesta.isNotEmpty) const SizedBox(height: 16),
          Text(
            content.isNotEmpty
                ? content
                : 'No hay texto disponible para el salmo.',
            style: GoogleFonts.lora(
              color: textPrimary,
              fontSize: 16.5,
              height: 1.9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
