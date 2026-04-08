import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileReflectionCard extends StatelessWidget {
  const ProfileReflectionCard({super.key});

  static const Color primaryBlue = Color(0xFF0B1E66);
  static const Color secondaryBlue = Color(0xFF1736A2);
  static const Color gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryBlue,
            secondaryBlue,
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.10),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: primaryBlue.withValues(alpha: 0.16),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: gold.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: gold.withValues(alpha: 0.16),
              ),
            ),
            child: Text(
              'Reflexión del día',
              style: GoogleFonts.poppins(
                color: gold,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '“Permanece firme, confía en el proceso y deja que Dios complete la obra en ti.”',
            style: GoogleFonts.lora(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Este espacio puede crecer más adelante con historial espiritual, favoritos, progreso en retiros y configuración de cuenta.',
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.82),
              fontSize: 12.6,
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
