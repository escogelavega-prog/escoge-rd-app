import 'package:escoge/core/theme/app_backgrounds.dart';
import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/core/widgets/app_background.dart';
import 'package:escoge/features/retiros/presentation/forms/inscripcion_fds_form.dart';
import 'package:escoge/features/retiros/presentation/forms/inscripcion_interna_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InscripcionScreen extends StatelessWidget {
  final String diocesis;
  final String retiroId;
  final String retiroNombre;
  final String tipoEvento;
  final String tipoInscripcion;

  const InscripcionScreen({
    super.key,
    required this.diocesis,
    required this.retiroId,
    required this.retiroNombre,
    this.tipoEvento = 'FDS',
    this.tipoInscripcion = 'fds_completa',
  });

  static const Color gold = Color(0xFFD4AF37);
  static const Color softGold = Color(0xFFE8C76A);
  static const Color _deepBlue = Color(0xFF0B1E66);

  bool get _esFds => tipoInscripcion == 'fds_completa';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      _deepBlue.withValues(alpha: 0.18),
                      Colors.black.withValues(alpha: 0.40),
                      Colors.black.withValues(alpha: 0.58),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  _PremiumTopBar(
                    title: 'Inscripción',
                    subtitle: retiroNombre,
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.14),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _InscripcionHeroHeader(
                            retiroNombre: retiroNombre,
                            diocesis: diocesis,
                            tipoEvento: tipoEvento,
                            esFds: _esFds,
                          ),
                          const SizedBox(height: 4),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(28),
                              ),
                              child: Container(
                                color: AppColors.background,
                                child: _esFds
                                    ? InscripcionFdsForm(
                                        diocesis: diocesis,
                                        retiroId: retiroId,
                                        retiroNombre: retiroNombre,
                                        tipoEvento: tipoEvento,
                                      )
                                    : InscripcionInternaForm(
                                        diocesis: diocesis,
                                        retiroId: retiroId,
                                        retiroNombre: retiroNombre,
                                        tipoEvento: tipoEvento,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

class _PremiumTopBar extends StatelessWidget {
  final String title;
  final String subtitle;

  const _PremiumTopBar({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(18),
              child: Ink(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
              ),
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
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    color: Colors.white.withValues(alpha: 0.70),
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

class _InscripcionHeroHeader extends StatelessWidget {
  final String retiroNombre;
  final String diocesis;
  final String tipoEvento;
  final bool esFds;

  const _InscripcionHeroHeader({
    required this.retiroNombre,
    required this.diocesis,
    required this.tipoEvento,
    required this.esFds,
  });

  static const Color gold = Color(0xFFD4AF37);
  static const Color _softGold = Color(0xFFE8C76A);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _HeaderChip(
                icon: Icons.event_available_rounded,
                label: esFds ? 'Formulario FDS' : 'Formulario interno',
              ),
              if (tipoEvento.trim().isNotEmpty)
                _HeaderChip(
                  icon: Icons.auto_awesome_rounded,
                  label: tipoEvento,
                ),
              if (diocesis.trim().isNotEmpty)
                _HeaderChip(
                  icon: Icons.church_rounded,
                  label: diocesis,
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            retiroNombre,
            style: GoogleFonts.lora(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.2,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Completa tu inscripción con atención. Este paso nos ayudará a acompañarte mejor en tu experiencia.',
            style: GoogleFonts.poppins(
              fontSize: 13.2,
              height: 1.55,
              color: Colors.white.withValues(alpha: 0.78),
            ),
          ),
          const SizedBox(height: 2),
          Divider(
            color: _softGold.withValues(alpha: 0.20),
            height: 24,
          ),
        ],
      ),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeaderChip({
    required this.icon,
    required this.label,
  });

  static const Color _gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: _gold.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: _gold,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: _gold,
            ),
          ),
        ],
      ),
    );
  }
}
