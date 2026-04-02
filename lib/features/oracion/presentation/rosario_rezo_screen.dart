import 'package:escoge/features/oracion/data/models/rosario_misterio_model.dart';
import 'package:escoge/features/oracion/services/rosario_data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class RosarioRezoScreen extends StatefulWidget {
  const RosarioRezoScreen({super.key, required this.tipoMisterio});

  final String tipoMisterio;

  @override
  State<RosarioRezoScreen> createState() => _RosarioRezoScreenState();
}

class _RosarioRezoScreenState extends State<RosarioRezoScreen> {
  static const Color softBackground = Color(0xFFF4F6FB);
  static const Color primaryBlue = Color(0xFF0B1E66);
  static const Color secondaryBlue = Color(0xFF1A3DAB);
  static const Color gold = Color(0xFFD4AF37);
  static const Color textSecondary = Color(0xFF6D7693);

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
          alignment: 0.2,
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
      setState(() {
        _currentPasoIndex++;
      });
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
      setState(() {
        _currentPasoIndex--;
      });
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
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Rosario completado',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              color: primaryBlue,
            ),
          ),
          content: Text(
            'Has finalizado este recorrido del Santo Rosario.',
            style: GoogleFonts.poppins(color: textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cerrar',
                style: GoogleFonts.poppins(
                  color: primaryBlue,
                  fontWeight: FontWeight.w700,
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
                backgroundColor: gold,
                foregroundColor: const Color(0xFF1A2340),
              ),
              child: Text(
                'Reiniciar',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );
  }

  double get _globalProgress {
    final totalSteps = _misterios.length * _pasosBase.length;
    final currentStep =
        (_currentMisterioIndex * _pasosBase.length) + _currentPasoIndex + 1;
    return currentStep / totalSteps;
  }

  int get _currentAveMariaNumber {
    final current = _pasosBase[_currentPasoIndex];
    if (current != 'Ave María') return 0;

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
    final currentPaso = _pasosBase[_currentPasoIndex];
    final percentage = (_globalProgress * 100).clamp(0, 100).toStringAsFixed(0);

    return Scaffold(
      backgroundColor: softBackground,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBlue, secondaryBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.14),
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Rezar el Rosario',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lora(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 58),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: softBackground,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 120),
                    child: Column(
                      children: [
                        _MisterioImageCard(imagePath: misterio.imagePath),
                        const SizedBox(height: 20),
                        Text(
                          misterio.tituloCorto,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          misterio.titulo,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lora(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A2340),
                            height: 1.08,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          misterio.subtitulo,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14.5,
                            color: textSecondary,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _RosarioBeadsRow(activeCount: _activeBeadsCount),
                        const SizedBox(height: 20),
                        Text(
                          currentPaso,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          currentPaso == 'Ave María'
                              ? '$_currentAveMariaNumber de 10'
                              : 'Paso ${_currentPasoIndex + 1} de ${_pasosBase.length}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14.5,
                            color: textSecondary,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _ProgressSection(
                          progress: _globalProgress,
                          percentage: '$percentage%',
                        ),
                        const SizedBox(height: 22),
                        Container(
                          key: _prayerKey,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
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
                              text: RosarioDataService.getPrayerText(
                                currentPaso,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: (_currentMisterioIndex == 0 &&
                                        _currentPasoIndex == 0)
                                    ? null
                                    : _previousPaso,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: primaryBlue,
                                  side: const BorderSide(
                                    color: Color(0xFFD4AF37),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: Text(
                                  'Anterior',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700,
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
                                  backgroundColor: gold,
                                  foregroundColor: const Color(0xFF1A2340),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Siguiente >',
                                  style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MisterioImageCard extends StatelessWidget {
  const _MisterioImageCard({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Container(
              color: const Color(0xFFE8EEF8),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16),
              child: Text(
                'No se pudo cargar:\n$imagePath',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF49516B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RosarioBeadsRow extends StatelessWidget {
  const _RosarioBeadsRow({required this.activeCount});

  final int activeCount;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 10,
      children: List.generate(10, (index) {
        final isActive = index < activeCount;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          width: isActive ? 28 : 24,
          height: isActive ? 28 : 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: isActive
                  ? const [Color(0xFFFFF2B8), Color(0xFFD4AF37)]
                  : const [Color(0xFFE9D9AA), Color(0xFFC7A86A)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border.all(
              color:
                  isActive ? const Color(0xFFF8E08A) : const Color(0xFFD2B57A),
              width: isActive ? 1.4 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isActive
                    ? const Color(0x66D4AF37)
                    : Colors.black.withValues(alpha: 0.08),
                blurRadius: isActive ? 12 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: isActive
              ? const Center(
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    size: 12,
                    color: Color(0xFF7A5B12),
                  ),
                )
              : null,
        );
      }),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({required this.progress, required this.percentage});

  final double progress;
  final String percentage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 16,
              backgroundColor: const Color(0xFFDCE4F5),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF1A3DAB)),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          percentage,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF5A6789),
          ),
        ),
      ],
    );
  }
}

class _PrayerTextCard extends StatelessWidget {
  const _PrayerTextCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 15,
          height: 1.75,
          color: const Color(0xFF49516B),
        ),
      ),
    );
  }
}
