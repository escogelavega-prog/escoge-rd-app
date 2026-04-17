import 'dart:math' as math;

import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/oracion/data/models/rosario_misterio_model.dart';
import 'package:escoge/features/oracion/services/rosario_audio_service.dart';
import 'package:escoge/features/oracion/services/rosario_data_service.dart';
import 'package:escoge/features/oracion/widgets/glass_spiritual_card.dart';
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

class _RosarioRezoScreenState extends State<RosarioRezoScreen>
    with TickerProviderStateMixin {
  late final List<RosarioMisterioModel> _misterios;
  late final List<String> _pasosBase;

  late final AnimationController _backgroundController;
  late final Animation<double> _backgroundScale;
  late final AnimationController _particlesController;

  final RosarioAudioService _audioService = RosarioAudioService.instance;

  int _currentMisterioIndex = 0;
  int _currentPasoIndex = 0;

  bool _soundEnabled = true;
  double _soundVolume = 0.22;

  @override
  void initState() {
    super.initState();

    _misterios = RosarioDataService.getMisterios(widget.tipoMisterio);
    _pasosBase = RosarioDataService.pasosBase;

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat(reverse: true);

    _backgroundScale = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(
      CurvedAnimation(
        parent: _backgroundController,
        curve: Curves.easeInOut,
      ),
    );

    _particlesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _initAmbientAudio();
  }

  Future<void> _initAmbientAudio() async {
    await Future.delayed(const Duration(milliseconds: 350));
    await _audioService.init();

    if (_soundEnabled) {
      await _audioService.playAmbientForMysteryType(
        widget.tipoMisterio,
        volume: _soundVolume,
        forceNewVariant: true,
      );
    }

    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _particlesController.dispose();
    _audioService.stopAmbient();
    super.dispose();
  }

  RosarioMisterioModel get _misterioActual => _misterios[_currentMisterioIndex];
  String get _pasoActual => _pasosBase[_currentPasoIndex];

  double get _globalProgress {
    final total = _misterios.length * _pasosBase.length;
    final current =
        (_currentMisterioIndex * _pasosBase.length) + _currentPasoIndex + 1;
    return current / total;
  }

  int get _currentAveMariaNumber {
    if (_pasoActual != 'Ave María') return 0;

    int count = 0;
    for (int i = 0; i <= _currentPasoIndex; i++) {
      if (_pasosBase[i] == 'Ave María') {
        count++;
      }
    }
    return count;
  }

  int get _activeBeadsCount {
    if (_pasoActual == 'Padre Nuestro') return 0;
    if (_pasoActual == 'Gloria' || _pasoActual == 'Jaculatoria') return 10;
    if (_pasoActual != 'Ave María') return 0;

    int count = 0;
    for (int i = 0; i <= _currentPasoIndex; i++) {
      if (_pasosBase[i] == 'Ave María') {
        count++;
      }
    }

    return count.clamp(0, 10);
  }

  Future<void> _toggleAmbientAudio() async {
    HapticFeedback.selectionClick();

    if (_soundEnabled) {
      await _audioService.pauseAmbient();
      if (!mounted) return;
      setState(() => _soundEnabled = false);
    } else {
      await _audioService.resumeAmbient();
      await _audioService.setVolume(_soundVolume);
      if (!mounted) return;
      setState(() => _soundEnabled = true);
    }
  }

  Future<void> _nextAudioVariant() async {
    HapticFeedback.selectionClick();
    await _audioService.nextVariant(volume: _soundVolume);
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _openAudioControls() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        double localVolume = _soundVolume;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: GlassSpiritualCard(
                  radius: 28,
                  blur: 18,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ambiente espiritual',
                        style: GoogleFonts.lora(
                          color: AppColors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Controla el sonido de fondo y cambia la variación del ambiente.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: AppColors.white.withValues(alpha: 0.74),
                          fontSize: 13.5,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: AppColors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _soundEnabled
                                      ? Icons.volume_up_rounded
                                      : Icons.volume_off_rounded,
                                  color: AppColors.lumenGold,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _audioService.currentAsset == null
                                        ? 'Sin audio cargado'
                                        : _audioService.currentAsset!
                                            .split('/')
                                            .last,
                                    style: GoogleFonts.poppins(
                                      color: AppColors.white.withValues(
                                        alpha: 0.82,
                                      ),
                                      fontSize: 12.8,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Slider(
                              value: localVolume,
                              min: 0,
                              max: 1,
                              onChanged: (value) async {
                                setSheetState(() => localVolume = value);
                                await _audioService.setVolume(value);
                                if (!mounted) return;
                                setState(() => _soundVolume = value);
                              },
                              activeColor: AppColors.lumenGold,
                              inactiveColor: AppColors.white.withValues(
                                alpha: 0.18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _SecondaryActionButton(
                              label: _soundEnabled ? 'Silenciar' : 'Activar',
                              onTap: () async {
                                await _toggleAmbientAudio();
                                if (!context.mounted) return;
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _SecondaryActionButton(
                              label: 'Cambiar audio',
                              onTap: () async {
                                await _nextAudioVariant();
                                if (!context.mounted) return;
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _PrimaryActionButton(
                        label: 'Cerrar',
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _nextPaso() {
    if (_pasoActual == 'Ave María') {
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.selectionClick();
    }

    if (_currentPasoIndex < _pasosBase.length - 1) {
      setState(() => _currentPasoIndex++);
      return;
    }

    if (_currentMisterioIndex < _misterios.length - 1) {
      setState(() {
        _currentMisterioIndex++;
        _currentPasoIndex = 0;
      });
      return;
    }

    _showFinishedDialog();
  }

  void _previousPaso() {
    HapticFeedback.selectionClick();

    if (_currentPasoIndex > 0) {
      setState(() => _currentPasoIndex--);
      return;
    }

    if (_currentMisterioIndex > 0) {
      setState(() {
        _currentMisterioIndex--;
        _currentPasoIndex = _pasosBase.length - 1;
      });
    }
  }

  void _showFinishedDialog() {
    showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: GlassSpiritualCard(
          radius: 28,
          blur: 18,
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.lumenGold,
                size: 34,
              ),
              const SizedBox(height: 14),
              Text(
                'Rosario completado',
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                  color: AppColors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Has finalizado este recorrido del Santo Rosario.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: AppColors.white.withValues(alpha: 0.76),
                  fontSize: 13.8,
                  height: 1.55,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _SecondaryActionButton(
                      label: 'Cerrar',
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _PrimaryActionButton(
                      label: 'Reiniciar',
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          _currentMisterioIndex = 0;
                          _currentPasoIndex = 0;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildProgressLabel() {
    if (_pasoActual == 'Ave María') {
      return '$_currentAveMariaNumber de 10';
    }
    return 'Paso ${_currentPasoIndex + 1} de ${_pasosBase.length}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _backgroundScale,
              builder: (_, child) {
                return Transform.scale(
                  scale: _backgroundScale.value,
                  child: child,
                );
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 800),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeOutCubic,
                child: _BackgroundImage(
                  key: ValueKey(_misterioActual.imagePath),
                  imagePath: _misterioActual.imagePath,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _particlesController,
                builder: (_, __) {
                  return CustomPaint(
                    painter: _ParticlesPainter(
                      progress: _particlesController.value,
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.18),
                    Colors.black.withValues(alpha: 0.34),
                    Colors.black.withValues(alpha: 0.62),
                    Colors.black.withValues(alpha: 0.86),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.78),
                    radius: 1.05,
                    colors: [
                      AppColors.lumenGold.withValues(alpha: 0.10),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 96),
              child: Column(
                children: [
                  _RosarioHeader(
                    soundEnabled: _soundEnabled,
                    onToggleSound: _toggleAmbientAudio,
                    onOpenAudioControls: _openAudioControls,
                  ),
                  const SizedBox(height: 14),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 420),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeOutCubic,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.04),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _MisterioHeroCard(
                      key: ValueKey(_misterioActual.imagePath),
                      misterio: _misterioActual,
                      currentMisterioIndex: _currentMisterioIndex,
                      totalMisterios: _misterios.length,
                    ),
                  ),
                  const SizedBox(height: 14),
                  GlassSpiritualCard(
                    radius: 24,
                    blur: 14,
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    child: Column(
                      children: [
                        _RosarioBeadsRow(activeCount: _activeBeadsCount),
                        const SizedBox(height: 12),
                        Text(
                          _pasoActual,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _buildProgressLabel(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 13.4,
                            color: AppColors.white.withValues(alpha: 0.72),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _ProgressSection(progress: _globalProgress),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 320),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeOutCubic,
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
                      title: _pasoActual,
                      text: RosarioDataService.getPrayerText(_pasoActual),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _SecondaryActionButton(
                          label: 'Anterior',
                          enabled: !(_currentMisterioIndex == 0 &&
                              _currentPasoIndex == 0),
                          onTap: _previousPaso,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: _PrimaryActionButton(
                          label:
                              _currentMisterioIndex == _misterios.length - 1 &&
                                      _currentPasoIndex == _pasosBase.length - 1
                                  ? 'Finalizar'
                                  : 'Siguiente',
                          onTap: _nextPaso,
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

class _RosarioHeader extends StatelessWidget {
  const _RosarioHeader({
    required this.soundEnabled,
    required this.onToggleSound,
    required this.onOpenAudioControls,
  });

  final bool soundEnabled;
  final VoidCallback onToggleSound;
  final VoidCallback onOpenAudioControls;

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
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onToggleSound,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withValues(alpha: 0.08),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Icon(
              soundEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
              color: soundEnabled ? AppColors.lumenGold : AppColors.white,
              size: 18,
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onOpenAudioControls,
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
              Icons.tune_rounded,
              color: AppColors.white,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}

class _MisterioHeroCard extends StatelessWidget {
  const _MisterioHeroCard({
    super.key,
    required this.misterio,
    required this.currentMisterioIndex,
    required this.totalMisterios,
  });

  final RosarioMisterioModel misterio;
  final int currentMisterioIndex;
  final int totalMisterios;

  @override
  Widget build(BuildContext context) {
    return GlassSpiritualCard(
      radius: 30,
      blur: 18,
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 250,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
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
                        fontWeight: FontWeight.w500,
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
                    stops: const [0.0, 0.28, 0.72, 1.0],
                    colors: [
                      Colors.black.withValues(alpha: 0.12),
                      Colors.black.withValues(alpha: 0.24),
                      AppColors.primaryBlue.withValues(alpha: 0.44),
                      Colors.black.withValues(alpha: 0.86),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              top: 16,
              child: Row(
                children: [
                  _GlassBadge(
                    icon: Icons.auto_awesome_rounded,
                    label:
                        'Misterio ${currentMisterioIndex + 1} de $totalMisterios',
                  ),
                  const SizedBox(width: 8),
                  _GlassBadge(
                    icon: Icons.favorite_rounded,
                    label: misterio.tituloCorto,
                  ),
                ],
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
                    misterio.titulo,
                    style: GoogleFonts.lora(
                      color: AppColors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      height: 1.08,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    misterio.subtitulo,
                    style: GoogleFonts.poppins(
                      color: AppColors.white.withValues(alpha: 0.86),
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
      ),
    );
  }
}

class _GlassBadge extends StatelessWidget {
  const _GlassBadge({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.lumenGold,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12.2,
              fontWeight: FontWeight.w600,
              color: AppColors.white.withValues(alpha: 0.92),
            ),
          ),
        ],
      ),
    );
  }
}

class _RosarioBeadsRow extends StatelessWidget {
  const _RosarioBeadsRow({
    required this.activeCount,
  });

  final int activeCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(10, (index) {
          final active = index < activeCount;

          return Padding(
            padding: EdgeInsets.only(right: index == 9 ? 0 : 6),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              width: active ? 18 : 14,
              height: active ? 18 : 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active
                    ? AppColors.lumenGold
                    : AppColors.white.withValues(alpha: 0.20),
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: AppColors.lumenGold.withValues(alpha: 0.35),
                          blurRadius: 10,
                          spreadRadius: -2,
                        ),
                      ]
                    : null,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({
    required this.progress,
  });

  final double progress;

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
                backgroundColor: AppColors.white.withValues(alpha: 0.16),
                valueColor: const AlwaysStoppedAnimation(
                  AppColors.lumenGold,
                ),
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
  const _PrayerTextCard({
    super.key,
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GlassSpiritualCard(
      radius: 26,
      blur: 16,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: AppColors.lumenGold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(
              fontSize: 17,
              height: 1.8,
              color: AppColors.white.withValues(alpha: 0.94),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [
              AppColors.lumenGold,
              AppColors.lumenGoldBright,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.lumenGold.withValues(alpha: 0.24),
              blurRadius: 16,
              spreadRadius: -8,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryActionButton extends StatelessWidget {
  const _SecondaryActionButton({
    required this.label,
    required this.onTap,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.45,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.06),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.18),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      errorBuilder: (_, __, ___) {
        return Container(
          color: AppColors.darkBackground,
        );
      },
    );
  }
}

class _ParticlesPainter extends CustomPainter {
  const _ParticlesPainter({
    required this.progress,
  });

  final double progress;

  static const List<_ParticleSeed> _seeds = [
    _ParticleSeed(0.08, 0.92, 0.018, 0.0),
    _ParticleSeed(0.18, 0.88, 0.014, 0.35),
    _ParticleSeed(0.28, 0.96, 0.022, 0.15),
    _ParticleSeed(0.40, 0.90, 0.012, 0.55),
    _ParticleSeed(0.52, 0.94, 0.016, 0.25),
    _ParticleSeed(0.64, 0.89, 0.020, 0.72),
    _ParticleSeed(0.76, 0.97, 0.014, 0.42),
    _ParticleSeed(0.86, 0.91, 0.018, 0.61),
    _ParticleSeed(0.14, 0.84, 0.010, 0.81),
    _ParticleSeed(0.58, 0.86, 0.015, 0.93),
    _ParticleSeed(0.92, 0.95, 0.012, 0.18),
    _ParticleSeed(0.33, 0.82, 0.021, 0.67),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final seed in _seeds) {
      final phase = (progress + seed.offset) % 1.0;
      final xDrift = math.sin((phase * math.pi * 2) + (seed.x * 10)) * 12.0;
      final x = (seed.x * size.width) + xDrift;
      final y = size.height * (seed.startY - (phase * 0.42));
      final radius = size.width * seed.radiusFactor;
      final opacity = (1 - phase) * 0.18;

      final paint = Paint()
        ..color = AppColors.lumenGold.withValues(alpha: opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _ParticleSeed {
  const _ParticleSeed(this.x, this.startY, this.radiusFactor, this.offset);

  final double x;
  final double startY;
  final double radiusFactor;
  final double offset;
}
