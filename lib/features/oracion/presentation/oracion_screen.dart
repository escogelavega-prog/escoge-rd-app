// ignore_for_file: unused_element

import 'dart:async';
import 'dart:ui';

import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/core/widgets/lumen_segmented_control.dart';
import 'package:escoge/features/oracion/data/models/liturgia_day_model.dart';
import 'package:escoge/features/oracion/presentation/evangelio_screen.dart';
import 'package:escoge/features/oracion/presentation/lecturas_screen.dart';
import 'package:escoge/features/oracion/presentation/reflexiones_screen.dart';
import 'package:escoge/features/oracion/presentation/rosario_screen.dart';
import 'package:escoge/features/oracion/presentation/santo_del_dia_screen.dart';
import 'package:escoge/features/oracion/services/liturgia_service.dart';
import 'package:escoge/features/peticiones/presentation/peticiones_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OracionScreen extends StatefulWidget {
  const OracionScreen({super.key});

  @override
  State<OracionScreen> createState() => _OracionScreenState();
}

class _OracionScreenState extends State<OracionScreen> {
  final LiturgiaService _liturgiaService = LiturgiaService();

  static const String _iconSantoDelDia =
      'assets/icons/modules/santo_del_dia.png';
  static const String _iconRosario = 'assets/icons/modules/santo_rosario.png';
  static const String _iconPeticiones = 'assets/icons/modules/peticiones.png';
  static const String _iconReflexiones = 'assets/icons/modules/reflexiones.png';
  static const String _iconEvangelio = 'assets/icons/modules/evangelio.png';
  static const String _iconOraciones = 'assets/icons/modules/oraciones.png';

  LiturgiaDayModel? _liturgiaDay;
  bool _loading = true;
  String? _errorMessage;

  DateTime _selectedDate = DateTime.now();
  bool _showTomorrow = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = _dateOnly(DateTime.now());
    _initializeLiturgia();
  }

  Future<void> _initializeLiturgia() async {
    await _loadLiturgiaForDate(
      _selectedDate,
      useCacheFirst: true,
    );

    unawaited(
      _liturgiaService.preloadTodayAndTomorrow(),
    );
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime _tomorrow(DateTime date) {
    return _dateOnly(date.add(const Duration(days: 1)));
  }

  Future<void> _loadLiturgiaForDate(
    DateTime date, {
    bool useCacheFirst = true,
  }) async {
    final normalizedDate = _dateOnly(date);

    if (useCacheFirst) {
      final cached = _liturgiaService.getCachedLiturgiaByDate(normalizedDate);

      if (cached != null) {
        if (!mounted) return;

        setState(() {
          _selectedDate = normalizedDate;
          _liturgiaDay = cached;
          _loading = false;
          _errorMessage = null;
        });

        return;
      }
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final result = await _liturgiaService.getLiturgiaByDate(normalizedDate);

      if (!mounted) return;

      setState(() {
        _selectedDate = normalizedDate;
        _liturgiaDay = result;
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
        _selectedDate = normalizedDate;
        _liturgiaDay = null;
        _loading = false;
        _errorMessage = _showTomorrow
            ? 'La liturgia de mañana aún no ha sido publicada.'
            : 'No se pudo cargar la liturgia seleccionada.';
      });
    }
  }

  void _selectToday() {
    if (!_showTomorrow) return;

    setState(() {
      _showTomorrow = false;
    });

    _loadLiturgiaForDate(
      _dateOnly(DateTime.now()),
      useCacheFirst: true,
    );
  }

  void _selectTomorrow() {
    if (_showTomorrow) return;

    setState(() {
      _showTomorrow = true;
    });

    _loadLiturgiaForDate(
      _tomorrow(DateTime.now()),
      useCacheFirst: true,
    );
  }

  bool get _hasLiturgia => _liturgiaDay != null && _errorMessage == null;

  @override
  Widget build(BuildContext context) {
    final heroButtonText = _showTomorrow
        ? 'Entrar a la lectura de mañana'
        : 'Entrar a Hoy en la Iglesia';

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
                    Colors.black.withValues(alpha: 0.20),
                    Colors.black.withValues(alpha: 0.30),
                    Colors.black.withValues(alpha: 0.52),
                    Colors.black.withValues(alpha: 0.70),
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
            child: Column(
              children: [
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
                  child: Column(
                    children: [
                      Text(
                        'Oración',
                        style: GoogleFonts.lora(
                          fontSize: 31,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                          height: 1.08,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _showTomorrow
                            ? 'Explora desde ahora la liturgia de mañana'
                            : 'Tu espacio diario con Dios',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.white.withValues(alpha: 0.82),
                          fontWeight: FontWeight.w500,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 120),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: LumenSegmentedControl(
                          selectedIndex: _showTomorrow ? 1 : 0,
                          items: const ['Hoy', 'Mañana'],
                          onChanged: (index) {
                            if (index == 0) {
                              _selectToday();
                            } else {
                              _selectTomorrow();
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 14),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 320),
                          switchInCurve: Curves.easeOut,
                          switchOutCurve: Curves.easeIn,
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.04),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: _HoyEnLaIglesiaHeroClean(
                            key: ValueKey(
                              '${_selectedDate.toIso8601String()}-${_loading.toString()}-${_errorMessage ?? 'ok'}',
                            ),
                            liturgiaDay: _liturgiaDay,
                            loading: _loading,
                            errorMessage: _errorMessage,
                            showTomorrow: _showTomorrow,
                            buttonText: heroButtonText,
                            onTap: _hasLiturgia
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => LecturasScreen(
                                          selectedDate: _selectedDate,
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_hasLiturgia &&
                          (_liturgiaDay?.reflexionBreve?.trim().isNotEmpty ??
                              false))
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _ReflexionDestacadaCard(
                            texto: _liturgiaDay!.reflexionBreve!.trim(),
                          ),
                        ),
                      if (_hasLiturgia &&
                          (_liturgiaDay?.reflexionBreve?.trim().isNotEmpty ??
                              false))
                        const SizedBox(height: 24),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: _SectionHeader(
                          title: 'Accesos principales',
                          subtitle:
                              'Abre lo más importante de tu recorrido espiritual.',
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 1. Santo del Día
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _ModuloCard(
                          titulo: _showTomorrow
                              ? 'Santo de Mañana'
                              : 'Santo del Día',
                          subtitulo: _buildSantoSubtitle(
                            _liturgiaDay,
                            _loading,
                            _errorMessage,
                          ),
                          imageAsset: _iconSantoDelDia,
                          enabled: _hasLiturgia,
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
                          destinationBuilder: _unusedBuilder,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 2. Santo Rosario
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _ModuloCard(
                          titulo: 'Santo Rosario',
                          subtitulo:
                              'Vive una experiencia guiada de oración contemplativa y profunda.',
                          imageAsset: _iconRosario,
                          destinationBuilder: _buildRosarioScreen,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 3. Peticiones
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _ModuloCard(
                          titulo: 'Peticiones',
                          subtitulo:
                              'Comparte una intención y únete en oración con la comunidad.',
                          imageAsset: _iconPeticiones,
                          destinationBuilder: (context) =>
                              const PeticionesScreen(),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 4. Reflexiones
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _ModuloCard(
                          titulo: 'Reflexiones',
                          subtitulo: _buildReflexionSubtitle(
                            _liturgiaDay,
                            _loading,
                            _errorMessage,
                          ),
                          imageAsset: _iconReflexiones,
                          enabled: _hasLiturgia,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReflexionesScreen(
                                  selectedDate: _selectedDate,
                                ),
                              ),
                            );
                          },
                          destinationBuilder: _unusedBuilder,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 5. Evangelio del Día
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _ModuloCard(
                          titulo: _showTomorrow
                              ? 'Evangelio de Mañana'
                              : 'Evangelio del Día',
                          subtitulo: _buildEvangelioSubtitle(
                            _liturgiaDay,
                            _loading,
                            _errorMessage,
                          ),
                          imageAsset: _iconEvangelio,
                          enabled: _hasLiturgia,
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
                          destinationBuilder: _unusedBuilder,
                        ),
                      ),
                      const SizedBox(height: 24),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: _SectionHeader(
                          title: 'Próximamente',
                          subtitle:
                              'Módulos que formarán parte del ecosistema espiritual de Escoge RD.',
                        ),
                      ),
                      const SizedBox(height: 14),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _ComingSoonCard(
                          titulo: 'Oraciones',
                          subtitulo: 'Muy pronto disponibles.',
                          imageAsset: _iconOraciones,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _buildEvangelioSubtitle(
    LiturgiaDayModel? day,
    bool loading,
    String? errorMessage,
  ) {
    if (loading) {
      return 'Estamos preparando el Evangelio para ti...';
    }

    if (errorMessage != null) {
      return 'Estará disponible cuando la liturgia haya sido publicada.';
    }

    final cita = day?.evangelio?.cita.trim() ?? '';
    if (cita.isNotEmpty) {
      return 'Lee y medita el Evangelio: $cita';
    }

    return 'Lee y medita la Palabra de Dios en una experiencia contemplativa y cercana.';
  }

  static String _buildSantoSubtitle(
    LiturgiaDayModel? day,
    bool loading,
    String? errorMessage,
  ) {
    if (loading) {
      return 'Cargando el santo correspondiente al día...';
    }

    if (errorMessage != null) {
      return 'Se mostrará cuando el contenido del día esté disponible.';
    }

    final nombre = day?.santoDelDia?.nombre.trim() ?? '';
    if (nombre.isNotEmpty) {
      return 'La Iglesia recuerda a $nombre.';
    }

    return 'Descubre el santo y su testimonio de fe.';
  }

  static String _buildReflexionSubtitle(
    LiturgiaDayModel? day,
    bool loading,
    String? errorMessage,
  ) {
    if (loading) {
      return 'Preparando la reflexión espiritual del día...';
    }

    if (errorMessage != null) {
      return 'Se mostrará cuando la liturgia del día esté disponible.';
    }

    final reflexion = day?.reflexionBreve?.trim() ?? '';
    if (reflexion.isNotEmpty) {
      return 'Medita una reflexión breve para acompañar tu día.';
    }

    return 'Profundiza con una reflexión breve inspirada en la liturgia.';
  }

  static Widget _buildRosarioScreen(BuildContext context) =>
      const RosarioScreen();

  static Widget _unusedBuilder(BuildContext context) => const SizedBox.shrink();
}

class _HoyEnLaIglesiaHeroClean extends StatelessWidget {
  final VoidCallback? onTap;
  final LiturgiaDayModel? liturgiaDay;
  final bool loading;
  final String? errorMessage;
  final bool showTomorrow;
  final String buttonText;

  const _HoyEnLaIglesiaHeroClean({
    super.key,
    required this.onTap,
    required this.liturgiaDay,
    required this.loading,
    required this.errorMessage,
    required this.showTomorrow,
    required this.buttonText,
  });

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

  String _buildEstadoPrincipal() {
    if (loading) return 'Cargando liturgia...';

    if (errorMessage != null) {
      return showTomorrow
          ? 'La liturgia de mañana aún no ha sido publicada'
          : 'Contenido no disponible';
    }

    final tiempo = liturgiaDay?.tiempoLiturgico.trim() ?? '';
    return tiempo.isNotEmpty ? tiempo : 'Liturgia diaria';
  }

  @override
  Widget build(BuildContext context) {
    final fecha = liturgiaDay?.fecha ?? DateTime.now();
    final fechaTexto = _formatFecha(fecha);

    final celebracion = (liturgiaDay?.celebracion.trim().isNotEmpty ?? false)
        ? liturgiaDay!.celebracion
        : (showTomorrow ? 'Liturgia de mañana' : 'Hoy en la Iglesia');

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: SizedBox(
        height: 280,
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
                    stops: const [0.0, 0.36, 0.68, 1.0],
                    colors: [
                      Colors.black.withValues(alpha: 0.18),
                      Colors.black.withValues(alpha: 0.28),
                      AppColors.primaryBlue.withValues(alpha: 0.48),
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
                    color: AppColors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              top: 20,
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
              left: 20,
              right: 20,
              bottom: 22,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    celebracion,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lora(
                      color: AppColors.white,
                      fontSize: 27,
                      height: 1.12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: errorMessage != null
                              ? const Color(0xFFE8A7A7)
                              : (loading
                                  ? AppColors.goldSoft
                                  : AppColors.white),
                        ),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          _buildEstadoPrincipal(),
                          style: GoogleFonts.poppins(
                            color: AppColors.white.withValues(alpha: 0.90),
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _HeroActionButton(
                    label: buttonText,
                    enabled: onTap != null,
                    onTap: onTap,
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

class _HeroActionButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback? onTap;

  const _HeroActionButton({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: enabled ? 1 : 0.65,
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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.14),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.menu_book_rounded,
                color: AppColors.gold,
                size: 18,
              ),
              const SizedBox(width: 9),
              Flexible(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: AppColors.white,
                    fontSize: 13.6,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 13,
            height: 1.55,
            color: AppColors.white.withValues(alpha: 0.72),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ModuloCard extends StatelessWidget {
  const _ModuloCard({
    required this.titulo,
    required this.subtitulo,
    required this.imageAsset,
    required this.destinationBuilder,
    this.onTap,
    this.enabled = true,
  });

  final String titulo;
  final String subtitulo;
  final String imageAsset;
  final WidgetBuilder destinationBuilder;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final handleTap = onTap ??
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: destinationBuilder,
            ),
          );
        };

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 220),
      opacity: enabled ? 1 : 0.72,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? handleTap : null,
          borderRadius: BorderRadius.circular(24),
          child: Ink(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: 78,
                  width: 78,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Image.asset(
                    imageAsset,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.image_not_supported_outlined,
                      size: 30,
                      color: AppColors.white.withValues(alpha: 0.65),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: GoogleFonts.lora(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitulo,
                        style: GoogleFonts.poppins(
                          fontSize: 13.6,
                          height: 1.55,
                          color: AppColors.white.withValues(alpha: 0.76),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  enabled
                      ? Icons.arrow_forward_ios_rounded
                      : Icons.lock_outline_rounded,
                  size: 16,
                  color: AppColors.white.withValues(alpha: 0.74),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReflexionDestacadaCard extends StatelessWidget {
  final String texto;

  const _ReflexionDestacadaCard({
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
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
                'Reflexión breve',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.goldSoft,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                texto,
                style: GoogleFonts.lora(
                  fontSize: 17,
                  height: 1.6,
                  color: AppColors.white.withValues(alpha: 0.94),
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

class _ComingSoonCard extends StatelessWidget {
  const _ComingSoonCard({
    required this.titulo,
    required this.subtitulo,
    required this.imageAsset,
  });

  final String titulo;
  final String subtitulo;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 74,
            width: 74,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Image.asset(
              imageAsset,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                Icons.image_not_supported_outlined,
                size: 30,
                color: AppColors.white.withValues(alpha: 0.65),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: GoogleFonts.lora(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white.withValues(alpha: 0.92),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitulo,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    height: 1.5,
                    color: AppColors.white.withValues(alpha: 0.68),
                    fontWeight: FontWeight.w500,
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
              color: AppColors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Text(
              'Pronto',
              style: GoogleFonts.poppins(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: AppColors.goldSoft,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
