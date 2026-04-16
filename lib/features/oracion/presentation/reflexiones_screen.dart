import 'dart:ui';

import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/oracion/data/models/liturgia_day_model.dart';
import 'package:escoge/features/oracion/services/liturgia_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReflexionesScreen extends StatefulWidget {
  final DateTime? selectedDate;

  const ReflexionesScreen({
    super.key,
    this.selectedDate,
  });

  @override
  State<ReflexionesScreen> createState() => _ReflexionesScreenState();
}

class _ReflexionesScreenState extends State<ReflexionesScreen> {
  final LiturgiaService _liturgiaService = LiturgiaService();

  LiturgiaDayModel? _liturgiaDay;
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

      if (!mounted) return;

      setState(() {
        _liturgiaDay = liturgia;
        _loading = false;
        _errorMessage = null;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _errorMessage = 'No se pudo cargar la reflexión del día.';
      });
    }
  }

  String _getTitulo() {
    return 'Reflexión del día';
  }

  String _getSubtitulo() {
    final celebracion = _liturgiaDay?.celebracion.trim() ?? '';
    if (celebracion.isNotEmpty) return celebracion;

    final tiempo = _liturgiaDay?.tiempoLiturgico.trim() ?? '';
    if (tiempo.isNotEmpty) return tiempo;

    return 'Meditación breve para tu camino espiritual';
  }

  String _getReflexion() {
    final reflexion = _liturgiaDay?.reflexionBreve?.trim() ?? '';
    if (reflexion.isNotEmpty) return reflexion;

    return 'No hay reflexión disponible para este día.';
  }

  String _getEvangelioCita() {
    final cita = _liturgiaDay?.evangelio?.cita.trim() ?? '';
    return cita;
  }

  String _getTiempoLiturgico() {
    final tiempo = _liturgiaDay?.tiempoLiturgico.trim() ?? '';
    return tiempo.isNotEmpty ? tiempo : 'Liturgia diaria';
  }

  bool get _hasReflection {
    final reflexion = _liturgiaDay?.reflexionBreve?.trim() ?? '';
    return reflexion.isNotEmpty && _errorMessage == null;
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
                    Colors.black.withValues(alpha: 0.20),
                    Colors.black.withValues(alpha: 0.44),
                    Colors.black.withValues(alpha: 0.74),
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
                    : !_hasReflection
                        ? _buildEmptyState()
                        : Column(
                            children: [
                              _buildHeader(context),
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
          _buildHeader(context, loading: true),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            height: 210,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: AppColors.white.withValues(alpha: 0.08),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: AppColors.white.withValues(alpha: 0.07),
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.08),
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
          title: 'No se pudo cargar la reflexión',
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
          icon: Icons.lightbulb_outline_rounded,
          title: 'No hay reflexión disponible',
          message: 'No se encontró reflexión para este día.',
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
              loading ? 'Reflexión' : _getTitulo(),
              textAlign: TextAlign.center,
              maxLines: 2,
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

  Widget _buildContent() {
    final fecha = _liturgiaDay?.fecha ?? widget.selectedDate ?? DateTime.now();
    final cita = _getEvangelioCita();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 34),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeroReflexionCard(
            fechaTexto: _formatFecha(fecha),
            titulo: _getTitulo(),
            subtitulo: _getSubtitulo(),
            tiempoLiturgico: _getTiempoLiturgico(),
            cita: cita,
          ),
          const SizedBox(height: 18),
          _ContentCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Meditación',
                  style: GoogleFonts.poppins(
                    color: AppColors.gold,
                    fontSize: 15.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _getReflexion(),
                  style: GoogleFonts.lora(
                    color: AppColors.white.withValues(alpha: 0.98),
                    fontSize: 19.2,
                    height: 1.82,
                    letterSpacing: 0.15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (cita.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Divider(
                    color: AppColors.white.withValues(alpha: 0.08),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Inspirado en el Evangelio',
                    style: GoogleFonts.poppins(
                      color: AppColors.goldSoft,
                      fontSize: 13.6,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    cita,
                    style: GoogleFonts.lora(
                      color: AppColors.white.withValues(alpha: 0.92),
                      fontSize: 17.2,
                      height: 1.6,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroReflexionCard extends StatelessWidget {
  final String fechaTexto;
  final String titulo;
  final String subtitulo;
  final String tiempoLiturgico;
  final String cita;

  const _HeroReflexionCard({
    required this.fechaTexto,
    required this.titulo,
    required this.subtitulo,
    required this.tiempoLiturgico,
    required this.cita,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: SizedBox(
        height: 210,
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
                      Colors.black.withValues(alpha: 0.12),
                      Colors.black.withValues(alpha: 0.18),
                      AppColors.primaryBlue.withValues(alpha: 0.50),
                      Colors.black.withValues(alpha: 0.82),
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
                    color: AppColors.white.withValues(alpha: 0.10),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              top: 16,
              child: Text(
                fechaTexto,
                style: GoogleFonts.poppins(
                  color: AppColors.white.withValues(alpha: 0.86),
                  fontSize: 13.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lora(
                      color: AppColors.white,
                      fontSize: 27,
                      height: 1.14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitulo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: AppColors.goldSoft,
                      fontSize: 13.8,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tiempoLiturgico,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: AppColors.white.withValues(alpha: 0.82),
                      fontSize: 12.8,
                      fontWeight: FontWeight.w600,
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

class _ContentCard extends StatelessWidget {
  final Widget child;

  const _ContentCard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
    return Container(
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
            child: Text(buttonLabel),
          ),
        ],
      ),
    );
  }
}
