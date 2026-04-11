import 'dart:ui';

import 'package:escoge/features/oracion/data/models/lectura_model.dart';
import 'package:escoge/features/oracion/data/models/liturgia_day_model.dart';
import 'package:escoge/features/oracion/services/liturgia_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LecturasScreen extends StatefulWidget {
  final DateTime? selectedDate;

  const LecturasScreen({
    super.key,
    this.selectedDate,
  });

  @override
  State<LecturasScreen> createState() => _LecturasScreenState();
}

class _LecturasScreenState extends State<LecturasScreen>
    with SingleTickerProviderStateMixin {
  static const Color gold = Color(0xFFD4AF37);
  static const Color softGold = Color(0xFFE8C76A);
  static const Color deepBlue = Color(0xFF0B1E66);

  final LiturgiaService _liturgiaService = LiturgiaService();

  LiturgiaDayModel? _data;
  bool _loading = true;
  String? _errorMessage;
  int currentTab = 0;

  late AnimationController _bgController;
  late Animation<double> _bgAnimation;

  final List<String> tabs = const [
    'Santo',
    '1.ª',
    'Salmo',
    '2.ª',
    'Evangelio',
    'Reflexión',
  ];

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat(reverse: true);

    _bgAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(
      CurvedAnimation(
        parent: _bgController,
        curve: Curves.easeInOut,
      ),
    );

    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final targetDate = widget.selectedDate ?? DateTime.now();
      final result = await _liturgiaService.getLiturgiaByDate(targetDate);

      if (!mounted) return;

      setState(() {
        _data = result;
        _loading = false;
        _errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _errorMessage = 'No se pudieron cargar las lecturas.';
      });
    }
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
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

  Color _liturgicalColor(String? value) {
    switch ((value ?? '').trim().toLowerCase()) {
      case 'verde':
        return const Color(0xFF3FAE5A);
      case 'rojo':
        return const Color(0xFFC84444);
      case 'blanco':
        return const Color(0xFFF4F1E8);
      case 'morado':
        return const Color(0xFF7A52A1);
      case 'rosa':
        return const Color(0xFFD98AA8);
      case 'dorado':
        return const Color(0xFFD4AF37);
      default:
        return softGold;
    }
  }

  bool get _hasData => _data != null && _errorMessage == null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bgAnimation,
              builder: (_, child) {
                return Transform.scale(
                  scale: _bgAnimation.value,
                  child: child,
                );
              },
              child: Image.asset(
                'assets/backgrounds/lecturas.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.24),
                    Colors.black.withOpacity(0.18),
                    Colors.black.withOpacity(0.42),
                    Colors.black.withOpacity(0.70),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: deepBlue.withOpacity(0.08),
            ),
          ),
          SafeArea(
            child: _loading
                ? _buildLoadingState(context)
                : _errorMessage != null
                    ? _buildErrorState()
                    : !_hasData
                        ? _buildEmptyState()
                        : Column(
                            children: [
                              _buildHeader(context),
                              const SizedBox(height: 18),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: _buildHeroCard(),
                              ),
                              const SizedBox(height: 14),
                              _buildTabs(),
                              const SizedBox(height: 12),
                              Expanded(
                                child: _buildAnimatedContent(),
                              ),
                            ],
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      child: Column(
        children: [
          _buildHeader(context, loading: true),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            height: 190,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white.withOpacity(0.08),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (_, __) => Container(
                width: 82,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemCount: 5,
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: Colors.white.withOpacity(0.07),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: _MessageCard(
          icon: Icons.error_outline_rounded,
          title: 'No se pudieron cargar las lecturas',
          message: _errorMessage ?? 'Ocurrió un error inesperado.',
          buttonLabel: 'Reintentar',
          onTap: _load,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: _MessageCard(
          icon: Icons.chrome_reader_mode_rounded,
          title: 'No hay lecturas disponibles',
          message: 'No se encontró contenido litúrgico para este día.',
          buttonLabel: 'Volver',
          onTap: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, {bool loading = false}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              loading
                  ? 'Lecturas del día'
                  : (_data?.celebracion ?? 'Lecturas del día'),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.lora(
                color: Colors.white,
                fontSize: 24,
                height: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 46),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    final fecha = _data?.fecha ?? widget.selectedDate ?? DateTime.now();
    final fechaTexto = _formatFecha(fecha);
    final tiempo = _data?.tiempoLiturgico.trim() ?? 'Liturgia diaria';
    final colorRaw = _data?.colorLiturgico.trim() ?? '';
    final colorText = colorRaw.isEmpty
        ? ''
        : 'Color ${colorRaw[0].toUpperCase()}${colorRaw.substring(1)}';

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: SizedBox(
        height: 190,
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
                    stops: const [0.0, 0.30, 0.64, 1.0],
                    colors: [
                      Colors.black.withOpacity(0.12),
                      Colors.black.withOpacity(0.18),
                      deepBlue.withOpacity(0.50),
                      Colors.black.withOpacity(0.82),
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
                    color: Colors.white.withOpacity(0.10),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              top: 16,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _GlassBadge(
                    icon: Icons.calendar_today_rounded,
                    label: fechaTexto,
                  ),
                  if (colorText.isNotEmpty)
                    _GlassBadge(
                      icon: Icons.circle,
                      label: colorText,
                      dotColor: _liturgicalColor(colorRaw),
                    ),
                ],
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 16,
              child: Text(
                tiempo,
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.86),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final selected = currentTab == index;

          return GestureDetector(
            onTap: () => setState(() => currentTab = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: selected
                    ? gold.withOpacity(0.18)
                    : Colors.white.withOpacity(0.05),
                border: Border.all(
                  color: selected
                      ? Colors.white.withOpacity(0.10)
                      : Colors.white.withOpacity(0.05),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                tabs[index],
                style: GoogleFonts.poppins(
                  color: selected ? softGold : Colors.white70,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedContent() {
    final section = _getSection();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 320),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.03, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: _buildContent(section),
    );
  }

  Widget _buildContent(Map<String, String> section) {
    final cita = section['cita'] ?? '';
    final texto = section['texto'] ?? '';
    final titulo = section['titulo'] ?? '';
    final label = section['label'] ?? '';

    return SingleChildScrollView(
      key: ValueKey(currentTab),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 34),
      physics: const BouncingScrollPhysics(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: gold,
                    fontSize: 15.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (cita.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    cita,
                    style: GoogleFonts.poppins(
                      color: softGold,
                      fontSize: 14.5,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                Text(
                  titulo.isNotEmpty ? titulo : 'Contenido del día',
                  style: GoogleFonts.lora(
                    color: Colors.white,
                    fontSize: 26,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.white.withOpacity(0.08),
                ),
                const SizedBox(height: 20),
                Text(
                  texto.isNotEmpty ? texto : 'No disponible.',
                  style: GoogleFonts.lora(
                    color: Colors.white.withOpacity(0.98),
                    fontSize: 19.2,
                    height: 1.82,
                    letterSpacing: 0.15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<String, String> _getSection() {
    switch (currentTab) {
      case 0:
        return {
          'label': 'Santo del día',
          'cita': '',
          'titulo': _data?.santoDelDia?.nombre ?? 'Santo del día',
          'texto':
              _data?.santoDelDia?.resumen ?? 'No hay información disponible.',
        };

      case 1:
        return _buildLecturaSection(
          'Primera Lectura',
          'primera_lectura',
        );

      case 2:
        return _buildLecturaSection(
          'Salmo',
          'salmo',
        );

      case 3:
        return _buildLecturaSection(
          'Segunda Lectura',
          'segunda_lectura',
        );

      case 4:
        return {
          'label': 'Evangelio',
          'cita': _data?.evangelio?.cita ?? '',
          'titulo': _data?.evangelio?.titulo ?? 'Evangelio',
          'texto': _data?.evangelio?.texto ?? 'No disponible.',
        };

      case 5:
        return {
          'label': 'Reflexión',
          'cita': '',
          'titulo': 'Reflexión del día',
          'texto': _data?.reflexionBreve?.trim().isNotEmpty == true
              ? _data!.reflexionBreve!.trim()
              : 'No hay reflexión disponible para este día.',
        };

      default:
        return {
          'label': '',
          'cita': '',
          'titulo': '',
          'texto': '',
        };
    }
  }

  Map<String, String> _buildLecturaSection(
    String label,
    String tipo,
  ) {
    final lectura = _findLectura(tipo);

    return {
      'label': label,
      'cita': lectura?.cita ?? '',
      'titulo': lectura?.titulo ?? label,
      'texto': lectura?.texto ?? 'No disponible.',
    };
  }

  LecturaModel? _findLectura(String tipo) {
    try {
      return _data?.lecturas.firstWhere(
        (item) => item.tipo == tipo,
      );
    } catch (_) {
      return null;
    }
  }
}

class _GlassBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? dotColor;

  const _GlassBadge({
    required this.icon,
    required this.label,
    this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDot = icon == Icons.circle;

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: Colors.white.withOpacity(0.10),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: isDot ? 11 : 14,
                color: isDot
                    ? (dotColor ?? _LecturasScreenState.softGold)
                    : _LecturasScreenState.softGold,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12.2,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.92),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback onTap;

  const _MessageCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.buttonLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: _LecturasScreenState.softGold,
                size: 34,
              ),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                  color: Colors.white.withOpacity(0.88),
                  fontSize: 17,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _LecturasScreenState.gold,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  buttonLabel,
                  style: GoogleFonts.poppins(
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
