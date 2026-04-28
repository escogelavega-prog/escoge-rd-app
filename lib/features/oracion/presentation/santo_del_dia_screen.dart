import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:escoge/core/theme/app_backgrounds.dart';
import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/core/widgets/loading_view.dart';
import 'package:escoge/features/oracion/data/models/liturgia_day_model.dart';
import 'package:escoge/features/oracion/data/models/santo_model.dart';
import 'package:escoge/features/oracion/services/liturgia_service.dart';
import 'package:escoge/features/oracion/widgets/glass_spiritual_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SantoDelDiaScreen extends StatefulWidget {
  final DateTime? selectedDate;

  const SantoDelDiaScreen({
    super.key,
    this.selectedDate,
  });

  @override
  State<SantoDelDiaScreen> createState() => _SantoDelDiaScreenState();
}

enum _SantoDayTab { hoy, manana }

class _SantoDelDiaScreenState extends State<SantoDelDiaScreen> {
  final LiturgiaService _liturgiaService = LiturgiaService();

  LiturgiaDayModel? _liturgiaDay;
  SantoModel? _santo;

  bool _loading = true;
  String? _errorMessage;

  late DateTime _selectedDate;
  _SantoDayTab _selectedTab = _SantoDayTab.hoy;

  bool get _hasSanto => _santo != null;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _selectedDate =
        widget.selectedDate ?? DateTime(now.year, now.month, now.day);

    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    if (_sameDay(_selectedDate, tomorrow)) {
      _selectedTab = _SantoDayTab.manana;
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
        _santo = liturgia?.santoDelDia;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _errorMessage = 'No se pudo cargar el santo del día.';
      });
    }
  }

  void _changeTab(_SantoDayTab tab) {
    if (_selectedTab == tab) return;

    final now = DateTime.now();

    setState(() {
      _selectedTab = tab;
      _selectedDate = tab == _SantoDayTab.hoy
          ? DateTime(now.year, now.month, now.day)
          : DateTime(now.year, now.month, now.day + 1);
    });

    _load();
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

  String get _name => _santo?.nombre.trim().isNotEmpty == true
      ? _santo!.nombre.trim()
      : 'Santo del día';

  String get _subtitle => _santo?.subtitulo.trim() ?? '';

  String get _summary => _santo?.resumen.trim().isNotEmpty == true
      ? _santo!.resumen.trim()
      : 'No hay resumen disponible para este día.';

  String get _history => _santo?.historia?.trim().isNotEmpty == true
      ? _santo!.historia!.trim()
      : 'No hay historia disponible para este día.';

  String get _quote => _santo?.frase?.trim() ?? '';

  String? get _imageUrl {
    final url = _santo?.imagenUrl?.trim();
    if (url == null || url.isEmpty) return null;
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lumenBackground,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.screenGradient,
        ),
        child: _loading
            ? const LoadingView(
                message: 'Cargando santo del día',
                subtitle: 'Preparando la memoria espiritual...',
              )
            : _errorMessage != null
                ? ErrorStateView(
                    title: 'No se pudo cargar el santo',
                    message: _errorMessage!,
                    onRetry: _load,
                  )
                : !_hasSanto
                    ? ErrorStateView(
                        title: 'Sin santo disponible',
                        message:
                            'No se encontró contenido para la fecha seleccionada.',
                        actionLabel: 'Volver',
                        onRetry: () => Navigator.pop(context),
                        icon: PhosphorIcons.sparkle(
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
                              child: _LumenSaintHero(
                                name: _name,
                                subtitle: _subtitle,
                                dateText: _formatLongDate(_selectedDate),
                                imageUrl: _imageUrl,
                                selectedTab: _selectedTab,
                                onTabChanged: _changeTab,
                                onBack: () => Navigator.pop(context),
                                tiempo:
                                    _liturgiaDay?.tiempoLiturgico.isNotEmpty ==
                                            true
                                        ? _liturgiaDay!.tiempoLiturgico
                                        : 'Memoria del día',
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
                                            text: 'Resumen espiritual',
                                            icon: PhosphorIcons.star(
                                              PhosphorIconsStyle.light,
                                            ),
                                          ),
                                          const SizedBox(height: 18),
                                          Text(
                                            _summary,
                                            style: GoogleFonts.poppins(
                                              color:
                                                  AppColors.lumenTextSecondary,
                                              fontSize: 14,
                                              height: 1.75,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (_quote.isNotEmpty) ...[
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
                                              text: 'Frase',
                                              icon: PhosphorIcons.quotes(
                                                PhosphorIconsStyle.light,
                                              ),
                                            ),
                                            const SizedBox(height: 18),
                                            Text(
                                              '“$_quote”',
                                              style: GoogleFonts.lora(
                                                color:
                                                    AppColors.lumenTextPrimary,
                                                fontSize: 19,
                                                height: 1.7,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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
                                            text: 'Historia',
                                            icon: PhosphorIcons.scroll(
                                              PhosphorIconsStyle.light,
                                            ),
                                          ),
                                          const SizedBox(height: 18),
                                          Text(
                                            _history,
                                            style: GoogleFonts.poppins(
                                              color:
                                                  AppColors.lumenTextSecondary,
                                              fontSize: 14,
                                              height: 1.8,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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

class _LumenSaintHero extends StatelessWidget {
  final String name;
  final String subtitle;
  final String dateText;
  final String tiempo;
  final String? imageUrl;
  final _SantoDayTab selectedTab;
  final ValueChanged<_SantoDayTab> onTabChanged;
  final VoidCallback onBack;

  const _LumenSaintHero({
    required this.name,
    required this.subtitle,
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
          Positioned.fill(
            child: _SaintHeroImage(imageUrl: imageUrl),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.08),
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
                    name,
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
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: AppColors.lumenGoldSoft,
                        fontSize: 13,
                        height: 1.45,
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

class _SaintHeroImage extends StatelessWidget {
  final String? imageUrl;

  const _SaintHeroImage({
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
              PhosphorIcons.crownSimple(PhosphorIconsStyle.light),
              color: AppColors.lumenGold,
              size: 56,
            ),
          ),
        );
      },
    );
  }
}

class _DaySelector extends StatelessWidget {
  final _SantoDayTab selectedTab;
  final ValueChanged<_SantoDayTab> onTabChanged;

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
                selected: selectedTab == _SantoDayTab.hoy,
                onTap: () => onTabChanged(_SantoDayTab.hoy),
              ),
              _DayPill(
                label: 'Mañana',
                selected: selectedTab == _SantoDayTab.manana,
                onTap: () => onTabChanged(_SantoDayTab.manana),
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
