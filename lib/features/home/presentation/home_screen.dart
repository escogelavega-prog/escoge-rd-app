import 'dart:ui';

import 'package:escoge/app/routes/app_page_route.dart';
import 'package:escoge/core/theme/app_backgrounds.dart';
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
    _loadForDate(DateTime.now());
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
                          title: _data?.celebracion.isNotEmpty == true
                              ? _data!.celebracion
                              : 'Liturgia del día',
                          tiempo: _data?.tiempoLiturgico.isNotEmpty == true
                              ? _data!.tiempoLiturgico
                              : 'Pascua',
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 18, 20, 130),
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
                              const SizedBox(height: 26),
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 430,
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
                  Colors.black.withValues(alpha: 0.08),
                  Colors.black.withValues(alpha: 0.20),
                  AppColors.lumenBackground.withValues(alpha: 0.96),
                ],
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
                      const SizedBox(width: 16),
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
                      color: AppColors.lumenTextPrimary.withValues(alpha: 0.88),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
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
                      height: 1.22,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
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
                  const SizedBox(height: 34),
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
          height: 58,
          width: 230,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: AppColors.lumenGold.withValues(alpha: 0.50),
            ),
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
                ? AppColors.white.withValues(alpha: 0.20)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
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
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.20),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.10),
            ),
          ),
          child: Icon(
            icon,
            color: AppColors.lumenGoldBright,
            size: 26,
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
                    color: AppColors.lumenTextMuted,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                PhosphorIcons.caretRight(PhosphorIconsStyle.light),
                color: AppColors.lumenTextMuted,
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
              color: AppColors.lumenTextMuted,
              fontSize: 13,
              height: 1.42,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Toca para leer más...',
            style: GoogleFonts.poppins(
              color: AppColors.lumenTextMuted.withValues(alpha: 0.82),
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.white.withValues(alpha: 0.70),
                child: Text(
                  number,
                  style: GoogleFonts.poppins(
                    color: AppColors.lumenBackground,
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    Icon(
                      PhosphorIcons.lockSimple(PhosphorIconsStyle.fill),
                      color: AppColors.lumenGold,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Escuchar',
                      style: GoogleFonts.poppins(
                        color: AppColors.lumenGold,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
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
              color: AppColors.lumenTextMuted,
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
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

  const _LumenGlassShell({
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                color: AppColors.lumenCard.withValues(alpha: 0.70),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: AppColors.glassStroke.withValues(alpha: 0.80),
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
