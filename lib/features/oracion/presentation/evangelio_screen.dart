import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:escoge/core/theme/app_colors.dart';
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

  String get _texto {
    final value = _evangelio?.texto.trim() ?? '';
    return value.isNotEmpty
        ? value
        : 'No hay evangelio disponible para este día.';
  }

  String get _cita {
    final value = _evangelio?.cita.trim() ?? '';
    return value;
  }

  String get _titulo {
    final liturgiaTitle = _liturgiaDay?.celebracion.trim() ?? '';
    if (liturgiaTitle.isNotEmpty) return liturgiaTitle;

    final evTitle = _evangelio?.titulo.trim() ?? '';
    if (evTitle.isNotEmpty) return evTitle;

    return 'Evangelio del día';
  }

  String get _comentario {
    return _evangelio?.comentario?.trim() ?? '';
  }

  String? get _imageUrl {
    final url = _evangelio?.imagenUrl?.trim();
    if (url == null || url.isEmpty) return null;
    return url;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
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
    return '${date.day} de ${months[date.month]}';
  }

  @override
  Widget build(BuildContext context) {
    final hasContent = _evangelio != null;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.screenGradient,
        ),
        child: Stack(
          children: [
            Positioned(
              top: -110,
              right: -70,
              child: _GlowOrb(
                size: 250,
                color: AppColors.lumenGold.withValues(alpha: 0.10),
              ),
            ),
            Positioned(
              bottom: 80,
              left: -60,
              child: _GlowOrb(
                size: 240,
                color: AppColors.lumenBlueGlow.withValues(alpha: 0.26),
              ),
            ),
            SafeArea(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.lumenGold,
                      ),
                    )
                  : _errorMessage != null
                      ? _StateCard(
                          icon: PhosphorIcons.warningCircle(
                              PhosphorIconsStyle.light),
                          title: 'No se pudo cargar el evangelio',
                          message: _errorMessage!,
                          buttonLabel: 'Reintentar',
                          onTap: _load,
                        )
                      : !hasContent
                          ? _StateCard(
                              icon: PhosphorIcons.bookOpen(
                                  PhosphorIconsStyle.light),
                              title: 'Sin contenido disponible',
                              message:
                                  'No se encontró evangelio para la fecha seleccionada.',
                              buttonLabel: 'Volver',
                              onTap: () => Navigator.pop(context),
                            )
                          : RefreshIndicator(
                              color: AppColors.lumenGold,
                              onRefresh: _load,
                              child: ListView(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 12, 16, 32),
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  _HeaderBar(
                                    title: 'Evangelio',
                                    onBack: () => Navigator.pop(context),
                                  ),
                                  const SizedBox(height: 20),
                                  _HeroSection(
                                    title: _titulo,
                                    citation: _cita,
                                    dateLabel: _formatDate(_liturgiaDay?.fecha),
                                    imageUrl: _imageUrl,
                                  ),
                                  const SizedBox(height: 18),
                                  GlassSpiritualCard(
                                    radius: 30,
                                    blur: 16,
                                    fillOpacity: 0.08,
                                    borderOpacity: 0.12,
                                    padding: const EdgeInsets.all(22),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _SectionEyebrow(
                                          text: 'Palabra del Señor',
                                          icon: PhosphorIcons.bookOpenText(
                                              PhosphorIconsStyle.light),
                                        ),
                                        const SizedBox(height: 18),
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
                                      radius: 28,
                                      blur: 14,
                                      fillOpacity: 0.07,
                                      borderOpacity: 0.10,
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _SectionEyebrow(
                                            text: 'Meditación',
                                            icon: PhosphorIcons.sparkle(
                                                PhosphorIconsStyle.light),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            _comentario,
                                            style: GoogleFonts.poppins(
                                              color:
                                                  AppColors.lumenTextSecondary,
                                              fontSize: 14,
                                              height: 1.75,
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
    );
  }
}

class _HeaderBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const _HeaderBar({
    required this.title,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CircleButton(
          icon: PhosphorIcons.caretLeft(PhosphorIconsStyle.light),
          onTap: onBack,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(
              color: AppColors.lumenTextPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 46),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  final String title;
  final String citation;
  final String dateLabel;
  final String? imageUrl;

  const _HeroSection({
    required this.title,
    required this.citation,
    required this.dateLabel,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: SizedBox(
        height: 280,
        child: Stack(
          children: [
            Positioned.fill(
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 250),
                      placeholder: (_, __) => _heroFallback(),
                      errorWidget: (_, __, ___) => _heroFallback(),
                    )
                  : _heroFallback(),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.12),
                      Colors.black.withValues(alpha: 0.18),
                      Colors.black.withValues(alpha: 0.72),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.09),
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.black.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.white.withValues(alpha: 0.10),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (dateLabel.isNotEmpty) ...[
                          Text(
                            dateLabel,
                            style: GoogleFonts.poppins(
                              color: AppColors.lumenGoldSoft,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                        Text(
                          title,
                          style: GoogleFonts.lora(
                            color: AppColors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                        if (citation.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            citation,
                            style: GoogleFonts.poppins(
                              color: AppColors.lumenTextSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
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

  Widget _heroFallback() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1B2540),
            Color(0xFF171621),
            Color(0xFF100F18),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          PhosphorIcons.bookOpenText(PhosphorIconsStyle.light),
          color: AppColors.lumenGold.withValues(alpha: 0.75),
          size: 54,
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

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white.withValues(alpha: 0.06),
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Icon(
          icon,
          color: AppColors.lumenTextPrimary,
          size: 20,
        ),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _StateCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback onTap;

  const _StateCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.buttonLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: GlassSpiritualCard(
          radius: 30,
          blur: 16,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: AppColors.lumenGold,
                size: 34,
              ),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: 170,
                child: ElevatedButton(
                  onPressed: onTap,
                  child: Text(buttonLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
