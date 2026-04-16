import 'dart:ui';

import 'package:escoge/core/theme/app_colors.dart';
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
    } catch (_) {
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
        return AppColors.gold;
      default:
        return AppColors.goldSoft;
    }
  }

  bool get _hasData => _data != null && _errorMessage == null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
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
                    Colors.black.withValues(alpha: 0.24),
                    Colors.black.withValues(alpha: 0.18),
                    Colors.black.withValues(alpha: 0.42),
                    Colors.black.withValues(alpha: 0.72),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: AppColors.primaryBlue.withValues(alpha: 0.08),
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
              color: AppColors.white.withValues(alpha: 0.08),
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: AppColors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return _buildMessageState(
      icon: Icons.error_outline_rounded,
      title: 'No se pudieron cargar las lecturas',
      message: _errorMessage ?? 'Ocurrió un error inesperado.',
      buttonLabel: 'Reintentar',
      onTap: _load,
    );
  }

  Widget _buildEmptyState() {
    return _buildMessageState(
      icon: Icons.chrome_reader_mode_rounded,
      title: 'No hay lecturas disponibles',
      message: 'No se encontró contenido litúrgico para este día.',
      buttonLabel: 'Volver',
      onTap: () => Navigator.pop(context),
    );
  }

  Widget _buildMessageState({
    required IconData icon,
    required String title,
    required String message,
    required String buttonLabel,
    required VoidCallback onTap,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
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
              Icon(icon, color: AppColors.goldSoft, size: 34),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                  color: AppColors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                  color: AppColors.white.withValues(alpha: 0.88),
                  fontSize: 17,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: onTap,
                child: Text(buttonLabel),
              ),
            ],
          ),
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
                color: AppColors.white.withValues(alpha: 0.08),
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.08),
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.white,
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
                color: AppColors.white,
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

    return Container(
      height: 190,
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: const DecorationImage(
          image: AssetImage('assets/images/hoy_la_iglesia.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.12),
              Colors.black.withValues(alpha: 0.55),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _badge(Icons.calendar_today_rounded, fechaTexto),
                  if (colorText.isNotEmpty)
                    _badge(
                      Icons.circle,
                      colorText,
                      color: _liturgicalColor(colorRaw),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                tiempo,
                style: GoogleFonts.poppins(
                  color: AppColors.white.withValues(alpha: 0.88),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(IconData icon, String label, {Color? color}) {
    final isDot = icon == Icons.circle;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: isDot ? 11 : 14,
            color: color ?? AppColors.goldSoft,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12.2,
              fontWeight: FontWeight.w600,
              color: AppColors.white.withValues(alpha: 0.92),
            ),
          ),
        ],
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
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: selected
                    ? AppColors.gold.withValues(alpha: 0.18)
                    : AppColors.white.withValues(alpha: 0.05),
                border: Border.all(
                  color: selected
                      ? AppColors.white.withValues(alpha: 0.10)
                      : AppColors.white.withValues(alpha: 0.05),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                tabs[index],
                style: GoogleFonts.poppins(
                  color: selected
                      ? AppColors.goldSoft
                      : AppColors.white.withValues(alpha: 0.70),
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
      child: _buildContent(section),
    );
  }

  Widget _buildContent(Map<String, String> section) {
    return SingleChildScrollView(
      key: ValueKey(currentTab),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 34),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section['label'] ?? '',
              style: GoogleFonts.poppins(
                color: AppColors.gold,
                fontSize: 15.2,
                fontWeight: FontWeight.w600,
              ),
            ),
            if ((section['cita'] ?? '').isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                section['cita']!,
                style: GoogleFonts.poppins(
                  color: AppColors.goldSoft,
                  fontSize: 14.5,
                ),
              ),
            ],
            const SizedBox(height: 18),
            Text(
              section['titulo'] ?? '',
              style: GoogleFonts.lora(
                color: AppColors.white,
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              height: 1,
              color: AppColors.white.withValues(alpha: 0.08),
            ),
            const SizedBox(height: 20),
            Text(
              section['texto'] ?? '',
              style: GoogleFonts.lora(
                color: AppColors.white.withValues(alpha: 0.98),
                fontSize: 19.2,
                height: 1.82,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, String> _getSection() {
    switch (currentTab) {
      case 0:
        return {
          'label': 'Santo del día',
          'titulo': _data?.santoDelDia?.nombre ?? 'Santo del día',
          'texto':
              _data?.santoDelDia?.resumen ?? 'No hay información disponible.',
        };

      case 1:
        return _buildLecturaSection('Primera Lectura', 'primera_lectura');

      case 2:
        return _buildLecturaSection('Salmo', 'salmo');

      case 3:
        return _buildLecturaSection('Segunda Lectura', 'segunda_lectura');

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
          'titulo': 'Reflexión del día',
          'texto': _data?.reflexionBreve?.trim().isNotEmpty == true
              ? _data!.reflexionBreve!.trim()
              : 'No hay reflexión disponible para este día.',
        };

      default:
        return {};
    }
  }

  Map<String, String> _buildLecturaSection(String label, String tipo) {
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
      return _data?.lecturas.firstWhere((item) => item.tipo == tipo);
    } catch (_) {
      return null;
    }
  }
}
