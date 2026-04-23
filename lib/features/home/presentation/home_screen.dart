import 'dart:ui';

import 'package:escoge/app/routes/app_page_route.dart';
import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/contenido/presentation/catecismo_screen.dart';
import 'package:escoge/features/oracion/data/models/lectura_model.dart';
import 'package:escoge/features/oracion/data/models/liturgia_day_model.dart';
import 'package:escoge/features/oracion/presentation/evangelio_screen.dart';
import 'package:escoge/features/oracion/presentation/santo_del_dia_screen.dart';
import 'package:escoge/features/oracion/services/liturgia_service.dart';
import 'package:escoge/features/oracion/widgets/glass_spiritual_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LiturgiaService _liturgiaService = LiturgiaService();

  LiturgiaDayModel? _data;
  bool _loading = true;
  String? _errorMessage;
  DateTime _selectedDate = DateTime.now();

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

  LecturaModel? _findLectura(String tipo) {
    try {
      return _data?.lecturas.firstWhere((item) => item.tipo == tipo);
    } catch (_) {
      return null;
    }
  }

  String _preview(String text, {int max = 145}) {
    final clean = text.replaceAll('\n', ' ').trim();
    if (clean.isEmpty) return '';
    if (clean.length <= max) return clean;
    return '${clean.substring(0, max)}...';
  }

  String _formatDate(DateTime date) {
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
    final versiculo = _data?.versiculoDelDia;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.screenGradient,
        ),
        child: Stack(
          children: [
            Positioned(
              top: -120,
              left: -40,
              child: _GlowOrb(
                size: 260,
                color: AppColors.lumenBlueGlow.withValues(alpha: 0.34),
              ),
            ),
            Positioned(
              top: 80,
              right: -70,
              child: _GlowOrb(
                size: 240,
                color: AppColors.lumenGold.withValues(alpha: 0.12),
              ),
            ),
            Positioned(
              bottom: -40,
              left: -20,
              child: _GlowOrb(
                size: 220,
                color: AppColors.lumenPurpleGlow.withValues(alpha: 0.22),
              ),
            ),
            SafeArea(
              child: RefreshIndicator(
                color: AppColors.lumenGold,
                onRefresh: () => _loadForDate(_selectedDate),
                child: _loading
                    ? const _LoadingView()
                    : _errorMessage != null
                        ? _ErrorView(
                            message: _errorMessage!,
                            onRetry: () => _loadForDate(_selectedDate),
                          )
                        : ListView(
                            padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
                            physics: const BouncingScrollPhysics(),
                            children: [
                              _HomeTopBar(
                                subtitle: _formatDate(_selectedDate),
                              ),
                              const SizedBox(height: 20),
                              GlassSpiritualCard(
                                radius: 32,
                                blur: 18,
                                fillOpacity: 0.08,
                                borderOpacity: 0.12,
                                padding: const EdgeInsets.all(22),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 7,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.lumenGold
                                            .withValues(alpha: 0.12),
                                        borderRadius:
                                            BorderRadius.circular(999),
                                        border: Border.all(
                                          color: AppColors.lumenGold
                                              .withValues(alpha: 0.22),
                                        ),
                                      ),
                                      child: Text(
                                        _data?.tiempoLiturgico.isNotEmpty ==
                                                true
                                            ? _data!.tiempoLiturgico
                                            : 'Liturgia del día',
                                        style: GoogleFonts.poppins(
                                          color: AppColors.lumenGoldSoft,
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      _data?.celebracion.isNotEmpty == true
                                          ? _data!.celebracion
                                          : 'Encuentro diario con la Palabra',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      _data?.reflexionBreve
                                                  ?.trim()
                                                  .isNotEmpty ==
                                              true
                                          ? _data!.reflexionBreve!.trim()
                                          : 'Una experiencia contemplativa para leer, meditar y orar cada día.',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    if (versiculo?.texto.trim().isNotEmpty ==
                                        true) ...[
                                      const SizedBox(height: 18),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: AppColors.white
                                              .withValues(alpha: 0.05),
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          border: Border.all(
                                            color: AppColors.white
                                                .withValues(alpha: 0.08),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Versículo del día',
                                              style: GoogleFonts.poppins(
                                                color:
                                                    AppColors.lumenGoldBright,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              '“${versiculo!.texto}”',
                                              style: GoogleFonts.lora(
                                                color:
                                                    AppColors.lumenTextPrimary,
                                                fontSize: 17,
                                                height: 1.5,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            if (versiculo.cita
                                                .trim()
                                                .isNotEmpty) ...[
                                              const SizedBox(height: 8),
                                              Text(
                                                versiculo.cita,
                                                style: GoogleFonts.poppins(
                                                  color:
                                                      AppColors.lumenTextMuted,
                                                  fontSize: 12.5,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(height: 22),
                              Text(
                                'Acceso rápido',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              const SizedBox(height: 14),
                              GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                mainAxisSpacing: 14,
                                crossAxisSpacing: 14,
                                childAspectRatio: 1.08,
                                children: [
                                  _QuickAccessCard(
                                    icon: PhosphorIcons.bookOpen(
                                        PhosphorIconsStyle.light),
                                    title: 'Evangelio',
                                    subtitle: 'Lectura principal del día',
                                    onTap: _openEvangelio,
                                  ),
                                  _QuickAccessCard(
                                    icon: PhosphorIcons.crownSimple(
                                        PhosphorIconsStyle.light),
                                    title: 'Santo del día',
                                    subtitle: 'Vida, frase y memoria litúrgica',
                                    onTap: _openSanto,
                                  ),
                                  _QuickAccessCard(
                                    icon: PhosphorIcons.bookBookmark(
                                        PhosphorIconsStyle.light),
                                    title: 'Biblia',
                                    subtitle: 'Preparada para Firestore',
                                    onTap: () => _showComingSoon('Biblia'),
                                  ),
                                  _QuickAccessCard(
                                    icon: PhosphorIcons.scroll(
                                        PhosphorIconsStyle.light),
                                    title: 'Catecismo',
                                    subtitle: 'Navegación doctrinal premium',
                                    onTap: _openCatecismo,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              if (evangelio != null)
                                _SectionPreviewCard(
                                  eyebrow: 'Evangelio de hoy',
                                  title: evangelio.cita.isNotEmpty
                                      ? evangelio.cita
                                      : 'Palabra del Señor',
                                  content: _preview(evangelio.texto),
                                  icon: PhosphorIcons.bookOpenText(
                                      PhosphorIconsStyle.light),
                                  onTap: _openEvangelio,
                                ),
                              if (primeraLectura != null) ...[
                                const SizedBox(height: 16),
                                _SectionPreviewCard(
                                  eyebrow: 'Primera lectura',
                                  title: primeraLectura.cita,
                                  content: _preview(primeraLectura.texto),
                                  icon: PhosphorIcons.article(
                                      PhosphorIconsStyle.light),
                                  onTap: () => _showComingSoon('Lecturas'),
                                ),
                              ],
                              if (santo != null) ...[
                                const SizedBox(height: 16),
                                _SectionPreviewCard(
                                  eyebrow: 'Memoria del día',
                                  title: santo.nombre,
                                  content: _preview(
                                    santo.resumen.isNotEmpty
                                        ? santo.resumen
                                        : santo.historia ?? '',
                                  ),
                                  icon: PhosphorIcons.sparkle(
                                      PhosphorIconsStyle.light),
                                  onTap: _openSanto,
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

class _HomeTopBar extends StatelessWidget {
  final String subtitle;

  const _HomeTopBar({
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white.withValues(alpha: 0.06),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Icon(
            PhosphorIcons.sunHorizon(PhosphorIconsStyle.light),
            color: AppColors.lumenGold,
            size: 24,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Escoge RD',
                style: GoogleFonts.lora(
                  color: AppColors.lumenTextPrimary,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  color: AppColors.lumenTextMuted,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            PhosphorIcons.bellSimple(PhosphorIconsStyle.light),
            color: AppColors.lumenTextSecondary,
          ),
        ),
      ],
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
    return GlassSpiritualCard(
      onTap: onTap,
      radius: 28,
      blur: 16,
      fillOpacity: 0.07,
      borderOpacity: 0.10,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.lumenGold.withValues(alpha: 0.12),
              border: Border.all(
                color: AppColors.lumenGold.withValues(alpha: 0.18),
              ),
            ),
            child: Icon(
              icon,
              color: AppColors.lumenGoldSoft,
              size: 22,
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: AppColors.lumenTextPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: AppColors.lumenTextMuted,
              fontSize: 12.5,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionPreviewCard extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String content;
  final IconData icon;
  final VoidCallback onTap;

  const _SectionPreviewCard({
    required this.eyebrow,
    required this.title,
    required this.content,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassSpiritualCard(
      onTap: onTap,
      radius: 28,
      blur: 16,
      fillOpacity: 0.07,
      borderOpacity: 0.11,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withValues(alpha: 0.06),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Icon(
              icon,
              color: AppColors.lumenGoldBright,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eyebrow,
                  style: GoogleFonts.poppins(
                    color: AppColors.lumenGoldBright,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: GoogleFonts.lora(
                    color: AppColors.lumenTextPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  content,
                  style: GoogleFonts.poppins(
                    color: AppColors.lumenTextSecondary,
                    fontSize: 13.5,
                    height: 1.65,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            PhosphorIcons.caretRight(PhosphorIconsStyle.light),
            color: AppColors.lumenTextMuted,
            size: 18,
          ),
        ],
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

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: CircularProgressIndicator(
          color: AppColors.lumenGold,
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
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
                PhosphorIcons.warningCircle(PhosphorIconsStyle.light),
                color: AppColors.lumenGold,
                size: 34,
              ),
              const SizedBox(height: 14),
              Text(
                'No se pudo cargar',
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
                  onPressed: onRetry,
                  child: const Text('Reintentar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
