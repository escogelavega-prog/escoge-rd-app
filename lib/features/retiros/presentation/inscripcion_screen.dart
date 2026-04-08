import 'package:escoge/core/theme/app_colors.dart';
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

  bool get _esFds => tipoInscripcion == 'fds_completa';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Inscripción',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
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
    );
  }
}
