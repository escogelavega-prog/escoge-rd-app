import 'dart:ui';

import 'package:escoge/app/routes/app_page_route.dart';
import 'package:escoge/core/constants/app_assets.dart';
import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/core/widgets/loading_view.dart';
import 'package:escoge/features/contenido/presentation/catecismo_screen.dart';
import 'package:escoge/features/oracion/data/models/lectura_model.dart';
import 'package:escoge/features/oracion/data/models/liturgia_day_model.dart';
import 'package:escoge/features/oracion/presentation/evangelio_screen.dart';
import 'package:escoge/features/oracion/presentation/santo_del_dia_screen.dart';
import 'package:escoge/features/oracion/services/liturgia_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum _HomeDayTab { hoy, manana }

class _HomeScreenState extends State<HomeScreen> {
  final LiturgiaService _liturgiaService = LiturgiaService();

  LiturgiaDayModel? _data;
  bool _loading = true;
  String? _errorMessage;

  DateTime _selectedDate = DateTime.now();
  _HomeDayTab _selectedTab = _HomeDayTab.hoy;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _loadForDate(DateTime(now.year, now.month, now.day));
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
            ? 'No hay liturgia disponible para esta fecha.'
            : null;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _errorMessage = 'Ocurrió un error al cargar la liturgia.';
      });
    }
  }

  void _changeTab(_HomeDayTab tab) {
    if (_selectedTab == tab) return;

    final now = DateTime.now();

    final date = tab == _HomeDayTab.hoy
        ? DateTime(now.year, now.month, now.day)
        : DateTime(now.year, now.month, now.day + 1);

    setState(() {
      _selectedTab = tab;
    });

    _loadForDate(date);
  }

  LecturaModel? _findLectura(String tipo) {
    try {
      return _data?.lecturas.firstWhere((item) => item.tipo == tipo);
    } catch (_) {
      return null;
    }
  }

  String _preview(String text, {int max = 165}) {
    final clean = text.replaceAll('\n', ' ').trim();
    if (clean.isEmpty) return '';
    if (clean.length <= max) return clean;
    return '${clean.substring(0, max)}...';
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

  void _showComingSoon(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title quedará conectado en la siguiente fase.'),
      ),
    );
  }

  void _openEvangelio() {
    Navigator.push(
      context,
      AppPageRoute(
        page: EvangelioScreen(selectedDate: _selectedDate),
      ),
    );
  }

  void _openSanto() {
    Navigator.push(
      context,
      AppPageRoute(
        page: SantoDelDiaScreen(selectedDate: _selectedDate),
      ),
    );
  }

  void _openCatecismo() {
    Navigator.push(
      context,
      AppPageRoute(
        page: const CatecismoScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final evangelio = _data?.evangelio;
    final santo = _data?.santoDelDia;
    final primeraLectura = _findLectura('primera_lectura');

    final title = _data?.celebracion.trim().isNotEmpty == true
        ? _data!.celebracion.trim()
        : _data?.titulo.trim().isNotEmpty == true
            ? _data!.titulo.trim()
            : 'Liturgia del día';

    final tiempo = _data?.tiempoLiturgico.trim().isNotEmpty == true
        ? _data!.tiempoLiturgico.trim()
        : 'Liturgia diaria';

    return Scaffold(
      backgroundColor: AppColors.lumenBackground,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.screenGradient,
        ),
        child: RefreshIndicator(
          color: AppColors.lumenGold,
          backgroundColor: AppColors.lumenCard,
          onRefresh: () => _loadForDate(_selectedDate),
          child: _loading
              ? const LoadingView(
                  message: 'Cargando liturgia',
                  subtitle: 'Preparando tu experiencia espiritual...',
                )
              : _errorMessage != null
                  ? ErrorStateView(
                      message: _errorMessage!,
                      onRetry: () => _loadForDate(_selectedDate),
                    )
                  : ListView(
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _LumenHeroHeader(
                          selectedTab: _selectedTab,
                          onTabChanged: _changeTab,
                          dateText: _formatLongDate(_selectedDate),
                          title: title,
                          tiempo: tiempo,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 18, 20, 220),
                          child: Column(
                            children: [
                              if (santo != null)
                                _LumenFeatureCard(
                                  icon: PhosphorIcons.user(
                                    PhosphorIconsStyle.fill,
                                  ),
                                  eyebrow: 'Santo del Día',
                                  title: santo.nombre,
                                  body: _preview(
                                    santo.resumen.isNotEmpty
                                        ? santo.resumen
                                        : santo.historia ?? '',
                                    max: 185,
                                  ),
                                  onTap: _openSanto,
                                ),
                              if (santo != null) const SizedBox(height: 18),
                              if (primeraLectura != null)
                                _LumenReadingCard(
                                  number: '1',
                                  title: 'Primera Lectura',
                                  cita: primeraLectura.cita,
                                  text: _preview(
                                    primeraLectura.texto,
                                    max: 210,
                                  ),
                                  onTap: () => _showComingSoon('Lecturas'),
                                ),
                              if (primeraLectura != null)
                                const SizedBox(height: 18),
                              if (evangelio != null)
                                _LumenReadingCard(
                                  number: '✦',
                                  title: 'Evangelio de hoy',
                                  cita: evangelio.cita,
                                  text: _preview(
                                    evangelio.texto,
                                    max: 210,
                                  ),
                                  onTap: _openEvangelio,
                                  gold: true,
                                ),
                              const SizedBox(height: 28),
                              const _SectionHeading(
                                title: 'Acceso rápido',
                                subtitle:
                                    'Tu camino espiritual, formación y encuentro diario.',
                              ),
                              const SizedBox(height: 16),
                              GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                mainAxisSpacing: 14,
                                crossAxisSpacing: 14,
                                childAspectRatio: 1.04,
                                children: [
                                  _QuickAccessCard(
                                    icon: PhosphorIcons.bookOpen(
                                      PhosphorIconsStyle.light,
                                    ),
                                    title: 'Evangelio',
                                    subtitle: 'Lectura principal',
                                    onTap: _openEvangelio,
                                  ),
                                  _QuickAccessCard(
                                    icon: PhosphorIcons.crownSimple(
                                      PhosphorIconsStyle.light,
                                    ),
                                    title: 'Santo',
                                    subtitle: 'Memoria litúrgica',
                                    onTap: _openSanto,
                                  ),
                                  _QuickAccessCard(
                                    icon: PhosphorIcons.bookBookmark(
                                      PhosphorIconsStyle.light,
                                    ),
                                    title: 'Biblia',
                                    subtitle: 'Palabra de Dios',
                                    onTap: () => _showComingSoon('Biblia'),
                                  ),
                                  _QuickAccessCard(
                                    icon: PhosphorIcons.scroll(
                                      PhosphorIconsStyle.light,
                                    ),
                                    title: 'Catecismo',
                                    subtitle: 'Doctrina y formación',
                                    onTap: _openCatecismo,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}

class _LumenHeroHeader extends StatelessWidget {
  final _HomeDayTab selectedTab;
  final ValueChanged<_HomeDayTab> onTabChanged;
  final String dateText;
  final String title;
  final String tiempo;

  const _LumenHeroHeader({
    required this.selectedTab,
    required this.onTabChanged,
    required this.dateText,
    required this.title,
    required this.tiempo,
  });

  String get _heroAsset {
    return selectedTab == _HomeDayTab.hoy
        ? AppAssets.evangelioHoy
        : AppAssets.evangelioManana;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            _heroAsset,
            fit: BoxFit.cover,
            alignment: Alignment.center,
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
                  Colors.black.withValues(alpha: 0.05),
                  Colors.black.withValues(alpha: 0.18),
                  AppColors.lumenBackground.withValues(alpha: 0.86),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.45),
                  radius: 0.85,
                  colors: [
                    AppColors.lumenGold.withValues(alpha: 0.14),
                    Colors.transparent,
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
                      const Spacer(),
                      _DaySelector(
                        selectedTab: selectedTab,
                        onTabChanged: onTabChanged,
                      ),
                      const SizedBox(width: 14),
                      _HeroIconButton(
                        icon: PhosphorIcons.clipboardText(
                          PhosphorIconsStyle.light,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    dateText,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: AppColors.white.withValues(alpha: 0.88),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: AppColors.white,
                      fontSize: 21.5,
                      fontWeight: FontWeight.w800,
                      height: 1.18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
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
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 42),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DaySelector extends StatelessWidget {
  final _HomeDayTab selectedTab;
  final ValueChanged<_HomeDayTab> onTabChanged;

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
          height: 54,
          width: 214,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.20),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: AppColors.lumenGold.withValues(alpha: 0.56),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.lumenGold.withValues(alpha: 0.18),
                blurRadius: 18,
                spreadRadius: -8,
              ),
            ],
          ),
          child: Row(
            children: [
              _DayPill(
                label: 'Hoy',
                selected: selectedTab == _HomeDayTab.hoy,
                onTap: () => onTabChanged(_HomeDayTab.hoy),
              ),
              _DayPill(
                label: 'Mañana',
                selected: selectedTab == _HomeDayTab.manana,
                onTap: () => onTabChanged(_HomeDayTab.manana),
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
                ? AppColors.lumenGold.withValues(alpha: 0.28)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontSize: 15,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroIconButton extends StatelessWidget {
  final IconData icon;

  const _HeroIconButton({
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.22),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.lumenGold.withValues(alpha: 0.28),
            ),
          ),
          child: Icon(
            icon,
            color: AppColors.lumenGoldBright,
            size: 25,
          ),
        ),
      ),
    );
  }
}

class _LumenFeatureCard extends StatelessWidget {
  final IconData icon;
  final String eyebrow;
  final String title;
  final String body;
  final VoidCallback onTap;

  const _LumenFeatureCard({
    required this.icon,
    required this.eyebrow,
    required this.title,
    required this.body,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _LumenGlassShell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.lumenGoldBright, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  eyebrow,
                  style: GoogleFonts.poppins(
                    color: AppColors.lumenGoldBright,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(
                PhosphorIcons.caretRight(PhosphorIconsStyle.light),
                color: AppColors.lumenGoldBright.withValues(alpha: 0.78),
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: AppColors.lumenTextPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            body,
            style: GoogleFonts.poppins(
              color: AppColors.lumenTextSecondary,
              fontSize: 13,
              height: 1.42,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Toca para leer más...',
            style: GoogleFonts.poppins(
              color: AppColors.lumenGoldSoft.withValues(alpha: 0.84),
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _LumenReadingCard extends StatelessWidget {
  final String number;
  final String title;
  final String cita;
  final String text;
  final VoidCallback onTap;
  final bool gold;

  const _LumenReadingCard({
    required this.number,
    required this.title,
    required this.cita,
    required this.text,
    required this.onTap,
    this.gold = false,
  });

  @override
  Widget build(BuildContext context) {
    final accent = gold ? AppColors.lumenGoldBright : const Color(0xFF1DA1FF);

    return _LumenGlassShell(
      onTap: onTap,
      strongerGoldBorder: gold,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: gold
                    ? AppColors.lumenGold.withValues(alpha: 0.92)
                    : AppColors.white.withValues(alpha: 0.70),
                child: Text(
                  number,
                  style: GoogleFonts.poppins(
                    color:
                        gold ? AppColors.lumenBackground : AppColors.lumenCard,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            cita,
            style: GoogleFonts.poppins(
              color: accent,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: AppColors.lumenTextPrimary,
              fontSize: 16,
              height: 1.45,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Toca para leer más...',
            style: GoogleFonts.poppins(
              color: AppColors.lumenGoldSoft.withValues(alpha: 0.82),
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _LumenGlassShell extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool strongerGoldBorder;

  const _LumenGlassShell({
    required this.child,
    required this.onTap,
    this.strongerGoldBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = strongerGoldBorder
        ? AppColors.lumenGold.withValues(alpha: 0.36)
        : AppColors.lumenGold.withValues(alpha: 0.18);

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(30),
            child: Ink(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.lumenCard.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: borderColor,
                  width: strongerGoldBorder ? 1.35 : 1.05,
                ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _LumenGlassShell(
      onTap: onTap,
      strongerGoldBorder: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.lumenGoldBright, size: 25),
          const Spacer(),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              color: AppColors.lumenTextMuted,
              fontSize: 12,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeading({
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
          style: GoogleFonts.lora(
            color: AppColors.white,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            color: AppColors.lumenTextSecondary,
            fontSize: 13.5,
            height: 1.45,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
