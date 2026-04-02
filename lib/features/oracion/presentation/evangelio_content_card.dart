import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EvangelioContentCard extends StatelessWidget {
  const EvangelioContentCard({
    super.key,
    required this.fecha,
    required this.cita,
    required this.introduccion,
    required this.cuerpo,
    required this.destacado,
  });

  final String fecha;
  final String cita;
  final String introduccion;
  final String cuerpo;
  final String destacado;

  static const Color primaryBlue = Color(0xFF0B1E66);
  static const Color gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE5EAF5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            fecha,
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF9A7530),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(child: Divider(color: Color(0xFFE0D2AE))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.auto_awesome_rounded, size: 16, color: gold),
              ),
              const Expanded(child: Divider(color: Color(0xFFE0D2AE))),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            cita,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            introduccion,
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(
              fontSize: 17,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF33415C),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            cuerpo,
            textAlign: TextAlign.justify,
            style: GoogleFonts.poppins(
              fontSize: 15.2,
              height: 1.75,
              color: const Color(0xFF3E465C),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            destacado,
            textAlign: TextAlign.justify,
            style: GoogleFonts.poppins(
              fontSize: 16,
              height: 1.75,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              color: primaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}
