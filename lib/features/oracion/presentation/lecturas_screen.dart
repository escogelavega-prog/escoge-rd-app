import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/oracion/data/models/liturgia_day_model.dart';
import 'package:escoge/features/oracion/services/liturgia_service.dart';
import 'package:escoge/features/oracion/widgets/glass_spiritual_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LecturasScreen extends StatefulWidget {
  final DateTime? selectedDate;

  const LecturasScreen({
    super.key,
    this.selectedDate,
  });

  @override
  State<LecturasScreen> createState() => _LecturasScreenState();
}

class _LecturasScreenState extends State<LecturasScreen>
    with SingleTickerProviderStateMixin {
  final LiturgiaService _liturgiaService = LiturgiaService();

  LiturgiaDayModel? _data;
  bool _loading = true;
  String? _errorMessage;
  int currentTab = 0;

  final List<String> tabs = const [
    'Santo',
    '1.ª',
    'Salmo',
    '2.ª',
    'Evangelio',
    'Reflexión',
  ];

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
      final result = await _liturgiaService.getLiturgiaByDate(targetDate);

      if (!mounted) return;

      setState(() {
        _data = result;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _errorMessage = 'No se pudieron cargar las lecturas.';
      });
    }
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
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.85),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: _loading
                ? _loadingView()
                : _errorMessage != null
                    ? _errorView()
                    : _content(context),
          ),
        ],
      ),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      children: [
        _topBar(context),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _heroCard(),
        ),
        const SizedBox(height: 14),
        _tabs(),
        const SizedBox(height: 12),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 320),
            child: _sectionContent(),
          ),
        ),
      ],
    );
  }

  Widget _topBar(BuildContext context) {
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
              ),
              child: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _data?.celebracion ?? 'Lecturas del día',
              textAlign: TextAlign.center,
              style: GoogleFonts.lora(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _heroCard() {
    return GlassSpiritualCard(
      radius: 30,
      blur: 18,
      child: Text(
        _data?.tiempoLiturgico ?? 'Liturgia diaria',
        style: GoogleFonts.lora(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _tabs() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final selected = currentTab == index;

          return GestureDetector(
            onTap: () => setState(() => currentTab = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: selected
                    ? AppColors.lumenGold.withValues(alpha: 0.2)
                    : AppColors.white.withValues(alpha: 0.05),
              ),
              alignment: Alignment.center,
              child: Text(
                tabs[index],
                style: GoogleFonts.poppins(
                  color: selected ? AppColors.lumenGoldBright : Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _sectionContent() {
    final section = _getSection();

    return SingleChildScrollView(
      key: ValueKey(currentTab),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 34),
      child: GlassSpiritualCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section['label'] ?? '',
              style: GoogleFonts.poppins(
                color: AppColors.lumenGold,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            if ((section['cita'] ?? '').isNotEmpty)
              Text(
                section['cita']!,
                style: GoogleFonts.poppins(
                  color: AppColors.gold,
                ),
              ),
            const SizedBox(height: 16),
            Text(
              section['titulo'] ?? '',
              style: GoogleFonts.lora(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              section['texto'] ?? '',
              style: GoogleFonts.lora(
                color: Colors.white.withValues(alpha: 0.95),
                fontSize: 18,
                height: 1.8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loadingView() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.lumenGold),
    );
  }

  Widget _errorView() {
    return Center(
      child: GlassSpiritualCard(
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Map<String, String> _getSection() {
    switch (currentTab) {
      case 0:
        return {
          'label': 'Santo del día',
          'titulo': _data?.santoDelDia?.nombre ?? '',
          'texto': _data?.santoDelDia?.resumen ?? '',
        };
      case 1:
        return _lectura('Primera Lectura', 'primera_lectura');
      case 2:
        return _lectura('Salmo', 'salmo');
      case 3:
        return _lectura('Segunda Lectura', 'segunda_lectura');
      case 4:
        return {
          'label': 'Evangelio',
          'cita': _data?.evangelio?.cita ?? '',
          'titulo': _data?.evangelio?.titulo ?? '',
          'texto': _data?.evangelio?.texto ?? '',
        };
      case 5:
        return {
          'label': 'Reflexión',
          'titulo': 'Reflexión del día',
          'texto': _data?.reflexionBreve ?? '',
        };
      default:
        return {};
    }
  }

  Map<String, String> _lectura(String label, String tipo) {
    final lectura =
        _data?.lecturas.where((e) => e.tipo == tipo).isNotEmpty == true
            ? _data!.lecturas.firstWhere((e) => e.tipo == tipo)
            : null;

    return {
      'label': label,
      'cita': lectura?.cita ?? '',
      'titulo': lectura?.titulo ?? '',
      'texto': lectura?.texto ?? '',
    };
  }
}
