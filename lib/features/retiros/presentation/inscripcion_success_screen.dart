import 'package:escoge/core/theme/app_backgrounds.dart';
import 'package:escoge/core/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InscripcionSuccessScreen extends StatefulWidget {
  final String retiroNombre;
  final String diocesis;

  const InscripcionSuccessScreen({
    super.key,
    required this.retiroNombre,
    required this.diocesis,
  });

  @override
  State<InscripcionSuccessScreen> createState() =>
      _InscripcionSuccessScreenState();
}

class _InscripcionSuccessScreenState extends State<InscripcionSuccessScreen>
    with SingleTickerProviderStateMixin {
  static const Color _gold = Color(0xFFD4AF37);
  static const Color _softGold = Color(0xFFE8C76A);
  static const Color _deepBlue = Color(0xFF0B1E66);

  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.84,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _cerrar(BuildContext context) {
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.of(context).pop(true);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AppBackground(
          background: AppBackgrounds.home,
          overlayOpacity: 0.24,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.14),
                        _deepBlue.withValues(alpha: 0.20),
                        Colors.black.withValues(alpha: 0.42),
                        Colors.black.withValues(alpha: 0.62),
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(18, 24, 18, 18 + bottom),
                  child: Column(
                    children: [
                      const Spacer(),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            children: [
                              ScaleTransition(
                                scale: _scaleAnimation,
                                child: Container(
                                  height: 112,
                                  width: 112,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFFDAB457),
                                        Color(0xFFB8860B),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _gold.withValues(alpha: 0.30),
                                        blurRadius: 26,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 58,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 28),
                              Text(
                                '¡Inscripción enviada!',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lora(
                                  fontSize: 31,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 1.08,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Tu solicitud para participar en este retiro fue recibida correctamente.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 14.5,
                                  color: Colors.white.withValues(alpha: 0.78),
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.07),
                              borderRadius: BorderRadius.circular(26),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.10),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Resumen',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: _softGold,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                _SummaryRow(
                                  label: 'Retiro',
                                  value: widget.retiroNombre,
                                ),
                                const SizedBox(height: 10),
                                _SummaryRow(
                                  label: 'Diócesis',
                                  value: widget.diocesis,
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: _gold.withValues(alpha: 0.10),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color:
                                          Colors.white.withValues(alpha: 0.08),
                                    ),
                                  ),
                                  child: Text(
                                    'Muy pronto el equipo organizador podrá contactarte para confirmar los próximos pasos.',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13.2,
                                      color:
                                          Colors.white.withValues(alpha: 0.82),
                                      height: 1.55,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.07),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.10),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Text(
                              '“Confía en el Señor de todo corazón.”',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lora(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                                color: _softGold,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed: () => _cerrar(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _gold,
                                  foregroundColor: _deepBlue,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: Text(
                                  'CONTINUAR',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: OutlinedButton(
                                onPressed: () => _cerrar(context),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.14),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: Text(
                                  'CERRAR',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white.withValues(alpha: 0.88),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({
    required this.label,
    required this.value,
  });

  static const Color _softGold = Color(0xFFE8C76A);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
          child: Text(
            '$label:',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _softGold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              color: Colors.white.withValues(alpha: 0.82),
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}
