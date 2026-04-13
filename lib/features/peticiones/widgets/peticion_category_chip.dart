import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PeticionCategoryChip extends StatelessWidget {
  const PeticionCategoryChip({
    super.key,
    required this.categoria,
  });

  final String categoria;

  static const Color _gold = Color(0xFFD4AF37);
  static const Color _deepBlue = Color(0xFF0B1E66);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.14),
        ),
      ),
      child: Text(
        categoria,
        style: GoogleFonts.poppins(
          color: _gold,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
      ),
    );
  }
}
