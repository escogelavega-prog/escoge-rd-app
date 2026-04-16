import 'dart:ui';

import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/oracion/data/models/rosario_misterio_model.dart';
import 'package:escoge/features/oracion/services/rosario_data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class RosarioRezoScreen extends StatefulWidget {
  const RosarioRezoScreen({
    super.key,
    required this.tipoMisterio,
  });

  final String tipoMisterio;

  @override
  State<RosarioRezoScreen> createState() => _RosarioRezoScreenState();
}

class _RosarioRezoScreenState extends State<RosarioRezoScreen> {
  late final List<RosarioMisterioModel> _misterios;
  late final List<String> _pasosBase;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _prayerKey = GlobalKey();

  int _currentMisterioIndex = 0;
  int _currentPasoIndex = 0;

  @override
  void initState() {
    super.initState();
    _misterios = RosarioDataService.getMisterios(widget.tipoMisterio);
    _pasosBase = RosarioDataService.pasosBase;
  }

  void _scrollToPrayer() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _prayerKey.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeInOut,
          alignment: 0.18,
        );
      }
    });
  }

  void _nextPaso() {
    final current = _pasosBase[_currentPasoIndex];

    if (current == 'Ave María') {
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.selectionClick();
    }

    if (_currentPasoIndex < _pasosBase.length - 1) {
      setState(() => _currentPasoIndex++);
      _scrollToPrayer();
      return;
    }

    if (_currentMisterioIndex < _misterios.length - 1) {
      setState(() {
        _currentMisterioIndex++;
        _currentPasoIndex = 0;
      });
      _scrollToPrayer();
      return;
    }

    _showFinishedDialog();
  }

  void _previousPaso() {
    HapticFeedback.selectionClick();

    if (_currentPasoIndex > 0) {
      setState(() => _currentPasoIndex--);
      _scrollToPrayer();
      return;
    }

    if (_currentMisterioIndex > 0) {
      setState(() {
        _currentMisterioIndex--;
        _currentPasoIndex = _pasosBase.length - 1;
      });
      _scrollToPrayer();
    }
  }

  void _showFinishedDialog() {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF14214A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Text(
          'Rosario completado',
          style: GoogleFonts.lora(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Has finalizado este recorrido del Santo Rosario.',
          style: GoogleFonts.poppins(
            color: AppColors.white.withValues(alpha: 0.78),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cerrar',
              style: GoogleFonts.poppins(
                color: AppColors.white,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentMisterioIndex = 0;
                _currentPasoIndex = 0;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentBlue,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
  }

  double get _globalProgress {
    final total = _misterios.length * _pasosBase.length;
    final current =
        (_currentMisterioIndex * _pasosBase.length) + _currentPasoIndex + 1;
    return current / total;
  }

  int get _currentAveMariaNumber {
    if (_pasosBase[_currentPasoIndex] != 'Ave María') return 0;

    int count = 0;
    for (int i = 0; i <= _currentPasoIndex; i++) {
      if (_pasosBase[i] == 'Ave María') count++;
    }

    return count;
  }

  int get _activeBeadsCount {
    final current = _pasosBase[_currentPasoIndex];

    if (current == 'Padre Nuestro') return 0;
    if (current == 'Gloria' || current == 'Jaculatoria') return 10;
    if (current != 'Ave María') return 0;

    int count = 0;
    for (int i = 0; i <= _currentPasoIndex; i++) {
      if (_pasosBase[i] == 'Ave María') {
        count++;
      }
    }

    return count.clamp(0, 10);
  }

  @override
  Widget build(BuildContext context) {
    final misterio = _misterios[_currentMisterioIndex];
    final pasoActual = _pasosBase[_currentPasoIndex];

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
                    Colors.black.withValues(alpha: 0.22),
                    Colors.black.withValues(alpha: 0.30),
                    Colors.black.withValues(alpha: 0.52),
                    Colors.black.withValues(alpha: 0.76),
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
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 96),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const _Header(),
                  const SizedBox(height: 14),
                  _MisterioHeroCard(misterio: misterio),
                  const SizedBox(height: 14),
                  _RosarioBeadsRow(activeCount: _activeBeadsCount),
                  const SizedBox(height: 14),
                  Text(
                    pasoActual,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pasoActual == 'Ave María'
                        ? '$_currentAveMariaNumber de 10'
                        : 'Paso ${_currentPasoIndex + 1} de ${_pasosBase.length}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      color: AppColors.white.withValues(alpha: 0.72),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ProgressSection(progress: _globalProgress),
                  const SizedBox(height: 14),
                  Container(
                    key: _prayerKey,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 320),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.06),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: _PrayerTextCard(
                        key: ValueKey(
                          '${_currentMisterioIndex}_$_currentPasoIndex',
                        ),
                        text: RosarioDataService.getPrayerText(pasoActual),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: (_currentMisterioIndex == 0 &&
                                  _currentPasoIndex == 0)
                              ? null
                              : _previousPaso,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppColors.white.withValues(
                              alpha: 0.06,
                            ),
                            foregroundColor: AppColors.white,
                            side: BorderSide(
                              color: AppColors.white.withValues(alpha: 0.75),
                              width: 1.2,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Anterior',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _nextPaso,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentBlue,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Siguiente',
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withValues(alpha: 0.08),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.08),
              ),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.white,
              size: 18,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Rezar el Rosario',
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ),
        const SizedBox(width: 46),
      ],
    );
  }
}

class _MisterioHeroCard extends StatelessWidget {
  final RosarioMisterioModel misterio;

  const _MisterioHeroCard({
    required this.misterio,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Stack(
        children: [
          SizedBox(
            height: 205,
            width: double.infinity,
            child: Image.asset(
              misterio.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  color: AppColors.white.withValues(alpha: 0.08),
                  alignment: Alignment.center,
                  child: Text(
                    'No se pudo cargar la imagen',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: AppColors.white.withValues(alpha: 0.72),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.14),
                    Colors.black.withValues(alpha: 0.24),
                    AppColors.primaryBlue.withValues(alpha: 0.52),
                    Colors.black.withValues(alpha: 0.84),
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
            bottom: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  misterio.tituloCorto,
                  style: GoogleFonts.poppins(
                    color: AppColors.goldSoft,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  misterio.titulo,
                  style: GoogleFonts.lora(
                    color: AppColors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    height: 1.08,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  misterio.subtitulo,
                  style: GoogleFonts.poppins(
                    color: AppColors.white.withValues(alpha: 0.84),
                    height: 1.45,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
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

class _RosarioBeadsRow extends StatelessWidget {
  final int activeCount;

  const _RosarioBeadsRow({
    required this.activeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 28,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(10, (index) {
            final active = index < activeCount;

            return Padding(
              padding: EdgeInsets.only(right: index == 9 ? 0 : 6),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOut,
                width: active ? 18 : 16,
                height: active ? 18 : 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active
                      ? AppColors.gold
                      : AppColors.white.withValues(alpha: 0.24),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: AppColors.gold.withValues(alpha: 0.35),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  final double progress;

  const _ProgressSection({
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).round();

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 12,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.white.withValues(alpha: 0.18),
                valueColor: const AlwaysStoppedAnimation(AppColors.gold),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '$pct%',
          style: GoogleFonts.poppins(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

class _PrayerTextCard extends StatelessWidget {
  final String text;

  const _PrayerTextCard({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 520,
            ),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: GoogleFonts.lora(
                fontSize: 15.8,
                height: 1.72,
                color: AppColors.white.withValues(alpha: 0.92),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
