import 'dart:ui';

import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/oracion/data/models/liturgia_day_model.dart';
import 'package:escoge/features/oracion/data/models/lectura_model.dart';
import 'package:escoge/features/oracion/presentation/evangelio_screen.dart';
import 'package:escoge/features/oracion/presentation/lecturas_screen.dart';
import 'package:escoge/features/oracion/presentation/santo_del_dia_screen.dart';
import 'package:escoge/features/oracion/services/liturgia_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final LiturgiaService _liturgiaService = LiturgiaService();

  LiturgiaDayModel? _data;
  bool _loading = true;
  String? _errorMessage;
  bool _showTomorrow = false;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedDate = _dateOnly(DateTime.now());
    _loadForDate(_selectedDate);
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime _tomorrow(DateTime date) {
    return _dateOnly(date.add(const Duration(days: 1)));
  }

  Future<void> _loadForDate(DateTime date) async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final result = await _liturgiaService.getLiturgiaByDate(date);

      if (!mounted) return;

      setState(() {
        _selectedDate = date;
        _data = result;
        _loading = false;
        _errorMessage = result == null
            ? (_showTomorrow
                ? 'La liturgia de mañana aún no ha sido publicada.'
                : 'No se encontró liturgia para esta fecha.')
            : null;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _selectedDate = date;
        _data = null;
        _loading = false;
        _errorMessage = _showTomorrow
            ? 'La liturgia de mañana aún no ha sido publicada.'
            : 'No se pudo cargar la liturgia del día.';
      });
    }
  }

  void _selectToday() {
    if (!_showTomorrow) return;
    setState(() => _showTomorrow = false);
    _loadForDate(_dateOnly(DateTime.now()));
  }

  void _selectTomorrow() {
    if (_showTomorrow) return;
    setState(() => _showTomorrow = true);
    _loadForDate(_tomorrow(DateTime.now()));
  }

  String _formatFecha(DateTime date) {
    const dias = [
      'lunes',
      'martes',
      'miércoles',
      'jueves',
      'viernes',
      'sábado',
      'domingo',
    ];

    const meses = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];

    final weekdayIndex = date.weekday == 7 ? 6 : date.weekday - 1;
    return '${dias[weekdayIndex]}, ${date.day} de ${meses[date.month - 1]} de ${date.year}';
  }

  LecturaModel? _findLectura(String tipo) {
    try {
      return _data?.lecturas.firstWhere((item) => item.tipo == tipo);
    } catch (_) {
      return null;
    }
  }

  String _previewText(String value, {int max = 120}) {
    final text = value.trim().replaceAll('\n', ' ');
    if (text.isEmpty) return 'No disponible.';
    if (text.length <= max) return text;
    return '${text.substring(0, max).trim()}...';
  }

  String _buildVersiculoDelDia() {
    final reflexion = _data?.reflexionBreve?.trim() ?? '';
    if (reflexion.isNotEmpty) {
      return _previewText(reflexion, max: 110);
    }

    final evangelioTexto = _data?.evangelio?.texto.trim() ?? '';
    if (evangelioTexto.isNotEmpty) {
      final normalized = evangelioTexto.replaceAll('\n', ' ').trim();
      final firstSentence = normalized.split('.').first.trim();
      if (firstSentence.isNotEmpty) {
        return '$firstSentence.';
      }
      return _previewText(normalized, max: 110);
    }

    return 'La Palabra de Dios ilumina nuestro camino cada día.';
  }

  @override
  Widget build(BuildContext context) {
    final evangelio = _data?.evangelio;
    final santo = _data?.santoDelDia;
    final primeraLectura = _findLectura('primera_lectura');
    final salmo = _findLectura('salmo');

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/backgrounds/home.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.20),
                    Colors.black.withValues(alpha: 0.28),
                    Colors.black.withValues(alpha: 0.50),
                    Colors.black.withValues(alpha: 0.76),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: AppColors.primaryBlue.withValues(alpha: 0.10),
            ),
          ),
          SafeArea(
            bottom: false,
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.goldSoft,
                    ),
                  )
                : _errorMessage != null
                    ? _buildErrorState()
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 120),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(),
                            const SizedBox(height: 14),
                            _DaySwitcher(
                              showTomorrow: _showTomorrow,
                              onSelectToday: _selectToday,
                              onSelectTomorrow: _selectTomorrow,
                            ),
                            const SizedBox(height: 14),
                            _HeroLiturgiaCard(
                              fechaTexto: _formatFecha(
                                _data?.fecha ?? _selectedDate,
                              ),
                              celebracion:
                                  _data?.celebracion.trim().isNotEmpty == true
                                      ? _data!.celebracion
                                      : (_showTomorrow
                                          ? 'Liturgia de mañana'
                                          : 'Hoy en la Iglesia'),
                              tiempoLiturgico:
                                  _data?.tiempoLiturgico.trim().isNotEmpty ==
                                          true
                                      ? _data!.tiempoLiturgico
                                      : 'Liturgia diaria',
                              citaEvangelio: evangelio?.cita.trim() ?? '',
                              buttonText: _showTomorrow
                                  ? 'Ver liturgia de mañana'
                                  : 'Ver evangelio del día',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EvangelioScreen(
                                      selectedDate: _selectedDate,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 18),
                            if (santo != null)
                              _PreviewCard(
                                sectionLabel: 'Santo del día',
                                title: santo.nombre,
                                subtitle: santo.subtitulo.trim().isNotEmpty
                                    ? santo.subtitulo
                                    : 'Testimonio de santidad para hoy',
                                body: _previewText(santo.resumen, max: 150),
                                buttonText: 'Ver santo del día',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SantoDelDiaScreen(
                                        selectedDate: _selectedDate,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            if (santo != null) const SizedBox(height: 14),
                            if (primeraLectura != null)
                              _PreviewCard(
                                sectionLabel: 'Primera Lectura',
                                title: primeraLectura.titulo.trim().isNotEmpty
                                    ? primeraLectura.titulo
                                    : 'Primera Lectura',
                                subtitle: primeraLectura.cita,
                                body: _previewText(
                                  primeraLectura.texto,
                                  max: 160,
                                ),
                                buttonText: 'Abrir lecturas',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => LecturasScreen(
                                        selectedDate: _selectedDate,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            if (primeraLectura != null)
                              const SizedBox(height: 14),
                            if (salmo != null)
                              _PreviewCard(
                                sectionLabel: 'Salmo Responsorial',
                                title: salmo.titulo.trim().isNotEmpty
                                    ? salmo.titulo
                                    : 'Salmo Responsorial',
                                subtitle: salmo.cita,
                                body: _previewText(salmo.texto, max: 150),
                                buttonText: 'Ver salmo',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => LecturasScreen(
                                        selectedDate: _selectedDate,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            if (salmo != null) const SizedBox(height: 14),
                            if (evangelio != null)
                              _PreviewCard(
                                sectionLabel: 'Evangelio',
                                title: evangelio.titulo.trim().isNotEmpty
                                    ? evangelio.titulo
                                    : 'Evangelio del día',
                                subtitle: evangelio.cita,
                                body: _previewText(evangelio.texto, max: 160),
                                buttonText: 'Leer evangelio',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EvangelioScreen(
                                        selectedDate: _selectedDate,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            if (evangelio != null) const SizedBox(height: 14),
                            _VerseCard(
                              verse: _buildVersiculoDelDia(),
                            ),
                            const SizedBox(height: 18),
                            _BottomCtaCard(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LecturasScreen(
                                      selectedDate: _selectedDate,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Escoge RD',
          style: GoogleFonts.poppins(
            color: AppColors.goldSoft,
            fontSize: 12.8,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Camina cada día con la Palabra',
          style: GoogleFonts.lora(
            color: AppColors.white,
            fontSize: 28,
            height: 1.1,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.goldSoft,
                    size: 34,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'No se pudo cargar el contenido',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lora(
                      color: AppColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _errorMessage ?? 'Ocurrió un error inesperado.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lora(
                      color: AppColors.white.withValues(alpha: 0.88),
                      fontSize: 17,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: () {
                      _loadForDate(_selectedDate);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentBlue,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Reintentar',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
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

class _DaySwitcher extends StatelessWidget {
  final bool showTomorrow;
  final VoidCallback onSelectToday;
  final VoidCallback onSelectTomorrow;

  const _DaySwitcher({
    required this.showTomorrow,
    required this.onSelectToday,
    required this.onSelectTomorrow,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DayPill(
              label: 'Hoy',
              selected: !showTomorrow,
              onTap: onSelectToday,
            ),
            const SizedBox(width: 6),
            _DayPill(
              label: 'Mañana',
              selected: showTomorrow,
              onTap: onSelectTomorrow,
            ),
          ],
        ),
      ),
    );
  }
}

class _DayPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DayPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.gold.withValues(alpha: 0.18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? AppColors.white.withValues(alpha: 0.10)
                : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: AppColors.white,
            fontSize: 13.2,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _HeroLiturgiaCard extends StatelessWidget {
  final String fechaTexto;
  final String celebracion;
  final String tiempoLiturgico;
  final String citaEvangelio;
  final String buttonText;
  final VoidCallback onTap;

  const _HeroLiturgiaCard({
    required this.fechaTexto,
    required this.celebracion,
    required this.tiempoLiturgico,
    required this.citaEvangelio,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: SizedBox(
        height: 300,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/hoy_la_iglesia.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.12),
                      Colors.black.withValues(alpha: 0.24),
                      AppColors.primaryBlue.withValues(alpha: 0.52),
                      Colors.black.withValues(alpha: 0.86),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              top: 18,
              child: Text(
                fechaTexto,
                style: GoogleFonts.poppins(
                  color: AppColors.white.withValues(alpha: 0.86),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tiempoLiturgico,
                    style: GoogleFonts.poppins(
                      color: AppColors.goldSoft,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    celebracion,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lora(
                      color: AppColors.white,
                      fontSize: 30,
                      height: 1.08,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (citaEvangelio.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      citaEvangelio,
                      style: GoogleFonts.poppins(
                        color: AppColors.white.withValues(alpha: 0.88),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppColors.white.withValues(alpha: 0.10),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.menu_book_rounded,
                            color: AppColors.gold,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            buttonText,
                            style: GoogleFonts.poppins(
                              color: AppColors.white,
                              fontSize: 13.6,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  final String sectionLabel;
  final String title;
  final String subtitle;
  final String body;
  final String buttonText;
  final VoidCallback onTap;

  const _PreviewCard({
    required this.sectionLabel,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sectionLabel,
                style: GoogleFonts.poppins(
                  color: AppColors.gold,
                  fontSize: 13.8,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              if (subtitle.trim().isNotEmpty)
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    color: AppColors.goldSoft,
                    fontSize: 12.8,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (subtitle.trim().isNotEmpty) const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.lora(
                  color: AppColors.white,
                  fontSize: 21,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                body,
                style: GoogleFonts.lora(
                  color: AppColors.white.withValues(alpha: 0.86),
                  fontSize: 15.4,
                  height: 1.6,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  buttonText,
                  style: GoogleFonts.poppins(
                    color: AppColors.gold,
                    fontSize: 13.8,
                    fontWeight: FontWeight.w600,
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

class _VerseCard extends StatelessWidget {
  final String verse;

  const _VerseCard({
    required this.verse,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Versículo del día',
                style: GoogleFonts.poppins(
                  color: AppColors.gold,
                  fontSize: 13.8,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '“$verse”',
                style: GoogleFonts.lora(
                  color: AppColors.white,
                  fontSize: 18,
                  height: 1.65,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomCtaCard extends StatelessWidget {
  final VoidCallback onTap;

  const _BottomCtaCard({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            children: [
              Text(
                'Explora toda la liturgia del día',
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                  color: AppColors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Accede a todas las lecturas, salmo, evangelio y contenido litúrgico completo.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: AppColors.white.withValues(alpha: 0.72),
                  fontSize: 13.2,
                  height: 1.55,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentBlue,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    'Ver todas las lecturas',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                    ),
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
