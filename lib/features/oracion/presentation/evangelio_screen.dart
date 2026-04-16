import 'dart:ui';

import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/oracion/data/models/evangelio_model.dart';
import 'package:escoge/features/oracion/data/models/liturgia_day_model.dart';
import 'package:escoge/features/oracion/services/liturgia_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EvangelioScreen extends StatefulWidget {
  final DateTime? selectedDate;

  const EvangelioScreen({
    super.key,
    this.selectedDate,
  });

  @override
  State<EvangelioScreen> createState() => _EvangelioScreenState();
}

class _EvangelioScreenState extends State<EvangelioScreen> {
  final LiturgiaService _liturgiaService = LiturgiaService();

  LiturgiaDayModel? _liturgiaDay;
  EvangelioModel? _evangelio;
  bool _loading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final targetDate = widget.selectedDate ?? DateTime.now();
      final liturgia = await _liturgiaService.getLiturgiaByDate(targetDate);
      final evangelio = liturgia?.evangelio;

      if (!mounted) return;

      setState(() {
        _liturgiaDay = liturgia;
        _evangelio = evangelio;
        _loading = false;
        _errorMessage = null;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _errorMessage = 'No se pudo cargar el evangelio.';
      });
    }
  }

  String _getEvangelioCita() {
    final cita = _evangelio?.cita.trim() ?? '';
    return cita.isNotEmpty ? cita : 'Cita no disponible';
  }

  String _getEvangelioTexto() {
    final texto = _evangelio?.texto.trim() ?? '';
    if (texto.isNotEmpty) return texto;
    return 'No hay evangelio disponible para este día.';
  }

  String _getTituloLiturgico() {
    final celebracion = _liturgiaDay?.celebracion.trim() ?? '';
    return celebracion.isNotEmpty ? celebracion : 'Evangelio del día';
  }

  String _getTiempoLiturgico() {
    final tiempo = _liturgiaDay?.tiempoLiturgico.trim() ?? '';
    return tiempo.isNotEmpty ? tiempo : 'Liturgia diaria';
  }

  String _getColorLiturgicoTexto() {
    final color = _liturgiaDay?.colorLiturgico.trim() ?? '';
    if (color.isEmpty) return '';
    return 'Color ${color[0].toUpperCase()}${color.substring(1)}';
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

  bool get _hasEvangelio {
    final texto = _evangelio?.texto.trim() ?? '';
    final cita = _evangelio?.cita.trim() ?? '';
    return texto.isNotEmpty || cita.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/backgrounds/lecturas.png',
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
                    Colors.black.withValues(alpha: 0.28),
                    Colors.black.withValues(alpha: 0.22),
                    Colors.black.withValues(alpha: 0.46),
                    Colors.black.withValues(alpha: 0.74),
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
            child: _loading
                ? _buildLoadingState(context)
                : _errorMessage != null
                    ? _buildErrorState()
                    : !_hasEvangelio
                        ? _buildEmptyState()
                        : Column(
                            children: [
                              _buildTopBar(context),
                              Expanded(
                                child: _buildContent(),
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
          _buildTopBar(context, loading: true),
          const SizedBox(height: 22),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildLoadingHero(),
                  const SizedBox(height: 20),
                  _buildLoadingCard(height: 56),
                  const SizedBox(height: 18),
                  _buildLoadingCard(height: 340),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingHero() {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: AppColors.white.withValues(alpha: 0.08),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.08),
        ),
      ),
    );
  }

  Widget _buildLoadingCard({required double height}) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.white.withValues(alpha: 0.07),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.08),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: _MessageCard(
          icon: Icons.error_outline_rounded,
          title: 'No se pudo cargar el evangelio',
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
          icon: Icons.menu_book_rounded,
          title: 'No hay evangelio disponible',
          message: 'No se encontró contenido litúrgico para este día.',
          buttonLabel: 'Volver',
          onTap: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, {bool loading = false}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: const EdgeInsets.only(top: 2),
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
              loading ? 'Evangelio' : _getTituloLiturgico(),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
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

  Widget _buildContent() {
    final fecha = _liturgiaDay?.fecha ?? widget.selectedDate ?? DateTime.now();
    final colorText = _getColorLiturgicoTexto();
    final colorRaw = _liturgiaDay?.colorLiturgico.trim() ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 34),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeroEvangelioCard(
            fechaTexto: _formatFecha(fecha),
            tiempoLiturgico: _getTiempoLiturgico(),
            colorLiturgicoLabel: colorText,
            colorLiturgicoValue: colorRaw,
            colorResolver: _liturgicalColor,
            cita: _getEvangelioCita(),
          ),
          const SizedBox(height: 18),
          const Center(
            child: _ListenButton(),
          ),
          const SizedBox(height: 18),
          _ContentCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getEvangelioTexto(),
                  style: GoogleFonts.lora(
                    color: AppColors.darkTextPrimary.withValues(alpha: 0.98),
                    fontSize: 19.2,
                    height: 1.85,
                    letterSpacing: 0.15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Palabra del Señor',
                  style: GoogleFonts.poppins(
                    color: AppColors.goldSoft,
                    fontSize: 14.2,
                    fontWeight: FontWeight.w700,
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

class _HeroEvangelioCard extends StatelessWidget {
  final String fechaTexto;
  final String tiempoLiturgico;
  final String colorLiturgicoLabel;
  final String colorLiturgicoValue;
  final Color Function(String?) colorResolver;
  final String cita;

  const _HeroEvangelioCard({
    required this.fechaTexto,
    required this.tiempoLiturgico,
    required this.colorLiturgicoLabel,
    required this.colorLiturgicoValue,
    required this.colorResolver,
    required this.cita,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: SizedBox(
        height: 220,
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
                    stops: const [0.0, 0.28, 0.68, 1.0],
                    colors: [
                      Colors.black.withValues(alpha: 0.16),
                      Colors.black.withValues(alpha: 0.24),
                      AppColors.primaryBlue.withValues(alpha: 0.52),
                      Colors.black.withValues(alpha: 0.84),
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
                  if (colorLiturgicoLabel.isNotEmpty)
                    _GlassBadge(
                      icon: Icons.circle,
                      label: colorLiturgicoLabel,
                      dotColor: colorResolver(colorLiturgicoValue),
                    ),
                ],
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tiempoLiturgico,
                    style: GoogleFonts.poppins(
                      color: AppColors.white.withValues(alpha: 0.82),
                      fontSize: 13.6,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (cita.trim().isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      cita,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lora(
                        color: AppColors.goldSoft.withValues(alpha: 0.98),
                        fontSize: 22,
                        height: 1.15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                color: isDot
                    ? (dotColor ?? AppColors.goldSoft)
                    : AppColors.goldSoft,
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
        ),
      ),
    );
  }
}

class _ListenButton extends StatelessWidget {
  const _ListenButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: LinearGradient(
          colors: [
            AppColors.gold.withValues(alpha: 0.18),
            AppColors.white.withValues(alpha: 0.06),
          ],
        ),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.graphic_eq_rounded,
            color: AppColors.gold,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            'Escuchar el Evangelio',
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  final Widget child;

  const _ContentCard({
    required this.child,
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
          child: child,
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
            color: AppColors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: AppColors.goldSoft,
                size: 34,
              ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
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
