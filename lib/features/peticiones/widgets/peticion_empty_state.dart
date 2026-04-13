import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PeticionEmptyState extends StatelessWidget {
  const PeticionEmptyState({
    super.key,
    required this.onNuevaPeticion,
  });

  final VoidCallback onNuevaPeticion;

  static const Color _primaryBlue = Color(0xFF0B1E66);
  static const Color _gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _gold.withValues(alpha: 0.14),
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              color: _gold,
              size: 34,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Aún no hay peticiones',
            style: GoogleFonts.poppins(
              color: const Color(0xFF16213E),
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sé el primero en compartir una intención de oración con la comunidad.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: const Color(0xFF6D7693),
              fontSize: 13.2,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: onNuevaPeticion,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Nueva petición'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
