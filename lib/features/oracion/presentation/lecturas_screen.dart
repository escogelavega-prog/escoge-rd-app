import 'dart:ui';

import 'package:escoge/core/theme/app_backgrounds.dart';
import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/core/widgets/loading_view.dart';
import 'package:escoge/features/oracion/data/models/lectura_model.dart';
import 'package:escoge/features/oracion/data/models/liturgia_day_model.dart';
import 'package:escoge/features/oracion/services/liturgia_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LecturasScreen extends StatefulWidget {
  final DateTime? selectedDate;

  const LecturasScreen({
    super.key,
    this.selectedDate,
  });

  @override
  State<LecturasScreen> createState() => _LecturasScreenState();
}

class _LecturasScreenState extends State<LecturasScreen> {
  final LiturgiaService _liturgiaService = LiturgiaService();

  LiturgiaDayModel? _data;
  bool _loading = true;
  String? _errorMessage;

  int _currentTab = 1;

  static const List<String> _tabs = [
    'Santo',
    '1.ª',
    'Salmo',
    '2.ª',
    'Evangelio',
    'Reflexión',
  ];

  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _selectedDate = widget.selectedDate ??
        DateTime(
          now.year,
          now.month,
          now.day,
        );

    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final result = await _liturgiaService.getLiturgiaByDate(_selectedDate);

      if (!mounted) return;

      setState(() {
        _data = result;
        _loading = false;
        _errorMessage = result == null
            ? 'No hay lecturas disponibles para esta fecha.'
            : null;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _errorMessage = 'No se pudieron cargar las lecturas.';
      });
    }
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

  LecturaModel? _findLectura(String tipo) {
    final lecturas = _data?.lecturas ?? [];

    for (final lectura in lecturas) {
      if (lectura.tipo == tipo) {
        return lectura;
      }
    }

    return null;
  }

  Map<String, String> _getSection() {
    switch (_currentTab) {
      case 0:
        final santo = _data?.santoDelDia;

        return {
          'label': 'Santo del día',
          'cita': '',
          'titulo': santo?.nombre.trim().isNotEmpty == true
              ? santo!.nombre.trim()
              : 'Santo del día',
          'texto': _safeText(
            santo?.resumen,
            fallback: santo?.historia,
            defaultValue:
                'No hay información del santo disponible para esta fecha.',
          ),
        };

      case 1:
        return _lecturaSection(
          label: 'Primera lectura',
          tipo: 'primera_lectura',
        );

      case 2:
        return _lecturaSection(
          label: 'Salmo responsorial',
          tipo: 'salmo',
        );

      case 3:
        return _lecturaSection(
          label: 'Segunda lectura',
          tipo: 'segunda_lectura',
        );

      case 4:
        final evangelio = _data?.evangelio;

        return {
          'label': 'Evangelio',
          'cita': evangelio?.cita.trim() ?? '',
          'titulo': evangelio?.titulo.trim().isNotEmpty == true
              ? evangelio!.titulo.trim()
              : 'Evangelio del día',
          'texto': _safeText(
            evangelio?.texto,
            defaultValue: 'No hay evangelio disponible para esta fecha.',
          ),
        };

      case 5:
        return {
          'label': 'Reflexión',
          'cita': '',
          'titulo': 'Reflexión del día',
          'texto': _safeText(
            _data?.reflexionBreve,
            defaultValue: 'No hay reflexión disponible para esta fecha.',
          ),
        };

      default:
        return {
          'label': 'Lectura',
          'cita': '',
          'titulo': 'Lecturas del día',
          'texto': 'No hay contenido disponible.',
        };
    }
  }

  Map<String, String> _lecturaSection({
    required String label,
    required String tipo,
  }) {
    final lectura = _findLectura(tipo);

    return {
      'label': label,
      'cita': lectura?.cita.trim() ?? '',
      'titulo': lectura?.titulo.trim().isNotEmpty == true
          ? lectura!.titulo.trim()
          : label,
      'texto': _safeText(
        lectura?.texto,
        fallback: lectura?.respuesta,
        defaultValue: 'No hay contenido disponible para esta lectura.',
      ),
    };
  }

  String _safeText(
    String? value, {
    String? fallback,
    required String defaultValue,
  }) {
    final cleanValue = value?.trim() ?? '';
    if (cleanValue.isNotEmpty) return cleanValue;

    final cleanFallback = fallback?.trim() ?? '';
    if (cleanFallback.isNotEmpty) return cleanFallback;

    return defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    final title = _data?.celebracion.trim().isNotEmpty == true
        ? _data!.celebracion.trim()
        : _data?.titulo.trim().isNotEmpty == true
            ? _data!.titulo.trim()
            : 'Lecturas del día';

    final tiempo = _data?.tiempoLiturgico.trim().isNotEmpty == true
        ? _data!.tiempoLiturgico.trim()
        : 'Liturgia diaria';

    return Scaffold(
      backgroundColor: AppColors.lumenBackground,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.screenGradient,
        ),
        child: _loading
            ? const LoadingView(
                message: 'Cargando lecturas',
                subtitle: 'Preparando la liturgia del día...',
              )
            : _errorMessage != null
                ? ErrorStateView(
                    title: 'No se pudo cargar',
                    message: _errorMessage!,
                    actionLabel: 'Reintentar',
                    onRetry: _load,
                    icon: PhosphorIcons.warningCircle(
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
                          child: _LecturasHeroHeader(
                            title: title,
                            dateText: _formatLongDate(_selectedDate),
                            tiempo: tiempo,
                            onBack: () => Navigator.of(context).pop(),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                            child: _TabsSelector(
                              tabs: _tabs,
                              currentTab: _currentTab,
                              onChanged: (index) {
                                setState(() {
                                  _currentTab = index;
                                });
                              },
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 260),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            child: Padding(
                              key: ValueKey(_currentTab),
                              padding:
                                  const EdgeInsets.fromLTRB(20, 18, 20, 140),
                              child: _ReadingContentCard(
                                section: _getSection(),
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

class _LecturasHeroHeader extends StatelessWidget {
  final String title;
  final String dateText;
  final String tiempo;
  final VoidCallback onBack;

  const _LecturasHeroHeader({
    required this.title,
    required this.dateText,
    required this.tiempo,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 390,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppBackgrounds.liturgia,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.screenGradient,
                ),
              );
            },
          ),
          Container(
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
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      _HeroIconButton(
                        icon: PhosphorIcons.caretLeft(
                          PhosphorIconsStyle.light,
                        ),
                        onTap: onBack,
                      ),
                      const Spacer(),
                      _HeroIconButton(
                        icon: PhosphorIcons.bookOpenText(
                          PhosphorIconsStyle.light,
                        ),
                        onTap: () {},
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
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                      height: 1.22,
                    ),
                  ),
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
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeroIconButton({
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
              width: 50,
              height: 50,
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

class _TabsSelector extends StatelessWidget {
  final List<String> tabs;
  final int currentTab;
  final ValueChanged<int> onChanged;

  const _TabsSelector({
    required this.tabs,
    required this.currentTab,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final selected = currentTab == index;

          return GestureDetector(
            onTap: () => onChanged(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.lumenGold.withValues(alpha: 0.18)
                    : AppColors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: selected
                      ? AppColors.lumenGold.withValues(alpha: 0.46)
                      : AppColors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Text(
                tabs[index],
                style: GoogleFonts.poppins(
                  color: selected
                      ? AppColors.lumenGoldSoft
                      : AppColors.lumenTextMuted,
                  fontSize: 12.8,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ReadingContentCard extends StatelessWidget {
  final Map<String, String> section;

  const _ReadingContentCard({
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    final label = section['label'] ?? '';
    final cita = section['cita'] ?? '';
    final title = section['titulo'] ?? '';
    final texto = section['texto'] ?? '';
    final respuesta = section['respuesta'] ?? '';

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.lumenCard.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: AppColors.glassStroke.withValues(alpha: 0.85),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 24,
                spreadRadius: -8,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionEyebrow(
                text: label,
                icon: _iconForLabel(label),
              ),
              if (cita.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(
                  cita,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF1DA1FF),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Text(
                title,
                style: GoogleFonts.lora(
                  color: AppColors.lumenTextPrimary,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              if (respuesta.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lumenGold.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.lumenGold.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Text(
                    respuesta,
                    style: GoogleFonts.poppins(
                      color: AppColors.lumenGoldSoft,
                      fontSize: 13.2,
                      height: 1.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 18),
              Text(
                texto,
                style: GoogleFonts.lora(
                  color: AppColors.lumenTextPrimary.withValues(alpha: 0.92),
                  fontSize: 18,
                  height: 1.72,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForLabel(String label) {
    final value = label.toLowerCase();

    if (value.contains('santo')) {
      return PhosphorIcons.sparkle(PhosphorIconsStyle.light);
    }

    if (value.contains('salmo')) {
      return PhosphorIcons.musicNotes(PhosphorIconsStyle.light);
    }

    if (value.contains('evangelio')) {
      return PhosphorIcons.bookOpenText(PhosphorIconsStyle.light);
    }

    if (value.contains('reflex')) {
      return PhosphorIcons.feather(PhosphorIconsStyle.light);
    }

    return PhosphorIcons.scroll(PhosphorIconsStyle.light);
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
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: AppColors.lumenGoldBright,
              fontSize: 11.8,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.35,
            ),
          ),
        ),
      ],
    );
  }
}
