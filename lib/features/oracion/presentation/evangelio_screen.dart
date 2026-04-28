import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:escoge/core/theme/app_backgrounds.dart';
import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/core/widgets/loading_view.dart';
import 'package:escoge/features/oracion/data/models/evangelio_model.dart';
import 'package:escoge/features/oracion/data/models/liturgia_day_model.dart';
import 'package:escoge/features/oracion/services/liturgia_service.dart';
import 'package:escoge/features/oracion/widgets/glass_spiritual_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class EvangelioScreen extends StatefulWidget {
  final DateTime? selectedDate;

  const EvangelioScreen({
    super.key,
    this.selectedDate,
  });

  @override
  State<EvangelioScreen> createState() => _EvangelioScreenState();
}

enum _EvangelioDayTab { hoy, manana }

class _EvangelioScreenState extends State<EvangelioScreen> {
  final LiturgiaService _liturgiaService = LiturgiaService();

  LiturgiaDayModel? _liturgiaDay;
  EvangelioModel? _evangelio;

  bool _loading = true;
  String? _errorMessage;

  late DateTime _selectedDate;
  _EvangelioDayTab _selectedTab = _EvangelioDayTab.hoy;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _selectedDate =
        widget.selectedDate ?? DateTime(now.year, now.month, now.day);

    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    if (_sameDay(_selectedDate, tomorrow)) {
      _selectedTab = _EvangelioDayTab.manana;
    }

    _load();
  }

  bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final liturgia = await _liturgiaService.getLiturgiaByDate(_selectedDate);

      if (!mounted) return;

      setState(() {
        _liturgiaDay = liturgia;
        _evangelio = liturgia?.evangelio;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _errorMessage = 'No se pudo cargar el evangelio.';
      });
    }
  }

  void _changeTab(_EvangelioDayTab tab) {
    if (_selectedTab == tab) return;

    final now = DateTime.now();

    setState(() {
      _selectedTab = tab;
      _selectedDate = tab == _EvangelioDayTab.hoy
          ? DateTime(now.year, now.month, now.day)
          : DateTime(now.year, now.month, now.day + 1);
    });

    _load();
  }

  String get _texto {
    final value = _evangelio?.texto.trim() ?? '';
    return value.isNotEmpty
        ? value
        : 'No hay evangelio disponible para este día.';
  }

  String get _cita => _evangelio?.cita.trim() ?? '';

  String get _titulo {
    final liturgiaTitle = _liturgiaDay?.celebracion.trim() ?? '';
    if (liturgiaTitle.isNotEmpty) return liturgiaTitle;

    final evTitle = _evangelio?.titulo.trim() ?? '';
    if (evTitle.isNotEmpty) return evTitle;

    return 'Evangelio del día';
  }

  String get _comentario => _evangelio?.comentario?.trim() ?? '';

  String? get _imageUrl {
    final url = _evangelio?.imagenUrl?.trim();
    if (url == null || url.isEmpty) return null;
    return url;
  }

  String _formatLongDate(DateTime date) {
    const days = [
      '',
      'lunes',
      'martes',
      'miércoles',
      'jueves',
      'viernes',
      'sábado',
      'domingo',
    ];

    const months = [
      '',
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

    return '${days[date.weekday]}, ${date.day} de ${months[date.month]} de ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final hasContent = _evangelio != null;

    return Scaffold(
      backgroundColor: AppColors.lumenBackground,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.screenGradient,
        ),
        child: _loading
            ? const LoadingView(
                message: 'Cargando evangelio',
                subtitle: 'Preparando la Palabra del día...',
              )
            : _errorMessage != null
                ? ErrorStateView(
                    title: 'No se pudo cargar el evangelio',
                    message: _errorMessage!,
                    onRetry: _load,
                  )
                : !hasContent
                    ? ErrorStateView(
                        title: 'Sin contenido disponible',
                        message:
                            'No se encontró evangelio para la fecha seleccionada.',
                        actionLabel: 'Volver',
                        onRetry: () => Navigator.pop(context),
                        icon: PhosphorIcons.bookOpen(
                          PhosphorIconsStyle.light,
                        ),
                      )
                    : RefreshIndicator(
                        color: AppColors.lumenGold,
                        backgroundColor: AppColors.lumenCard,
                        onRefresh: _load,
                        child: CustomScrollView(
                          physics: const BouncingScrollPhysics(),
                          slivers: [
                            SliverToBoxAdapter(
                              child: _LumenEvangelioHero(
                                title: _titulo,
                                citation: _cita,
                                dateText: _formatLongDate(_selectedDate),
                                imageUrl: _imageUrl,
                                selectedTab: _selectedTab,
                                onTabChanged: _changeTab,
                                onBack: () => Navigator.pop(context),
                                tiempo:
                                    _liturgiaDay?.tiempoLiturgico.isNotEmpty ==
                                            true
                                        ? _liturgiaDay!.tiempoLiturgico
                                        : 'Liturgia diaria',
                              ),
                            ),
                            SliverPadding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 18, 20, 120),
                              sliver: SliverList(
                                delegate: SliverChildListDelegate(
                                  [
                                    GlassSpiritualCard(
                                      radius: 30,
                                      blur: 18,
                                      fillOpacity: 0.08,
                                      borderOpacity: 0.12,
                                      padding: const EdgeInsets.all(24),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _SectionEyebrow(
                                            text: 'Palabra del Señor',
                                            icon: PhosphorIcons.bookOpenText(
                                              PhosphorIconsStyle.light,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Text(
                                            _texto,
                                            style: GoogleFonts.lora(
                                              color: AppColors.lumenTextPrimary,
                                              fontSize: 18,
                                              height: 1.85,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (_comentario.isNotEmpty) ...[
                                      const SizedBox(height: 18),
                                      GlassSpiritualCard(
                                        radius: 30,
                                        blur: 18,
                                        fillOpacity: 0.07,
                                        borderOpacity: 0.10,
                                        padding: const EdgeInsets.all(22),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _SectionEyebrow(
                                              text: 'Meditación',
                                              icon: PhosphorIcons.sparkle(
                                                PhosphorIconsStyle.light,
                                              ),
                                            ),
                                            const SizedBox(height: 18),
                                            Text(
                                              _comentario,
                                              style: GoogleFonts.poppins(
                                                color: AppColors
                                                    .lumenTextSecondary,
                                                fontSize: 14,
                                                height: 1.8,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
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

class _LumenEvangelioHero extends StatelessWidget {
  final String title;
  final String citation;
  final String dateText;
  final String tiempo;
  final String? imageUrl;
  final _EvangelioDayTab selectedTab;
  final ValueChanged<_EvangelioDayTab> onTabChanged;
  final VoidCallback onBack;

  const _LumenEvangelioHero({
    required this.title,
    required this.citation,
    required this.dateText,
    required this.tiempo,
    required this.imageUrl,
    required this.selectedTab,
    required this.onTabChanged,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 470,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(child: _HeroImage(imageUrl: imageUrl)),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.10),
                    Colors.black.withValues(alpha: 0.28),
                    AppColors.lumenBackground.withValues(alpha: 0.98),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      _HeroCircleButton(
                        icon: PhosphorIcons.caretLeft(
                          PhosphorIconsStyle.light,
                        ),
                        onTap: onBack,
                      ),
                      const Spacer(),
                      _DaySelector(
                        selectedTab: selectedTab,
                        onTabChanged: onTabChanged,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    dateText,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: AppColors.lumenTextPrimary.withValues(alpha: 0.88),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: AppColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      height: 1.24,
                    ),
                  ),
                  if (citation.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      citation,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: AppColors.lumenGoldSoft,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        tiempo,
                        style: GoogleFonts.poppins(
                          color: AppColors.lumenTextSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  final String? imageUrl;

  const _HeroImage({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 260),
        placeholder: (_, __) => _fallback(),
        errorWidget: (_, __, ___) => _fallback(),
      );
    }

    return _fallback();
  }

  Widget _fallback() {
    return Image.asset(
      AppBackgrounds.liturgia,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Container(
          decoration: const BoxDecoration(
            gradient: AppColors.screenGradient,
          ),
          child: Center(
            child: Icon(
              PhosphorIcons.bookOpenText(PhosphorIconsStyle.light),
              color: AppColors.lumenGold,
              size: 54,
            ),
          ),
        );
      },
    );
  }
}

class _DaySelector extends StatelessWidget {
  final _EvangelioDayTab selectedTab;
  final ValueChanged<_EvangelioDayTab> onTabChanged;

  const _DaySelector({
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          height: 52,
          width: 210,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: AppColors.lumenGold.withValues(alpha: 0.46),
            ),
          ),
          child: Row(
            children: [
              _DayPill(
                label: 'Hoy',
                selected: selectedTab == _EvangelioDayTab.hoy,
                onTap: () => onTabChanged(_EvangelioDayTab.hoy),
              ),
              _DayPill(
                label: 'Mañana',
                selected: selectedTab == _EvangelioDayTab.manana,
                onTap: () => onTabChanged(_EvangelioDayTab.manana),
              ),
            ],
          ),
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
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? AppColors.white.withValues(alpha: 0.20)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeroCircleButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.22),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.10),
                ),
              ),
              child: Icon(
                icon,
                color: AppColors.lumenGoldBright,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionEyebrow extends StatelessWidget {
  final String text;
  final IconData icon;

  const _SectionEyebrow({
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.lumenGoldBright,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.poppins(
            color: AppColors.lumenGoldBright,
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.35,
          ),
        ),
      ],
    );
  }
}
