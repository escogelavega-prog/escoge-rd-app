import 'package:escoge/features/oracion/services/liturgia_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EvangelioScreen extends StatefulWidget {
  const EvangelioScreen({super.key});

  @override
  State<EvangelioScreen> createState() => _EvangelioScreenState();
}

class _EvangelioScreenState extends State<EvangelioScreen> {
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
            'No se pudo cargar el evangelio del día. Verifica tu conexión o la estructura en Firestore.';
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

    final evangelio = _safeMap(_liturgia?['evangelio']);
    final reflexion = _safeMap(_liturgia?['reflexion']);
    final celebracion = _safeText(_liturgia?['celebracion']);
    final tiempoLiturgico = _safeText(_liturgia?['tiempoLiturgico']);
    final colorLiturgico = _safeText(_liturgia?['colorLiturgico']);
    final tituloDia = _safeText(
      _liturgia?['tituloDia'],
      fallback: 'Evangelio del día',
    );

    final evangelioTitulo = _safeText(
      evangelio?['titulo'],
      fallback: 'Evangelio del día',
    );
    final evangelioCita = _safeText(evangelio?['cita']);
    final evangelioTexto = _safeText(evangelio?['texto']);

    final reflexionTitulo = _safeText(
      reflexion?['titulo'],
      fallback: 'Reflexión del día',
    );
    final reflexionTexto = _safeText(reflexion?['texto']);
    final reflexionAutor = _safeText(reflexion?['autor']);

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
                                    'Evangelio',
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
                                  if (evangelioCita.isNotEmpty)
                                    _TopChip(text: evangelioCita),
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
                      evangelioTitulo: evangelioTitulo,
                      evangelioTexto: evangelioTexto,
                      reflexionTitulo: reflexionTitulo,
                      reflexionTexto: reflexionTexto,
                      reflexionAutor: reflexionAutor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      deepBlue: deepBlue,
                      gold: gold,
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
    required String evangelioTitulo,
    required String evangelioTexto,
    required String reflexionTitulo,
    required String reflexionTexto,
    required String reflexionAutor,
    required Color textPrimary,
    required Color textSecondary,
    required Color deepBlue,
    required Color gold,
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
              'Cargando evangelio del día...',
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
              'Aún no hay contenido litúrgico disponible para hoy.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Cuando agregues el documento del día en Firestore, aquí se mostrará automáticamente.',
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
        Container(
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
                'Evangelio',
                style: GoogleFonts.poppins(
                  color: textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                evangelioTitulo,
                style: GoogleFonts.lora(
                  color: textPrimary,
                  fontSize: 25,
                  height: 1.35,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: 56,
                height: 4,
                decoration: BoxDecoration(
                  color: gold,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                evangelioTexto.isNotEmpty
                    ? evangelioTexto
                    : 'No se encontró el texto del evangelio en el documento de hoy.',
                style: GoogleFonts.lora(
                  color: textPrimary,
                  fontSize: 17,
                  height: 1.9,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Container(
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
                reflexionTitulo,
                style: GoogleFonts.poppins(
                  color: textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                reflexionTexto.isNotEmpty
                    ? reflexionTexto
                    : 'Todavía no se ha agregado una reflexión para el día de hoy.',
                style: GoogleFonts.poppins(
                  color: textSecondary,
                  fontSize: 14,
                  height: 1.8,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (reflexionAutor.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(
                  '— $reflexionAutor',
                  style: GoogleFonts.poppins(
                    color: deepBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF0B1E66),
                Color(0xFF1736A2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vive el mensaje de hoy',
                style: GoogleFonts.lora(
                  color: white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Que esta Palabra ilumine tu día, fortalezca tu corazón y te acerque más al Señor.',
                style: GoogleFonts.poppins(
                  color: white.withOpacity(0.85),
                  fontSize: 13.5,
                  height: 1.65,
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
