import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:escoge/features/contenido/data/models/catecismo_item_model.dart';
import 'package:escoge/features/contenido/data/repositories/catecismo_progress_repository.dart';
import 'package:escoge/features/contenido/data/services/catecismo_local_service.dart';

class CatecismoScreen extends StatefulWidget {
  const CatecismoScreen({super.key});

  @override
  State<CatecismoScreen> createState() => _CatecismoScreenState();
}

class _CatecismoScreenState extends State<CatecismoScreen> {
  static const String _logoAsset = 'assets/images/logo_escoge.png';

  final CatecismoProgressRepository _progressRepository =
      CatecismoProgressRepository();

  final List<CatecismoItemModel> _items =
      const CatecismoLocalService().getItems();

  int _currentIndex = 0;
  bool _isLoadingProgress = true;

  CatecismoItemModel get _currentItem => _items[_currentIndex];

  @override
  void initState() {
    super.initState();
    _loadSavedProgress();
  }

  Future<void> _loadSavedProgress() async {
    final progress = await _progressRepository.getProgress();

    if (!mounted) return;

    if (progress != null &&
        progress.currentIndex >= 0 &&
        progress.currentIndex < _items.length) {
      setState(() {
        _currentIndex = progress.currentIndex;
        _isLoadingProgress = false;
      });
    } else {
      setState(() {
        _isLoadingProgress = false;
      });
    }
  }

  Future<void> _saveCurrentProgress() async {
    final item = _currentItem;

    await _progressRepository.saveProgress(
      currentIndex: _currentIndex,
      currentNumero: item.numero,
      currentTitulo: item.titulo.replaceAll('\n', ' '),
    );
  }

  Future<void> _goNext() async {
    if (_currentIndex >= _items.length - 1) return;

    setState(() {
      _currentIndex++;
    });

    await _saveCurrentProgress();
  }

  Future<void> _goPrevious() async {
    if (_currentIndex <= 0) return;

    setState(() {
      _currentIndex--;
    });

    await _saveCurrentProgress();
  }

  @override
  Widget build(BuildContext context) {
    const Color deepBlue = Color(0xFF112C7A);
    const Color royalBlue = Color(0xFF1E46A3);
    const Color gold = Color(0xFFD9A62E);
    const Color bg = Color(0xFFF1F4FB);
    const Color summaryBg = Color(0xFFF6EFE2);
    const Color explanationBg = Color(0xFFEAF0FF);
    const Color exampleBg = Color(0xFFEAF7EE);
    const Color applicationBg = Color(0xFFF7F1E4);
    const Color reflectionBg = Color(0xFFEFF2FF);
    const Color textDark = Color(0xFF1E2746);
    const Color green = Color(0xFF21764A);

    if (_isLoadingProgress) {
      return const Scaffold(
        backgroundColor: bg,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [deepBlue, royalBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Image.asset(
                  _logoAsset,
                  height: 50,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Text(
                    'ESCOGE',
                    style: GoogleFonts.lora(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                children: [
                  _HeroCatecismoCard(item: _currentItem),
                  const SizedBox(height: 16),
                  _SummaryCard(
                    title: 'RESUMEN',
                    text: _currentItem.resumen,
                    backgroundColor: summaryBg,
                    iconBg: gold,
                    iconColor: Colors.white,
                    titleColor: const Color(0xFFC9961D),
                  ),
                  const SizedBox(height: 14),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 700) {
                        return Column(
                          children: [
                            _InfoCard(
                              title: 'EXPLICACIÓN CLARA Y SENCILLA',
                              text: _currentItem.explicacion,
                              backgroundColor: explanationBg,
                              titleColor: royalBlue,
                              icon: Icons.psychology_alt_rounded,
                              iconBg: royalBlue,
                              iconColor: Colors.white,
                            ),
                            const SizedBox(height: 12),
                            _InfoCard(
                              title: 'EJEMPLO PARA JÓVENES',
                              text: _currentItem.ejemplo,
                              backgroundColor: exampleBg,
                              titleColor: green,
                              icon: Icons.lightbulb_rounded,
                              iconBg: green,
                              iconColor: Colors.white,
                            ),
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _InfoCard(
                              title: 'EXPLICACIÓN CLARA Y SENCILLA',
                              text: _currentItem.explicacion,
                              backgroundColor: explanationBg,
                              titleColor: royalBlue,
                              icon: Icons.psychology_alt_rounded,
                              iconBg: royalBlue,
                              iconColor: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _InfoCard(
                              title: 'EJEMPLO PARA JÓVENES',
                              text: _currentItem.ejemplo,
                              backgroundColor: exampleBg,
                              titleColor: green,
                              icon: Icons.lightbulb_rounded,
                              iconBg: green,
                              iconColor: Colors.white,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  _AplicacionCard(
                    aplicacion: _currentItem.aplicacion,
                    reflexion: _currentItem.reflexion,
                    backgroundColor: applicationBg,
                    reflectionBg: reflectionBg,
                    titleColor: const Color(0xFFC9961D),
                    deepBlue: deepBlue,
                    gold: gold,
                    textDark: textDark,
                    royalBlue: royalBlue,
                  ),
                  const SizedBox(height: 18),
                  _NextPreviewCard(
                    currentIndex: _currentIndex,
                    items: _items,
                  ),
                  const SizedBox(height: 20),
                  _NavigationButtons(
                    canGoBack: _currentIndex > 0,
                    canGoNext: _currentIndex < _items.length - 1,
                    onBack: _goPrevious,
                    onNext: _goNext,
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

class _HeroCatecismoCard extends StatelessWidget {
  const _HeroCatecismoCard({
    required this.item,
  });

  final CatecismoItemModel item;

  @override
  Widget build(BuildContext context) {
    const Color deepBlue = Color(0xFF112C7A);
    const Color gold = Color(0xFFD9A62E);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A143D8D),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: 245,
              child: Image.asset(
                item.heroImageAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF112C7A), Color(0xFF1E46A3)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 245,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    deepBlue.withValues(alpha: 0.92),
                    deepBlue.withValues(alpha: 0.76),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.55, 1.0],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            Positioned(
              left: 18,
              top: 18,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.16),
                  ),
                ),
                child: Text(
                  item.parte,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CIC ${item.numero}',
                    style: GoogleFonts.poppins(
                      color: gold,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.titulo,
                    style: GoogleFonts.lora(
                      color: Colors.white,
                      fontSize: 31,
                      fontWeight: FontWeight.w700,
                      height: 0.98,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.subtitulo,
                    style: GoogleFonts.poppins(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
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

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.text,
    required this.backgroundColor,
    required this.iconBg,
    required this.iconColor,
    required this.titleColor,
  });

  final String title;
  final String text;
  final Color backgroundColor;
  final Color iconBg;
  final Color iconColor;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: titleColor.withValues(alpha: 0.16),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.fact_check_outlined,
              color: iconColor,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: titleColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  text,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF1E2746),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.text,
    required this.backgroundColor,
    required this.titleColor,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });

  final String title;
  final String text;
  final Color backgroundColor;
  final Color titleColor;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 28,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: titleColor,
              fontSize: 13.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: const Color(0xFF1E2746),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _AplicacionCard extends StatelessWidget {
  const _AplicacionCard({
    required this.aplicacion,
    required this.reflexion,
    required this.backgroundColor,
    required this.reflectionBg,
    required this.titleColor,
    required this.deepBlue,
    required this.gold,
    required this.textDark,
    required this.royalBlue,
  });

  final String aplicacion;
  final String reflexion;
  final Color backgroundColor;
  final Color reflectionBg;
  final Color titleColor;
  final Color deepBlue;
  final Color gold;
  final Color textDark;
  final Color royalBlue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: gold.withValues(alpha: 0.22),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: gold,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.task_alt_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'APLICACIÓN EN LA VIDA DIARIA',
                  style: GoogleFonts.poppins(
                    color: titleColor,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 360;

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hoy puedes empezar recordando esto:',
                      style: GoogleFonts.poppins(
                        color: textDark,
                        fontSize: 13.8,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '“$aplicacion”',
                      style: GoogleFonts.lora(
                        color: deepBlue,
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        height: 1.12,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _ReflectionMiniCard(
                      reflexion: reflexion,
                      reflectionBg: reflectionBg,
                      royalBlue: royalBlue,
                      textDark: textDark,
                      gold: gold,
                    ),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hoy puedes empezar recordando esto:',
                            style: GoogleFonts.poppins(
                              color: textDark,
                              fontSize: 13.8,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '“$aplicacion”',
                            style: GoogleFonts.lora(
                              color: deepBlue,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              height: 1.14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: _ReflectionMiniCard(
                      reflexion: reflexion,
                      reflectionBg: reflectionBg,
                      royalBlue: royalBlue,
                      textDark: textDark,
                      gold: gold,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ReflectionMiniCard extends StatelessWidget {
  const _ReflectionMiniCard({
    required this.reflexion,
    required this.reflectionBg,
    required this.royalBlue,
    required this.textDark,
    required this.gold,
  });

  final String reflexion;
  final Color reflectionBg;
  final Color royalBlue;
  final Color textDark;
  final Color gold;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: reflectionBg,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'PARA REFLEXIONAR',
                  style: GoogleFonts.poppins(
                    color: royalBlue,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(
                Icons.favorite_rounded,
                color: gold,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            reflexion,
            style: GoogleFonts.poppins(
              color: textDark,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _NextPreviewCard extends StatelessWidget {
  const _NextPreviewCard({
    required this.currentIndex,
    required this.items,
  });

  final int currentIndex;
  final List<CatecismoItemModel> items;

  @override
  Widget build(BuildContext context) {
    const Color deepBlue = Color(0xFF112C7A);
    const Color cardBg = Color(0xFFE7ECFF);
    const Color textDark = Color(0xFF1E2746);

    final bool hasNext = currentIndex < items.length - 1;
    final String text = hasNext
        ? 'PRÓXIMO: CIC ${items[currentIndex + 1].numero} · ${items[currentIndex + 1].titulo.replaceAll('\n', ' ')}'
        : 'Has llegado al último párrafo cargado por ahora.';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: deepBlue.withValues(alpha: 0.10),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: deepBlue,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                color: textDark,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.42,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationButtons extends StatelessWidget {
  const _NavigationButtons({
    required this.canGoBack,
    required this.canGoNext,
    required this.onBack,
    required this.onNext,
  });

  final bool canGoBack;
  final bool canGoNext;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    const Color deepBlue = Color(0xFF112C7A);
    const Color royalBlue = Color(0xFF1E46A3);
    const Color gold = Color(0xFFD9A62E);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 360;

        if (isNarrow) {
          return Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: canGoBack ? onBack : null,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: deepBlue.withValues(alpha: 0.20),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'ANTERIOR',
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        color: deepBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [deepBlue, royalBlue],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x260B1E66),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: canGoNext ? onNext : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      disabledBackgroundColor: Colors.transparent,
                      disabledForegroundColor: Colors.white70,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            'SIGUIENTE PÁRRAFO',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: gold,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return Row(
          children: [
            SizedBox(
              width: 114,
              height: 54,
              child: OutlinedButton(
                onPressed: canGoBack ? onBack : null,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: deepBlue.withValues(alpha: 0.20),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'ANTERIOR',
                    maxLines: 1,
                    style: GoogleFonts.poppins(
                      color: deepBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 56,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [deepBlue, royalBlue],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x260B1E66),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: canGoNext ? onNext : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      disabledBackgroundColor: Colors.transparent,
                      disabledForegroundColor: Colors.white70,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            'SIGUIENTE PÁRRAFO',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: gold,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
